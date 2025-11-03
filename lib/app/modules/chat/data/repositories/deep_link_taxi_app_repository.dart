// spell-checker:words kakaoT taxi tmoney tmoneytia onda riderequest dropoff
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/repositories/deep_link_repository.dart';
import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/taxi_app_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

@Injectable(as: TaxiAppRepository)
class DeepLinkTaxiAppRepository
    extends DeepLinkRepository<TaxiAppType, RouteEntity>
    implements TaxiAppRepository {
  @override
  Uri getDeepLink(TaxiAppType type, RouteEntity route) {
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
      case TaxiAppType.tmoney:
        return Uri(scheme: 'tmoneytia', host: 'onda', path: '/main');
    }
  }

  @override
  Uri? getWebUrl(TaxiAppType type, RouteEntity entity) {
    switch (type) {
      case TaxiAppType.uber:
        return Uri(
          scheme: 'https',
          host: 'm.uber.com',
          path: '/looking',
          queryParameters: {
            'pickup': jsonEncode({
              'latitude': entity.from.lat,
              'longitude': entity.from.lng,
              'addressLine1': entity.from.name,
            }),
            'drop[0]': jsonEncode({
              'latitude': entity.to.lat,
              'longitude': entity.to.lng,
              'addressLine1': entity.to.name,
            }),
          },
        );
      default:
        return null;
    }
  }
}
