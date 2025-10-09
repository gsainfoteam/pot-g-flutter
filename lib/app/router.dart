import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/functions/try_login.dart';
import 'package:pot_g/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple((resolver, router) async {
      if (resolver.route.name == SplashRoute.name ||
          resolver.route.name == MainBottomNavigationRoute.name ||
          resolver.route.name == ListRoute.name) {
        return resolver.next(true);
      }
      final context = router.navigatorKey.currentContext;
      if (context == null) return resolver.next(false);
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        return resolver.next(true);
      }
      if (await tryLogin(context)) {
        return resolver.next(true);
      }
      return resolver.next(false);
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
    AutoRoute(path: '/create', page: CreateRoute.page),
    AutoRoute(path: '/chat/:id', page: ChatRoomRoute.page),
    AutoRoute(path: '/chat/:id/accounting', page: AccountingRoute.page),

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
  ];
}
