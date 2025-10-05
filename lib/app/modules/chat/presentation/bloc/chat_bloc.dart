import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_entity.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  late final PotEntity _pot;

  ChatBloc(this._chatRepository) : super(const ChatInitial()) {
    on<ChatInit>(_onChatInit);
    on<ChatSendChat>(_onChatSendChat);
  }

  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async {
    emit(const ChatState.loading());
    _pot = event.pot;
    try {
      final chats = await _chatRepository.getChats(event.pot);
      emit(ChatState.loaded(chats));
      return emit.forEach(
        _chatRepository.getChatsStream(event.pot),
        onData: (chat) {
          return ChatState.loaded([...state.chats, chat]);
        },
      );
    } catch (e) {
      emit(ChatState.error(state.chats, e.toString()));
    }
  }

  Future<void> _onChatSendChat(
    ChatSendChat event,
    Emitter<ChatState> emit,
  ) async {
    await _chatRepository.sendChat(event.message, _pot);
    // TODO: optimistic UI
  }
}

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.init(PotEntity pot) = ChatInit;
  const factory ChatEvent.sendChat(String message) = ChatSendChat;
}

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState.initial([@Default([]) List<ChatEntity> chats]) =
      ChatInitial;
  const factory ChatState.loading([@Default([]) List<ChatEntity> chats]) =
      ChatLoading;
  const factory ChatState.loaded(List<ChatEntity> chats) = ChatLoaded;
  const factory ChatState.error(List<ChatEntity> chats, String message) =
      ChatError;
}
