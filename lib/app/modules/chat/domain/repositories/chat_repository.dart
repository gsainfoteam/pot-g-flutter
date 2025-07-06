import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> getChats();
}
