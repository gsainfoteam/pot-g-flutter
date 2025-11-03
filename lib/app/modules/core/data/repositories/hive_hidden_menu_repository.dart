import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/repositories/hidden_menu_repository.dart';

@LazySingleton(as: HiddenMenuRepository)
class HiveHiddenMenuRepository implements HiddenMenuRepository {
  Box? _box;
  static const String _boxName = 'hidden_menu';
  static const String _key = 'enabled';

  static const String _secret =
      'b692cc52e03b75b017525a59c148cd62fb7c7e52fd991dc436fa29c19b6ff1e6';

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
  Future<void> tryEnable(String secret) async {
    final hash = sha256.convert(utf8.encode(secret)).toString();
    if (hash != _secret) return;
    final box = await _ensureBox();
    await box.put(_key, true);
  }

  @override
  Future<void> disable() async {
    final box = await _ensureBox();
    await box.put(_key, false);
  }
}
