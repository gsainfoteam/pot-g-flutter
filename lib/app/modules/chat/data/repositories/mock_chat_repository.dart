import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';
import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

@Injectable(as: ChatRepository, env: [Environment.test])
class MockChatRepository implements ChatRepository {
  final AuthRepository _authRepository;

  MockChatRepository(this._authRepository);

  final _controller = StreamController<ChatEntity>.broadcast();

  @override
  Future<List<ChatEntity>> getChats(PotEntity pot) async {
    final me =
        await _authRepository.user.first ?? UserEntity(name: 'Me', id: 'me');
    final hong = UserEntity(name: '홍길동', id: 'hong');
    final shim = UserEntity(name: '심청이', id: 'shim');

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
  Stream<ChatEntity> getChatsStream(PotEntity pot) {
    return _controller.stream;
  }

  @override
  Future<void> sendChat(String message, PotEntity pot) async {
    _controller.add(
      ChatEntity.make(
        message,
        await _authRepository.user.first ?? UserEntity(name: 'Me', id: 'me'),
      ),
    );
  }
}
