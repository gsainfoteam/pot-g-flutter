import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/authorization_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/send_chat_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_request_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/archive_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/departure_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/popo_chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_in_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_kick_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_leave_v1_event.dart';

PotEventModel<E> convertPotEvent<E extends PotEvent>(
  Map<String, dynamic> jsonData,
) {
  final message = convertServerMessage({
    'type': 'pot_event_receive',
    'request_id': '',
    'body': jsonData,
  });
  return message.body as PotEventModel<E>;
}

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
  BaseServerMessageModel<PotEventModel<E>> pe<E extends PotEvent>(
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
      // TODO: handle create_v1 event
      'create_v1' => pe(ArchiveV1Event.fromJson),
      'chat_v1' => pe(ChatV1Event.fromJson),
      'popo_chat_v1' => pe(PopoChatV1Event.fromJson),
      'user_in_v1' => pe(UserInV1Event.fromJson),
      'user_leave_v1' => pe(UserLeaveV1Event.fromJson),
      'user_kick_v1' => pe(UserKickV1Event.fromJson),
      'departure_confirm_v1' => pe(DepartureConfirmV1Event.fromJson),
      'accounting_request_v1' => pe(AccountingRequestV1Event.fromJson),
      'accounting_confirm_v1' => pe(AccountingConfirmV1Event.fromJson),
      'archive_v1' => pe(ArchiveV1Event.fromJson),
      _ =>
        throw ArgumentError.value(
          jsonData,
          'jsonData',
          'Unknown pot event type: ${jsonData['body']['event_type']}',
        ),
    },
    'request_authorization' => change(RequestAuthorizationEventModel.fromJson),
    'authorization_res' => change(AuthorizationResponseModel.fromJson),
    'send_chat_res' => change(SendChatResponseModel.fromJson),
    _ => throw ArgumentError.value(jsonData, 'jsonData', 'Unknown type: $type'),
  };
  return data as BaseServerMessageModel<T>;
}
