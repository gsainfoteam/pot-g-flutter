import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';

part 'create_pot_model.freezed.dart';
part 'create_pot_model.g.dart';

@freezed
sealed class CreatePotModel with _$CreatePotModel {
  const factory CreatePotModel({
    required String routeId,
    @dateTimeConverter required DateTime startsAt,
    @dateTimeConverter required DateTime endsAt,
    required int maxCount,
  }) = _CreatePotModel;

  factory CreatePotModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePotModelFromJson(json);
}
