import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/taxi_app_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';
import 'package:url_launcher/url_launcher.dart';

@Injectable(as: TaxiAppRepository)
class DeepLinkTaxiAppRepository implements TaxiAppRepository {
  @override
  Future<void> callTaxi(TaxiAppType type, RouteEntity route) async {
    final deepLink = _getDeepLink(type, route);
    if (await canLaunchUrl(deepLink)) {
      await launchUrl(deepLink);
    } else {
      final webUrl = _getWebUrl(type, route);
      if (webUrl != null && await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        await launchUrl(_getStoreUrl(type));
      }
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
            'origin_lat': route.from.lat.toString(),
            'origin_lng': route.from.lng.toString(),
            'origin_name': route.from.name,
            'destination_lat': route.to.lat.toString(),
            'destination_lng': route.to.lng.toString(),
            'destination_name': route.to.name,
          },
        );
      case TaxiAppType.uber:
        return Uri(
          scheme: 'uber',
          host: 'riderequest',
          queryParameters: {
            'pickup[latitude]': route.from.lat.toString(),
            'pickup[longitude]': route.from.lng.toString(),
            'pickup[nickname]': route.from.name,
            'dropoff[latitude]': route.to.lat.toString(),
            'dropoff[longitude]': route.to.lng.toString(),
            'dropoff[nickname]': route.to.name,
          },
        );
      case TaxiAppType.tMoney:
        return Uri.parse('tMoney://taxi?route=${route.id}');
    }
  }

  Uri? _getWebUrl(TaxiAppType type, RouteEntity route) {
    switch (type) {
      case TaxiAppType.uber:
        return Uri(
          scheme: 'https',
          host: 'm.uber.com',
          path: '/looking',
          queryParameters: {
            'pickup': jsonEncode({
              'latitude': route.from.lat,
              'longitude': route.from.lng,
              'addressLine1': route.from.name,
            }),
            'drop[0]': jsonEncode({
              'latitude': route.to.lat,
              'longitude': route.to.lng,
              'addressLine1': route.to.name,
            }),
          },
        );
      default:
        return null;
    }
  }

  Uri _getStoreUrl(TaxiAppType type) {
    if (Platform.isAndroid) return Uri.parse(type.androidStoreUrl);
    return Uri.parse(type.iOSStoreUrl);
  }
}
