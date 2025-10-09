import 'package:pot_g/app/modules/user/domain/entities/accounting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/push_setting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

abstract class SelfUserEntity extends UserEntity {
  String get email;
  AccountingEntity get accounting;
  PushSettingEntity get pushSetting;
}
