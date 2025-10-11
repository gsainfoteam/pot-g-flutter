import 'package:pot_g/app/modules/chat/data/models/accounting_result_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

abstract class PotAccountingRepository {
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
