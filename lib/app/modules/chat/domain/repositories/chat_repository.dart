import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> getChats(PotEntity pot);
  Future<void> sendChat(String message, PotEntity pot);
  Stream<ChatEntity> getChatsStream(PotEntity pot);
}
