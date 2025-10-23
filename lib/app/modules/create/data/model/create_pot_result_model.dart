import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_pot_result_model.freezed.dart';
part 'create_pot_result_model.g.dart';

@Freezed(toJson: false)
sealed class CreatePotResultModel with _$CreatePotResultModel {
  const factory CreatePotResultModel({
    required String? id,
    required CreatePotResult result,
  }) = _CreatePotResultModel;

  factory CreatePotResultModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePotResultModelFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum CreatePotResult {
  @JsonValue('OK')
  ok,
  invalidCapacity,
  departureAvailableBeforeNow,
  invalidDepartureAvailableTime,
  tooFarDepartureAvailableTime,
}
