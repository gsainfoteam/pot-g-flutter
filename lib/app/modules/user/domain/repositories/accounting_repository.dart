import 'package:pot_g/app/modules/user/domain/entities/accounting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';

abstract class AccountingRepository {
  Future<AccountingEntity> setAccounting(BankEntity bank, String accountNumber);
  Future<List<BankEntity>> getBankList();
}
