import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';

abstract class PotInfoRepository {
  Stream<PotInfoEntity> getPotInfoStream(PotInfoEntity pot);
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date);
}
