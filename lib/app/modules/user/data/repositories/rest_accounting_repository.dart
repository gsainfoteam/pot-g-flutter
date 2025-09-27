import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/user/data/data_source/remote/accounting_api.dart';
import 'package:pot_g/app/modules/user/data/models/set_accounting_model.dart';
import 'package:pot_g/app/modules/user/domain/entities/accounting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/accounting_repository.dart';

@Injectable(as: AccountingRepository)
class RestAccountingRepository implements AccountingRepository {
  final AccountingApi _accountingApi;
  RestAccountingRepository(this._accountingApi);

  @override
  Future<List<BankEntity>> getBankList() {
    return _accountingApi.getBankList();
  }

  @override
  Future<AccountingEntity> setAccounting(
    BankEntity bank,
    String accountNumber,
  ) {
    return _accountingApi.setAccounting(
      SetAccountingModel(bankPk: bank.id, account: accountNumber),
    );
  }
}
