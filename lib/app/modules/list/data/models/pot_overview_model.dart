import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_users_info_model.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';

part 'pot_overview_model.freezed.dart';
part 'pot_overview_model.g.dart';

@Freezed(toJson: false)
sealed class PotOverviewModel
    with _$PotOverviewModel
    implements PotOverviewEntity {
  const factory PotOverviewModel({
    required String id,
    required String name,
    required RouteModel route,
    @dateTimeConverter required DateTime startsAt,
    @dateTimeConverter required DateTime endsAt,
    required PotUsersInfoModel usersInfo,
  }) = _PotOverviewModel;

  factory PotOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$PotOverviewModelFromJson(json);
}
