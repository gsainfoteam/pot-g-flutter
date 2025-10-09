import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/data/enums/pot_departure_time_result.dart';

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
