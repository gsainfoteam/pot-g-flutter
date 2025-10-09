import 'package:pot_g/app/modules/chat/domain/entities/pot_users_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract class PotInfoEntity implements PotIdEntity {
  String get name;
  RouteEntity get route;
  DateTime get startsAt;
  DateTime get endsAt;
  DateTime? get departureTime;
  PotStatus get status;
  PotUsersInfoEntity get usersInfo;
}
