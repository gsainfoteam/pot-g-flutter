import 'package:auto_route/auto_route.dart';
import 'package:pot_g/app/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Layout,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    RedirectRoute(path: '/', redirectTo: '/splash'),
    AutoRoute(path: '/splash', page: SplashRoute.page),
    AutoRoute(path: '/main', page: MainBottomNavigationRoute.page),
  ];
}
