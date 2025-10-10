import 'package:pot_g/app/modules/chat/data/models/accounting_result_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';

abstract class PotInfoRepository {
  Stream<PotInfoEntity> getPotInfoStream(PotIdEntity pot);
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date);
  Future<void> leavePot(PotInfoEntity pot);
  Future<void> kickUser(PotInfoEntity pot, PotUserEntity user);
  Future<void> accounting(
    PotInfoEntity pot,
    int amount,
    List<PotUserEntity> targets,
  );
  Future<void> confirmAccounting(
    PotInfoEntity pot,
    List<AccountingResultModel> accountingResults,
  );
}
