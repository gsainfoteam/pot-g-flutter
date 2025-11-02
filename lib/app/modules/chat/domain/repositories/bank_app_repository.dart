import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/bank_app_type.dart';

abstract class BankAppRepository {
  Future<void> sendMoney(BankAppType type, PotAccountingInfoEntity account);
}
