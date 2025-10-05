import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/route_list_bloc.dart';
import 'package:pot_g/app/modules/socket/presentation/bloc/socket_auth_bloc.dart';
import 'package:pot_g/app/router.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/theme.dart';
import 'package:pot_g/gen/strings.g.dart';

final _appRouter = AppRouter();

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
          routerConfig: _appRouter.config(),
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          builder:
              (_, child) => _Providers(child: child ?? const SizedBox.shrink()),
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
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
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
        ],
        child: child,
      ),
    );
  }
}
