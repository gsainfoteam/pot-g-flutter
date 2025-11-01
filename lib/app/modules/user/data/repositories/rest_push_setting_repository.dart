import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/user/data/data_source/remote/user_api.dart';
import 'package:pot_g/app/modules/user/data/models/push_setting_model.dart';
import 'package:pot_g/app/modules/user/domain/entities/push_setting_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/push_setting_repository.dart';

@Injectable(as: PushSettingRepository)
class RestPushSettingRepository implements PushSettingRepository {
  final UserApi _userApi;
  RestPushSettingRepository(this._userApi);

  @override
  Future<SelfUserEntity> getUser() {
    return _userApi.getUser();
  }

  @override
  Future<PushSettingEntity> updatePush(PushSettingEntity pushSetting) {
    return _userApi.updatePush(
      PushSettingModel(
        chatPush: pushSetting.chatPush,
        potInOutPush: pushSetting.potInOutPush,
        marketingPush: pushSetting.marketingPush,
      ),
    );
  }
}
