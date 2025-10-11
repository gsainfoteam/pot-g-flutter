import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

abstract class PotActionRepository {
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date);
  Future<void> leavePot(PotInfoEntity pot);
  Future<void> kickUser(PotInfoEntity pot, PotUserEntity user);
}
