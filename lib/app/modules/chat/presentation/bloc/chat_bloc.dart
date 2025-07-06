import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(const ChatInitial()) {
    on<ChatInit>(_onChatInit);
  }

  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async {
    emit(const ChatState.loading());
    try {
      final chats = await _chatRepository.getChats();
      emit(ChatState.loaded(chats));
    } catch (e) {
      emit(ChatState.error(state.chats, e.toString()));
    }
  }
}

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.init() = ChatInit;
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
