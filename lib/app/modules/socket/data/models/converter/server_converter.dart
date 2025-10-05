import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/authorization_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/send_chat_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_in_v1_event.dart';

BaseServerMessageModel<T> convertServerMessage<
  T extends BaseServerMessageEvent
>(Map<String, dynamic> jsonData) {
  final type = jsonData['type'] as String;
  BaseServerMessageModel<E> change<E extends BaseServerMessageEvent>(
    E Function(Map<String, dynamic>) fromJsonT,
  ) => BaseServerMessageModel.fromJson(
    jsonData,
    (json) => fromJsonT(json as Map<String, dynamic>),
  );
  BaseServerMessageModel<PotEventModel<E>> changePotEvent<E extends PotEvent>(
    E Function(Map<String, dynamic>) fromJsonT,
  ) => BaseServerMessageModel.fromJson(
    jsonData,
    (json) => PotEventModel.fromJson(
      json as Map<String, dynamic>,
      (inner) => fromJsonT(inner as Map<String, dynamic>),
    ),
  );
  final data = switch (type) {
    'pot_event_receive' => switch (jsonData['body']['event_type']) {
      'chat_v1' => changePotEvent(ChatV1Event.fromJson),
      'user_in_v1' => changePotEvent(UserInV1Event.fromJson),
      _ =>
        throw ArgumentError.value(
          jsonData,
          'jsonData',
          'Unknown pot event type: ${jsonData['event_type']}',
        ),
    },
    'request_authorization' => change(RequestAuthorizationEventModel.fromJson),
    'authorization_res' => change(AuthorizationResponseModel.fromJson),
    'send_chat_res' => change(SendChatResponseModel.fromJson),
    _ => throw ArgumentError.value(jsonData, 'jsonData', 'Unknown type: $type'),
  };
  return data as BaseServerMessageModel<T>;
}
