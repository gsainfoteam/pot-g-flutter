import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_confirm_response_model.freezed.dart';
part 'accounting_confirm_response_model.g.dart';

@Freezed(toJson: false)
sealed class AccountingConfirmResponseModel
    with _$AccountingConfirmResponseModel {
  const factory AccountingConfirmResponseModel({required String result}) =
      _AccountingConfirmResponseModel;

  factory AccountingConfirmResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingConfirmResponseModelFromJson(json);
}
