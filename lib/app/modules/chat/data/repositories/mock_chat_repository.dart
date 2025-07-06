import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';

@Injectable(as: ChatRepository)
class MockChatRepository implements ChatRepository {
  final AuthRepository _authRepository;

  MockChatRepository(this._authRepository);

  @override
  Future<List<ChatEntity>> getChats() async {
    final me =
        await _authRepository.user.first ??
        UserEntity(email: 'me@gistory.me', name: 'Me', uuid: 'me');
    final hong = UserEntity(
      email: 'hong@gistory.me',
      name: '홍길동',
      uuid: 'hong',
    );
    final shim = UserEntity(
      email: 'shim@gistory.me',
      name: '심청이',
      uuid: 'shim',
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
}
