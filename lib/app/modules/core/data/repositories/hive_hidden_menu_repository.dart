import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/enums/hidden_menu_level.dart';
import 'package:pot_g/app/modules/core/domain/repositories/hidden_menu_repository.dart';

final _types = {
  'b692cc52e03b75b017525a59c148cd62fb7c7e52fd991dc436fa29c19b6ff1e6':
      HiddenMenuLevel.all,
  '34067f572f42e704fdc05e2772048acfc137aeb9f451a99f55e5f773c63f6ca5':
      HiddenMenuLevel.qa,
};

@LazySingleton(as: HiddenMenuRepository)
class HiveHiddenMenuRepository implements HiddenMenuRepository {
  Box<HiddenMenuLevel>? _box;
  static const String _boxName = 'hidden_menu_level';
  static const String _key = 'enabled';

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<Box<HiddenMenuLevel>> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  @override
  Future<HiddenMenuLevel?> getLevel() async {
    final box = await _ensureBox();
    return box.get(_key);
  }

  @override
  Future<HiddenMenuLevel?> tryEnable(String secret) async {
    final hash = sha256.convert(utf8.encode(secret)).toString();
    final level = _types[hash];
    if (level == null) return null;
    final box = await _ensureBox();
    await box.put(_key, level);
    return level;
  }

  @override
  Future<void> disable() async {
    final box = await _ensureBox();
    await box.delete(_key);
  }
}
