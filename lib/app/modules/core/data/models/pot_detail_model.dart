import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';

part 'pot_detail_model.freezed.dart';
part 'pot_detail_model.g.dart';

@freezed
sealed class PotDetailModel with _$PotDetailModel implements PotDetailEntity {
  factory PotDetailModel({
    required String id,
    required String name,
    required RouteModel route,
    @dateTimeConverter required DateTime startsAt,
    @dateTimeConverter required DateTime endsAt,
    @dateTimeConverter DateTime? departureTime,
    required int current,
    required int total,
    required PotStatus status,
    int? accountingRequested,
  }) = _PotDetailModel;

  factory PotDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PotDetailModelFromJson(json);
}
