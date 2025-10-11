import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';

part 'get_pot_list_query_model.freezed.dart';
part 'get_pot_list_query_model.g.dart';

@Freezed(toJson: true)
sealed class GetPotListQueryModel with _$GetPotListQueryModel {
  const factory GetPotListQueryModel({
    required int limit,
    required int offset,
    @JsonKey(includeIfNull: false) String? routeId,
    @DateTimeConverter() @JsonKey(includeIfNull: false) DateTime? startsAt,
    @DateTimeConverter() @JsonKey(includeIfNull: false) DateTime? endsAt,
  }) = _GetPotListQueryModel;

  factory GetPotListQueryModel.fromJson(Map<String, dynamic> json) =>
      _$GetPotListQueryModelFromJson(json);
}
