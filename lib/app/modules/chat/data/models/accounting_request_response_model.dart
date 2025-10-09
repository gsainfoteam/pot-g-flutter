import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_request_response_model.freezed.dart';
part 'accounting_request_response_model.g.dart';

@Freezed(toJson: false)
sealed class AccountingRequestResponseModel
    with _$AccountingRequestResponseModel {
  const factory AccountingRequestResponseModel({
    required AccountingResult result,
  }) = _AccountingRequestResponseModel;

  factory AccountingRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountingRequestResponseModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum AccountingResult {
  @JsonValue('OK')
  ok,
  alreadyRequested,
  accountInfoNotSet,
  costCannotBeNegative,
  costPerUserMismatch,
  beforeDeparture,
  notAParticipant,
  potNotExist,
  potAlreadyClosed,
}
