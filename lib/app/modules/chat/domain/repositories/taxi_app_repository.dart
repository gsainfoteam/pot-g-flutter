import 'package:pot_g/app/modules/chat/domain/enums/taxi_app_type.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract class TaxiAppRepository {
  Future<void> action(TaxiAppType type, RouteEntity route);
}
