import 'package:pot_g/app/modules/main/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/main/domain/entities/route_entity.dart';

abstract class PotListRepository {
  Future<List<PotEntity>> getPotList({DateTime? date, RouteEntity? route});
}
