import 'package:pot_g/app/modules/core/domain/enums/hidden_menu_level.dart';

abstract class HiddenMenuRepository {
  Future<HiddenMenuLevel?> getLevel();
  Future<HiddenMenuLevel?> tryEnable(String secret);
  Future<void> disable();
}
