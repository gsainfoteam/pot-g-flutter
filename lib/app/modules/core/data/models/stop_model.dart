import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/domain/entities/stop_entity.dart';

part 'stop_model.freezed.dart';
part 'stop_model.g.dart';

@freezed
sealed class StopModel with _$StopModel implements StopEntity {
  const factory StopModel({required String id, required String name}) =
      _StopModel;

  factory StopModel.fromJson(Map<String, dynamic> json) =>
      _$StopModelFromJson(json);
}
