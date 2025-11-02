import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/taxi_app_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/stop_entity.dart';
import 'package:url_launcher/url_launcher.dart';

@Injectable(as: TaxiAppRepository)
class DeepLinkTaxiAppRepository implements TaxiAppRepository {
  @override
  Future<void> callTaxi(TaxiAppType type, RouteEntity route) async {
    final deepLink = _getDeepLink(type, route);
    if (await canLaunchUrl(deepLink)) {
      await launchUrl(deepLink);
    } else {
      await launchUrl(_getStoreUrl(type));
    }
  }

  Uri _getDeepLink(TaxiAppType type, RouteEntity route) {
    switch (type) {
      case TaxiAppType.kakaoT:
        return Uri(
          scheme: 'kakaoT',
          host: 'taxi',
          path: '/set',
          queryParameters: {
            'origin_lat': route.from.latitude.toString(),
            'origin_lng': route.from.longitude.toString(),
            'origin_name': route.from.name,
            'destination_lat': route.to.latitude.toString(),
            'destination_lng': route.to.longitude.toString(),
            'destination_name': route.to.name,
          },
        );
      case TaxiAppType.uber:
        return Uri.parse('uber://taxi?route=${route.id}');
      case TaxiAppType.tMoney:
        return Uri.parse('tMoney://taxi?route=${route.id}');
    }
  }

  Uri _getStoreUrl(TaxiAppType type) {
    if (Platform.isAndroid) return Uri.parse(type.androidStoreUrl);
    return Uri.parse(type.iOSStoreUrl);
  }
}
