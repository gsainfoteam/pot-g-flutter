import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';

@Injectable(as: ChatRepository, env: [Environment.test])
class MockChatRepository implements ChatRepository {
  MockChatRepository();

  final _controller = StreamController<ChatEntity>.broadcast();

  @override
  Future<List<ChatEntity>> getChats(PotInfoEntity pot) async {
    final me = PotUserEntity(
      name: 'Me',
      id: 'me',
      isHost: false,
      isInPot: true,
    );
    final hong = PotUserEntity(
      name: '홍길동',
      id: 'hong',
      isHost: false,
      isInPot: true,
    );
    final shim = PotUserEntity(
      name: '심청이',
      id: 'shim',
      isHost: false,
      isInPot: true,
    );

    return [
      ChatEntity.make('첫 메시지', hong),
      ChatEntity.make('두번째 메시지', hong),
      ChatEntity.make(
        '메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리',
        hong,
      ),
      ChatEntity.make('내 메시지', me),
      ChatEntity.make('두번째 내 메시지', me),
      ChatEntity.make(
        '내 메시지가 아주 길어지는 경우 이렇게 처리 내 메시지가 아주 길어지는 경우 이렇게 처리 내 메시지가 아주 길어지는 경우 이렇게 처리내 메시지가 아주 길어지는 경우 이렇게 처리내 메시지가 아주 길어지는 경우 이렇게 처리',
        me,
      ),
      ChatEntity.make('첫 메시지', shim),
      ChatEntity.make('두번째 메시지', shim),
      ChatEntity.make(
        '메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리 메시지가 아주 길어지는 경우 이렇게 처리',
        shim,
      ),
    ];
  }

  @override
  Stream<ChatEntity> getChatsStream(PotInfoEntity pot) {
    return _controller.stream;
  }

  @override
  Future<void> sendChat(String message, PotInfoEntity pot) async {
    _controller.add(
      ChatEntity.make(
        message,
        PotUserEntity(name: 'Me', id: 'me', isHost: false, isInPot: true),
      ),
    );
  }
}
