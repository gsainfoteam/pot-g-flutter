import 'package:freezed_annotation/freezed_annotation.dart';

part 'kick_user_response_model.freezed.dart';
part 'kick_user_response_model.g.dart';

@Freezed(toJson: false)
sealed class KickUserResponseModel with _$KickUserResponseModel {
  const factory KickUserResponseModel({required KickUserResult result}) =
      _KickUserResponseModel;

  factory KickUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$KickUserResponseModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum KickUserResult {
  @JsonValue('OK')
  ok,
  notAHost,
  notAParticipant,
  userNotInPot,
  afterDepartureConfirmed,
  notYetPaymentConfirmed,
  potNotExist,
  potAlreadyClosed,
}
