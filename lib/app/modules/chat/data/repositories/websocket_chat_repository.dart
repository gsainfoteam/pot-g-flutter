import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/send_chat_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/chat_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/send_chat_model.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: ChatRepository)
class WebsocketChatRepository implements ChatRepository {
  final PotGSocket _socket;
  final ChatPotApi _api;

  WebsocketChatRepository(this._socket, this._api);

  @override
  Future<List<ChatEntity>> getChats(PotEntity pot) async {
    return [];
  }

  @override
  Stream<ChatEntity> getChatsStream(PotEntity pot) async* {
    final info = await _api.getPotInfo(pot.id);
    final users = info.usersInfo.users;
    yield* _socket
        .createStreamFor<PotEventModel<ChatV1Event>>()
        .where((e) => e.body.data.from == pot.id)
        .map((event) {
          final e = event.body.data;
          return ChatEntity(
            id: Uuid().v4(),
            message: e.content,
            user: users.firstWhere((u) => u.id == e.from),
            createdAt: DateTime.now(),
          );
        });
  }

  @override
  Future<void> sendChat(String message, PotEntity pot) async {
    await _socket.sendRequest(SendChatModel(message: message, potPk: pot.id));
    await _socket.getNextMessage<SendChatResponseModel>();
  }
}
