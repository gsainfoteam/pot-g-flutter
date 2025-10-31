import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/domain/exceptions/authorization_exception.dart'
    as auth_exception;
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_detail_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_observer.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/api_channel_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/app_version_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/messaging_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/route_list_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/widgets/update_listener.dart';
import 'package:pot_g/app/modules/socket/presentation/bloc/socket_auth_bloc.dart';
import 'package:pot_g/app/router.dart';
import 'package:pot_g/app/router.gr.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/theme.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:rxdart/rxdart.dart';

final _router = sl<AppRouter>();

class PotApp extends StatelessWidget {
  const PotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: Palette.white),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp.router(
          theme: PotTheme.theme,
          routerConfig: _router.config(
            navigatorObservers: () => [AutoRouteObserver(), LogObserver()],
            reevaluateListenable: ReevaluateListenable.stream(
              MergeStream([
                sl<AuthBloc>().stream.map((state) => state.user).distinct(),
              ]),
            ),
          ),
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          builder: (_, child) =>
              _Providers(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}

class _Providers extends StatelessWidget {
  const _Providers({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthEvent.load())),
        BlocProvider(
          create: (_) => sl<RouteListBloc>()..add(RouteListEvent.search()),
        ),
        BlocProvider(create: (_) => sl<SocketAuthBloc>()),
        BlocProvider(
          lazy: false,
          create: (_) => sl<MessagingBloc>()..add(const MessagingEvent.init()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<LinkBloc>()..add(const LinkEvent.init()),
        ),
        BlocProvider(lazy: false, create: (_) => sl<PotDetailBloc>()),
        BlocProvider(
          create: (_) =>
              sl<ApiChannelBloc>()..add(const ApiChannelEvent.init()),
        ),
        BlocProvider(create: (_) => sl<AppVersionBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => previous.user != current.user,
            listener: (context, state) {
              L.setUserId(state.user?.id);
              if (state.user != null) {
                L.setUserProperties({
                  'email': state.user!.email,
                  'name': state.user!.name,
                });
                context.read<PotDetailBloc>().add(
                  const PotDetailEvent.loadMyPots(),
                );
              }
              final event = switch (state) {
                Authenticated() => SocketAuthEvent.connect(),
                Unauthenticated() => SocketAuthEvent.disconnect(),
                _ => null,
              };
              if (event != null) {
                context.read<SocketAuthBloc>().add(event);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current.mapOrNull(
                  authenticated: (_) => true,
                  unauthenticated: (_) => true,
                ) ??
                false,
            listener: (context, state) => context.read<MessagingBloc>().add(
              const MessagingEvent.refresh(),
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                current.mapOrNull(error: (_) => true) ?? false,
            listener: (context, state) => state.mapOrNull(
              error: (e) => context.showToast(switch (e.error) {
                auth_exception.NetworkErrorException(:final error) =>
                  '${context.t.login.errors.network_error}: $error',
                auth_exception.InvalidAuthorizationStateException() =>
                  context.t.login.errors.invalid_authorization_state,
                auth_exception.InvalidAuthorizationCodeException() =>
                  context.t.login.errors.invalid_authorization_code,
                auth_exception.UnknownException(:final error) =>
                  '${context.t.login.errors.unknown}: $error',
              }),
            ),
          ),
          BlocListener<LinkBloc, LinkState>(
            listener: (context, state) => state.mapOrNull(
              loaded: (s) => WidgetsBinding.instance.addPostFrameCallback((_) {
                _router.pushPath(s.link);
              }),
            ),
          ),
          BlocListener<ApiChannelBloc, ApiChannelState>(
            listenWhen: (prev, curr) =>
                prev.channel != null &&
                curr.channel != null &&
                prev.channel != curr.channel,
            listener: (context, state) {
              context.read<AuthBloc>().add(AuthEvent.logout());
              context.read<RouteListBloc>().add(const RouteListEvent.search());
              _router.replaceAll([ListRoute()]);
            },
          ),
        ],
        child: UpdateListener(child: child),
      ),
    );
  }
}
