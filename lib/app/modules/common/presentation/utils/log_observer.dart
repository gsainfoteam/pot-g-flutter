import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';

class LogObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings is AutoRoutePage) {
      final page = route.settings as AutoRoutePage;
      if (page.child is LogPage) {
        final logPage = page.child as LogPage;
        L.setCurrentPage(logPage.pageName);
      }
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    final pageName = route.routeInfo.meta['pageName'];
    if (pageName is String) {
      L.setCurrentPage(pageName);
    }
    super.didChangeTabRoute(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    final pageName = route.routeInfo.meta['pageName'];
    if (pageName is String) {
      L.setCurrentPage(pageName);
    }
    super.didInitTabRoute(route, previousRoute);
  }
}
