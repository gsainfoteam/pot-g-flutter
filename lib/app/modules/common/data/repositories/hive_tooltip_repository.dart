import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/domain/enums/tooltip_type.dart';
import 'package:pot_g/app/modules/common/domain/repositories/tooltip_repository.dart';

@LazySingleton(as: TooltipRepository)
class HiveTooltipRepository implements TooltipRepository {
  Box? _box;
  static const String _boxName = 'tooltips';

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<Box> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  String _getKey(TooltipType type) {
    return type.name;
  }

  @override
  Future<bool> shouldShowTooltip(TooltipType type) async {
    final box = await _ensureBox();
    final key = _getKey(type);
    final value = box.get(key, defaultValue: false) as bool;
    return !value;
  }

  @override
  Future<void> markTooltipAsShown(TooltipType type) async {
    final box = await _ensureBox();
    final key = _getKey(type);
    await box.put(key, true);
  }
}
