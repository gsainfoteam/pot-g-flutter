import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';

BaseServerMessageModel convertServerMessage(Map<String, dynamic> jsonData) {
  final type = jsonData['type'] as String;
  final data = switch (type) {
    'pot_event' => throw UnimplementedError(),
    'request_authorization' => BaseServerMessageModel.fromJson(
      jsonData,
      RequestAuthorizationEventModel.fromJson,
    ),
    _ => throw ArgumentError.value(jsonData, 'jsonData', 'Unknown type: $type'),
  };
  return data;
}
