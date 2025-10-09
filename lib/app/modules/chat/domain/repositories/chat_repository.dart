import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';

abstract class ChatRepository {
  Future<List<Sendable>> getChats(PotInfoEntity pot, DateTime startsFrom);
  Future<void> sendChat(String message, PotInfoEntity pot);
  Stream<Sendable> getChatsStream(PotInfoEntity pot);
}
