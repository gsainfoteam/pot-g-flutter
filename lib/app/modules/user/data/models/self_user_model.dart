import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/user/data/models/accounting_model.dart';
import 'package:pot_g/app/modules/user/data/models/push_setting_model.dart';
import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

part 'self_user_model.freezed.dart';
part 'self_user_model.g.dart';

@freezed
sealed class SelfUserModel with _$SelfUserModel implements UserEntity {
  const SelfUserModel._();
  const factory SelfUserModel({
    required String name,
    required String email,
    required AccountingModel accounting,
    required PushSettingModel pushSetting,
  }) = _SelfUserModel;

  factory SelfUserModel.fromJson(Map<String, dynamic> json) =>
      _$SelfUserModelFromJson(json);

  @override
  String get uuid => 'me';
}
