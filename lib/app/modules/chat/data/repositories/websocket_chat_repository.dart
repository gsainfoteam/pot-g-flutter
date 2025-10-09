import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/chat_model.dart';
import 'package:pot_g/app/modules/chat/data/models/get_pot_events_query_model.dart';
import 'package:pot_g/app/modules/chat/data/models/system_message_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/send_chat_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_in_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_kick_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_leave_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/send_chat_model.dart';

bool _isChatEvent(PotEventModel e) {
  return e is PotEventModel<ChatV1Event> ||
      e is PotEventModel<UserInV1Event> ||
      e is PotEventModel<UserLeaveV1Event> ||
      e is PotEventModel<UserKickV1Event>;
}

String _getRelatedUserId(PotEventModel e) {
  return switch (e) {
    PotEventModel<ChatV1Event>() => e.data.from,
    PotEventModel<UserInV1Event>() => e.data.userPk,
    PotEventModel<UserLeaveV1Event>() => e.data.userPk,
    PotEventModel<UserKickV1Event>() => e.data.kickedUserPk,
    _ => throw StateError('Unknown event type'),
  };
}

Sendable _makeChatEntity(PotEventModel e, PotInfoEntity pot) {
  final users = pot.usersInfo.users;
  final user = users.firstWhere((u) => u.id == _getRelatedUserId(e));
  return switch (e) {
    PotEventModel<ChatV1Event>() => ChatModel(
      message: e.data.content,
      user: user,
      createdAt: e.timestamp,
    ),
    PotEventModel<UserInV1Event>() => SystemMessageModel(
      type: SystemMessageType.userIn,
      relatedUser: user,
      createdAt: e.timestamp,
    ),
    PotEventModel<UserLeaveV1Event>() => SystemMessageModel(
      type: SystemMessageType.userLeave,
      relatedUser: user,
      createdAt: e.timestamp,
    ),
    PotEventModel<UserKickV1Event>() => SystemMessageModel(
      type: SystemMessageType.userKicked,
      relatedUser: user,
      createdAt: e.timestamp,
    ),
    _ => throw StateError('Unknown event type'),
  };
}

@Injectable(as: ChatRepository)
class WebsocketChatRepository implements ChatRepository {
  final PotGSocket _socket;
  final ChatPotApi _api;

  WebsocketChatRepository(this._socket, this._api);

  @override
  Future<List<Sendable>> getChats(
    PotInfoEntity pot,
    DateTime startsFrom,
  ) async {
    final localPot = await _api.getPotInfo(pot.id);
    final events = await _api.getPotEvents(
      pot.id,
      GetPotEventsQueryModel(startsFrom: startsFrom),
    );
    return events.events
        .where((e) => e.potPk == pot.id)
        .where(_isChatEvent)
        .map((e) => _makeChatEntity(e, localPot))
        .toList();
  }

  @override
  Stream<Sendable> getChatsStream(PotInfoEntity pot) async* {
    PotInfoEntity localPot = await _api.getPotInfo(pot.id);
    yield* _socket
        .createStreamFor<PotEventModel>()
        .map((e) => e.body)
        .where((e) => e.potPk == pot.id)
        .where(_isChatEvent)
        .asyncMap((e) async {
          if (!localPot.usersInfo.users.any(
            (u) => u.id == _getRelatedUserId(e),
          )) {
            localPot = await _api.getPotInfo(pot.id);
          }
          return _makeChatEntity(e, localPot);
        });
  }

  @override
  Future<void> sendChat(String message, PotInfoEntity pot) async {
    await _socket.sendRequest(SendChatModel(message: message, potPk: pot.id));
    await _socket.getNextMessage<SendChatResponseModel>();
  }
}
