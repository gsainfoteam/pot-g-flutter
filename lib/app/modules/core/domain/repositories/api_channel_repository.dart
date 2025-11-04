import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';

abstract class ApiChannelRepository {
  void setChannel(ApiChannel channel, {DateTime? expiredAt});
  String get apiBaseurl;
  Uri get wsUrl;
  Stream<ApiChannel> get channel;
}
