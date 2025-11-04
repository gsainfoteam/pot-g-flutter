import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log_page.dart';

class LogObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings is AutoRoutePage) {
      log('Routing: ${route.settings.name}', name: 'router');
      final page = route.settings as AutoRoutePage;
      if (page.child is LogPage) {
        final logPage = page.child as LogPage;
        L.setCurrentPage(logPage.pageName, properties: logPage.pageProperties);
      }
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings is AutoRoutePage) {
      log('Popping from: ${route.settings.name}', name: 'router');
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    log('Changing tab to: ${route.routeInfo.name}', name: 'router');
    final pageName = route.routeInfo.meta['pageName'];
    if (pageName is String) {
      L.setCurrentPage(pageName);
    }
    super.didChangeTabRoute(route, previousRoute);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    log('Initializing tab to: ${route.routeInfo.name}', name: 'router');
    final pageName = route.routeInfo.meta['pageName'];
    if (pageName is String) {
      L.setCurrentPage(pageName);
    }
    super.didInitTabRoute(route, previousRoute);
  }
}
