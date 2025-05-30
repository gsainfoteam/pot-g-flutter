import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/models/stop_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
sealed class RouteModel with _$RouteModel implements RouteEntity {
  const factory RouteModel({
    required String id,
    required StopModel from,
    required StopModel to,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}
