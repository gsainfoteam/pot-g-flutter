import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/user/data/models/accounting_model.dart';
import 'package:pot_g/app/modules/user/data/models/push_setting_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String email,
    required AccountingModel accounting,
    required PushSettingModel pushSetting,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
