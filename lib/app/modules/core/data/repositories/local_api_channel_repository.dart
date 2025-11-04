import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/data/models/api_channel_settings.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/api_channel_repository.dart';

@Singleton(as: ApiChannelRepository, dispose: LocalApiChannelRepository.dispose)
class LocalApiChannelRepository implements ApiChannelRepository {
  Box<ApiChannelSettings>? _box;
  final _subject = BehaviorSubject<ApiChannel>();
  static const String _boxName = 'api_channel_settings';
  static const String _key = 'settings';
  late final Timer _expirationCheckTimer;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    await _loadAndValidateChannel();
    // 주기적으로 만료 시간을 확인하여 production으로 복귀
    _startExpirationCheck();
  }

  static FutureOr dispose(ApiChannelRepository repository) {
    (repository as LocalApiChannelRepository)
      .._expirationCheckTimer.cancel()
      .._subject.close()
      .._box?.close();
  }

  void _startExpirationCheck() {
    // 1분마다 만료 시간 확인
    _expirationCheckTimer = Timer.periodic(const Duration(minutes: 1), (
      timer,
    ) async {
      try {
        final box = await _ensureBox();
        final settings = box.get(_key);
        if (settings != null &&
            settings.expiredAt != null &&
            DateTime.now().isAfter(settings.expiredAt!)) {
          await _setChannelToProduction();
        }
      } catch (error, stackTrace) {
        L.e(error, stackTrace);
      }
    });
  }

  Future<Box<ApiChannelSettings>> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  Future<void> _loadAndValidateChannel() async {
    final box = await _ensureBox();
    final settings = box.get(_key);

    if (settings != null) {
      // expiredAt이 설정되어 있고 만료되었으면 production으로 복귀
      if (settings.expiredAt != null &&
          DateTime.now().isAfter(settings.expiredAt!)) {
        await _setChannelToProduction();
        return;
      }
      _subject.add(settings.channel);
    } else {
      // 저장된 설정이 없으면 기본값 사용
      final defaultChannel = ApiChannel.byMode();
      _subject.add(defaultChannel);
    }
  }

  Future<void> _setChannelToProduction() async {
    final box = await _ensureBox();
    await box.put(_key, ApiChannelSettings(channel: ApiChannel.prod));
    _subject.add(ApiChannel.prod);
  }

  @override
  void setChannel(ApiChannel channel, {DateTime? expiredAt}) {
    // Update stream immediately for responsive UI
    _subject.add(channel);
    // Save to storage asynchronously in background
    setChannelWithExpiration(channel, expiredAt).catchError((
      error,
      stackTrace,
    ) {
      L.e(error, stackTrace);
    });
  }

  Future<void> setChannelWithExpiration(
    ApiChannel channel,
    DateTime? expiredAt,
  ) async {
    final box = await _ensureBox();
    final settings = ApiChannelSettings(channel: channel, expiredAt: expiredAt);
    await box.put(_key, settings);
  }

  @override
  String get apiBaseurl => _subject.value.url;

  @override
  Uri get wsUrl => _subject.value.wsUrl;

  @override
  Stream<ApiChannel> get channel => _subject.stream;

  Future<ApiChannelSettings?> getSettings() async {
    final box = await _ensureBox();
    return box.get(_key);
  }
}
