import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_departure_time_request_model.freezed.dart';
part 'confirm_departure_time_request_model.g.dart';

@Freezed(toJson: true)
sealed class ConfirmDepartureTimeRequestModel
    with _$ConfirmDepartureTimeRequestModel {
  const factory ConfirmDepartureTimeRequestModel({
    required DateTime departureTime,
  }) = _ConfirmDepartureTimeRequestModel;
}
