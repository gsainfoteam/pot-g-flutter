import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/repositories/hidden_menu_repository.dart';

@LazySingleton(as: HiddenMenuRepository)
class HiveHiddenMenuRepository implements HiddenMenuRepository {
  Box? _box;
  static const String _boxName = 'hidden_menu';
  static const String _key = 'enabled';

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<Box> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  @override
  Future<bool> isHiddenMenuEnabled() async {
    final box = await _ensureBox();
    return box.get(_key, defaultValue: false) as bool;
  }

  @override
  Future<void> setHiddenMenuEnabled(bool enabled) async {
    final box = await _ensureBox();
    await box.put(_key, enabled);
  }
}
