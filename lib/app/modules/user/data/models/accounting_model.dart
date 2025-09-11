import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_model.freezed.dart';
part 'accounting_model.g.dart';

@freezed
sealed class AccountingModel with _$AccountingModel {
  const factory AccountingModel({
    required bool isSet,
    required String bankShortName,
    required String account,
  }) = _AccountingModel;

  factory AccountingModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingModelFromJson(json);
}
