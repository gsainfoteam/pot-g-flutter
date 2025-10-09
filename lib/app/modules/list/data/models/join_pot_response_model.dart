import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_pot_response_model.freezed.dart';
part 'join_pot_response_model.g.dart';

@Freezed(toJson: false)
sealed class JoinPotResponseModel with _$JoinPotResponseModel {
  const factory JoinPotResponseModel({required JoinPotResult result}) =
      _JoinPotResponseModel;

  factory JoinPotResponseModel.fromJson(Map<String, dynamic> json) =>
      _$JoinPotResponseModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum JoinPotResult {
  @JsonValue('OK')
  ok,
  afterDepartureConfirmed,
  potNotExist,
  potAlreadyClosed,
  potFull,
}
