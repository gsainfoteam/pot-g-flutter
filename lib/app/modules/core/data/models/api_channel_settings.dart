import 'package:hive_ce/hive.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';

class ApiChannelSettings extends HiveObject {
  final ApiChannel channel;

  final DateTime? expiredAt;

  ApiChannelSettings({required this.channel, this.expiredAt});
}
