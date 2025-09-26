import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_accounting_model.freezed.dart';
part 'set_accounting_model.g.dart';

@freezed
sealed class SetAccountingModel with _$SetAccountingModel {
  const factory SetAccountingModel({
    required String bankPk,
    required String account,
  }) = _SetAccountingModel;

  factory SetAccountingModel.fromJson(Map<String, dynamic> json) =>
      _$SetAccountingModelFromJson(json);
}
