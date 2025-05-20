import 'package:pot_g/app/modules/auth/domain/entity/token_entity.dart';

abstract class OAuthRepository {
  Future<TokenEntity> getToken();
  Future<void> setRecentLogout([bool value = true]);
}
