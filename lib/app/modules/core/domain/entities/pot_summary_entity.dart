import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract class PotSummaryEntity implements PotIdEntity {
  String get name;
  RouteEntity get route;
  DateTime get startsAt;
  DateTime get endsAt;
  int get current;
  int get total;
}
