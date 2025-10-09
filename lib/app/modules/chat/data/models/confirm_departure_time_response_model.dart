import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_departure_time_response_model.freezed.dart';
part 'confirm_departure_time_response_model.g.dart';

@Freezed(toJson: false)
sealed class ConfirmDepartureTimeResponseModel
    with _$ConfirmDepartureTimeResponseModel {
  const factory ConfirmDepartureTimeResponseModel({
    required PotDepartureTimeResult result,
  }) = _ConfirmDepartureTimeResponseModel;

  factory ConfirmDepartureTimeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ConfirmDepartureTimeResponseModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum PotDepartureTimeResult {
  @JsonValue('OK')
  ok,
  notAHost,
  afterDeparture,
  beforeNow,
  potNotExist,
  potAlreadyClosed,
}
