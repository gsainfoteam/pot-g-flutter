import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_result_model.freezed.dart';
part 'accounting_result_model.g.dart';

@freezed
sealed class AccountingResultModel with _$AccountingResultModel {
  const factory AccountingResultModel({
    required String userPk,
    required bool accountingDone,
  }) = _AccountingResultModel;

  factory AccountingResultModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingResultModelFromJson(json);
}
