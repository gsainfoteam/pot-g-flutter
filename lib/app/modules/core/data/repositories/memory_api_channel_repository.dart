import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/api_channel_repository.dart';

@Singleton(as: ApiChannelRepository)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _subject = BehaviorSubject<ApiChannel>.seeded(ApiChannel.byMode());

  @override
  void setChannel(ApiChannel channel) {
    _subject.add(channel);
  }

  @override
  String get apiBaseurl => _subject.value.url;

  @override
  Uri get wsUrl => _subject.value.wsUrl;

  @override
  Stream<ApiChannel> get channel => _subject.stream;
}
