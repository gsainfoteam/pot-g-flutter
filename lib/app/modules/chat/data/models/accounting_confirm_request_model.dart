import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_result_model.dart';

part 'accounting_confirm_request_model.freezed.dart';
part 'accounting_confirm_request_model.g.dart';

@Freezed(toJson: true)
sealed class AccountingConfirmRequestModel
    with _$AccountingConfirmRequestModel {
  const factory AccountingConfirmRequestModel({
    required List<AccountingResultModel> accountingResults,
  }) = _AccountingConfirmRequestModel;
}
