import 'package:pot_g/app/modules/chat/domain/entities/pot_users_info_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract class PotOverviewEntity {
  String get id;
  String get name;
  RouteEntity get route;
  DateTime get startsAt;
  DateTime get endsAt;
  PotUsersInfoEntity get usersInfo;
}
