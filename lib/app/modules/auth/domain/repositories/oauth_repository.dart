import 'package:pot_g/app/modules/auth/domain/entities/token_entity.dart';

abstract interface class OAuthRepository {
  Future<TokenEntity> getToken();
  Future<void> setRecentLogout([bool value = true]);
}
