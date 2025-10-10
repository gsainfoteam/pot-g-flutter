import 'package:pot_g/app/modules/chat/data/models/accounting_result_model.dart';

abstract class PotAccountingInfoEntity {
  String? get requestingUser;
  int? get totalCost;
  int? get costPerUser;
  String? get bankName;
  String? get bankAccount;
  List<AccountingResultModel> get accountingResults;
}
