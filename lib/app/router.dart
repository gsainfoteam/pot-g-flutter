import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/user/data/data_source/constant/term_storage.dart';
import 'package:pot_g/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple((resolver, router) async {
      // splash -> 항상 표시
      // 인증 확인
      // - 인증 됨
      //   - 약관 동의 안 됨 -> 동의 페이지 -> 이후 리다이렉트
      // - 인증 안됨
      //   - list page, login page -> 통과
      //   - 이외 페이지 -> 로그인 페이지로 리다이렉트 -> 이후 리다이렉트
      if (resolver.route.name == SplashRoute.name) {
        return resolver.next(true);
      }
      final context = router.navigatorKey.currentContext;
      if (context == null) return resolver.next(false);
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        if (resolver.route.name == LoginRoute.name) {
          return resolver.next(false);
        }
        if (resolver.route.name == ConsentRoute.name ||
            user.agreedTerms.allRequired) {
          return resolver.next(true);
        }
        await resolver.redirectUntil(ConsentRoute(onDone: () {}));
        return;
      }
      if (resolver.route.name == MainBottomNavigationRoute.name ||
          resolver.route.name == ListRoute.name ||
          resolver.route.name == LoginRoute.name) {
        return resolver.next(true);
      }
      await resolver.redirectUntil(
        LoginRoute(
          onDone: () => resolver.resolveNext(true, reevaluateNext: false),
          onConsent: () => resolver.next(true),
          onCancel: () {
            if (!resolver.isResolved) {
              resolver.next(false);
            } else {
              L.e('login router already resolved', StackTrace.current);
            }
          },
        ),
      );
    }),
  ];

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: SplashRoute.page),
    AutoRoute(
      path: '/main',
      page: MainBottomNavigationRoute.page,
      children: [
        AutoRoute(path: '', page: ListRoute.page),
        AutoRoute(path: 'chat', page: ChatRoute.page),
        AutoRoute(path: 'profile', page: ProfileRoute.page),
      ],
    ),
    CustomRoute(
      path: '/create',
      page: CreateRoute.page,
      customRouteBuilder: <T>(context, child, page) =>
          Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoSheetRoute<T>(settings: page, builder: (_) => child)
          : MaterialPageRoute<T>(settings: page, builder: (_) => child),
    ),
    AutoRoute(path: '/chat/:id', page: ChatRoomRoute.page),
    AutoRoute(path: '/chat/:id/accounting', page: AccountingRoute.page),
    AutoRoute(path: '/chat/:id/report', page: ReportRoute.page),
    CustomRoute(
      path: '/invited/:id',
      page: InvitedRoute.page,
      customRouteBuilder: <T>(context, child, page) => DialogRoute<T>(
        context: context,
        settings: page,
        barrierColor: Colors.transparent,
        builder: (_) => child,
      ),
    ),

    // settings
    AutoRoute(
      path: '/settings/account-number',
      page: AccountNumberSettingsRoute.page,
    ),
    AutoRoute(
      path: '/settings/notification',
      page: NotificationSettingRoute.page,
    ),
    AutoRoute(
      path: '/settings/account-management',
      page: AccountManagementRoute.page,
    ),

    // user
    AutoRoute(path: '/user/consent', page: ConsentRoute.page),
    CustomRoute(
      path: '/user/login',
      page: LoginRoute.page,
      customRouteBuilder: <T>(context, child, page) => DialogRoute<T>(
        context: context,
        settings: page,
        barrierColor: Colors.transparent,
        builder: (_) => child,
      ),
    ),
  ];
}
