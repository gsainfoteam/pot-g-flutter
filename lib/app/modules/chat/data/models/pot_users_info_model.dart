import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_user_model.dart';

part 'pot_users_info_model.freezed.dart';
part 'pot_users_info_model.g.dart';

@Freezed(toJson: false)
sealed class PotUsersInfoModel with _$PotUsersInfoModel {
  const factory PotUsersInfoModel({
    required int current,
    required int total,
    required List<PotUserModel> users,
  }) = _PotUsersInfoModel;

  factory PotUsersInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PotUsersInfoModelFromJson(json);
}
