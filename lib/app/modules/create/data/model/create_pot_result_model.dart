import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_pot_result_model.freezed.dart';
part 'create_pot_result_model.g.dart';

@Freezed(toJson: false)
sealed class CreatePotResultModel with _$CreatePotResultModel {
  const factory CreatePotResultModel({required String id}) =
      _CreatePotResultModel;

  factory CreatePotResultModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePotResultModelFromJson(json);
}
