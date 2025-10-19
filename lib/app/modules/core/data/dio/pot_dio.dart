import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/repositories/api_channel_repository.dart';

@singleton
class PotDio extends DioForNative {
  StreamSubscription? _channelSubscription;
  PotDio(
    AuthorizeInterceptor interceptor,
    ApiChannelRepository apiChannelRepository,
  ) {
    interceptors.add(interceptor);
    _channelSubscription = apiChannelRepository.channel.listen(
      (channel) {
        options.baseUrl = channel.url;
      },
      onError: (error, stackTrace) {
        if (error is DioException) {
          if (error.response?.statusCode == 401) {
            return;
          }
        }
        L.e(error, stackTrace);
      },
    );
  }

  @override
  void close({bool force = false}) {
    _channelSubscription?.cancel();
    _channelSubscription = null;
    super.close(force: force);
  }
}
