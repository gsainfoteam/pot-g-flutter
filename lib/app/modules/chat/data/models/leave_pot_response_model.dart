import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_pot_response_model.freezed.dart';
part 'leave_pot_response_model.g.dart';

@Freezed(toJson: false)
sealed class LeavePotResponseModel with _$LeavePotResponseModel {
  const factory LeavePotResponseModel({required LeavePotResult result}) =
      _LeavePotResponseModel;

  factory LeavePotResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LeavePotResponseModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum LeavePotResult {
  @JsonValue('OK')
  ok,
  afterDepartureConfirmed,
  notYetPaymentConfirmed,
  notYetPaymentCompleted,
  potNotExist,
  potAlreadyClosed,
}
