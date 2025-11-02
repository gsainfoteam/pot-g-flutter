import 'package:pot_g/app/modules/user/domain/entities/push_setting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';

abstract class PushSettingRepository {
  Future<SelfUserEntity> getUser();
  Future<PushSettingEntity> updatePush(PushSettingEntity pushSetting);
  Future<bool> checkOsNotificationPermission();
  Future<void> openAppSettings();
}
