import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract interface class RouteListRepository {
  Future<List<RouteEntity>> getRouteList();
}
