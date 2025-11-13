import 'package:pot_g/app/modules/chat/domain/entities/accounting_result_entity.dart';

abstract interface class PotAccountingInfoEntity {
  String? get requestingUser;
  int? get totalCost;
  int? get costPerUser;
  String? get bankName;
  String? get bankAccount;
  List<AccountingResultEntity> get accountingResults;
}
