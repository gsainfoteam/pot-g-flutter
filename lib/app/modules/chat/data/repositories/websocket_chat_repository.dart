import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/get_pot_events_query_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/send_chat_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/send_chat_model.dart';

ChatEntity _makeChatEntity(PotEventModel<ChatV1Event> e, PotInfoEntity pot) {
  final users = pot.usersInfo.users;
  return ChatEntity(
    message: e.data.content,
    user: users.firstWhere((u) => u.id == e.data.from),
    createdAt: e.timestamp,
  );
}

@Injectable(as: ChatRepository)
class WebsocketChatRepository implements ChatRepository {
  final PotGSocket _socket;
  final ChatPotApi _api;

  WebsocketChatRepository(this._socket, this._api);

  @override
  Future<List<ChatEntity>> getChats(
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
        .whereType<PotEventModel<ChatV1Event>>()
        .map((e) => _makeChatEntity(e, localPot))
        .toList();
  }

  @override
  Stream<ChatEntity> getChatsStream(PotInfoEntity pot) async* {
    PotInfoEntity localPot = await _api.getPotInfo(pot.id);
    yield* _socket
        .createStreamFor<PotEventModel<ChatV1Event>>()
        .map((e) => e.body)
        .where((e) => e.potPk == pot.id)
        .asyncMap((e) async {
          if (!localPot.usersInfo.users.any((u) => u.id == e.data.from)) {
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
