import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:pot_g/app/modules/core/domain/repositories/api_channel_repository.dart';

@singleton
class PotDio extends DioForNative {
  PotDio(
    AuthorizeInterceptor interceptor,
    ApiChannelRepository apiChannelRepository,
  ) {
    interceptors.add(interceptor);
    apiChannelRepository.channel.listen((channel) {
      options.baseUrl = channel.url;
    });
  }
}
