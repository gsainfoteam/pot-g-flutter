import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_accounting_info_model.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_users_info_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/core/data/converter/date_time_converter.dart';
import 'package:pot_g/app/modules/core/data/models/route_model.dart';

part 'pot_info_model.freezed.dart';
part 'pot_info_model.g.dart';

@Freezed(toJson: false)
sealed class PotInfoModel with _$PotInfoModel implements PotInfoEntity {
  const factory PotInfoModel({
    required String id,
    required String name,
    required RouteModel route,
    @dateTimeConverter required DateTime startsAt,
    @dateTimeConverter required DateTime endsAt,
    @dateTimeConverter required DateTime? departureTime,
    required PotStatus status,
    required PotUsersInfoModel usersInfo,
    required PotAccountingInfoModel accountingInfo,
  }) = _PotInfoModel;

  factory PotInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PotInfoModelFromJson(json);
}
