import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';

abstract class PotInfoRepository {
  Stream<PotInfoEntity> getPotInfoStream(PotDetailEntity pot);
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date);
  Future<void> kickUser(PotInfoEntity pot, PotUserEntity user);
}
