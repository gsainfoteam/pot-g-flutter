import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';

part 'pot_model.freezed.dart';
part 'pot_model.g.dart';

@freezed
sealed class PotModel with _$PotModel implements PotSummaryEntity {
  factory PotModel({
    required String id,
    required String name,
    required RouteModel route,
    @dateTimeConverter required DateTime startsAt,
    @dateTimeConverter required DateTime endsAt,
    required int current,
    required int total,
  }) = _PotModel;

  factory PotModel.fromJson(Map<String, dynamic> json) =>
      _$PotModelFromJson(json);
}
