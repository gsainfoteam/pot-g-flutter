import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';

part 'pot_model.freezed.dart';
part 'pot_model.g.dart';

@freezed
sealed class PotModel with _$PotModel implements PotEntity {
  factory PotModel({
    required String id,
    required RouteModel route,
    required DateTime startsAt,
    required DateTime endsAt,
    required int current,
    required int total,
  }) = _PotModel;

  factory PotModel.fromJson(Map<String, dynamic> json) =>
      _$PotModelFromJson(json);
}
