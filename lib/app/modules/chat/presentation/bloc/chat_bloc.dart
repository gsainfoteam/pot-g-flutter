import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  late PotInfoEntity _pot;
  final _completer = Completer<void>();
  final _mutex = Mutex();

  ChatBloc(this._chatRepository) : super(const ChatInitial()) {
    on<ChatInit>(_onChatInit);
    on<ChatLoadMore>(_onChatLoadMore, transformer: droppable());
    on<ChatSendChat>(_onChatSendChat);
  }

  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async {
    await _mutex.acquire();
    emit(const ChatState.loading());
    _pot = event.pot;
    _completer.complete();
    try {
      final chats = await _chatRepository.getChats(_pot, DateTime.now());
      emit(ChatState.loaded(chats.reversed.toList()));
      return emit.forEach(
        _chatRepository.getChatsStream(_pot),
        onData: (chat) {
          return ChatState.loaded([chat, ...state.chats]);
        },
      );
    } catch (e) {
      emit(ChatState.error(state.chats, e.toString()));
    } finally {
      _mutex.release();
    }
  }

  Future<void> _onChatSendChat(
    ChatSendChat event,
    Emitter<ChatState> emit,
  ) async {
    await _completer.future;
    await _chatRepository.sendChat(event.message, _pot);
    // TODO: optimistic UI
  }

  Future<void> _onChatLoadMore(
    ChatLoadMore event,
    Emitter<ChatState> emit,
  ) async {
    await _completer.future;
    await _mutex.acquire();
    try {
      emit(ChatState.loading(state.chats));
      final lastChat = state.chats.last;
      final chats = await _chatRepository.getChats(_pot, lastChat.createdAt);
      emit(ChatState.loaded([...state.chats, ...chats.reversed]));
    } finally {
      _mutex.release();
    }
  }
}

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.init(PotInfoEntity pot) = ChatInit;
  const factory ChatEvent.loadMore() = ChatLoadMore;
  const factory ChatEvent.sendChat(String message) = ChatSendChat;
}

@freezed
sealed class ChatState with _$ChatState {
  const ChatState._();
  const factory ChatState.initial([@Default([]) List<Sendable> chats]) =
      ChatInitial;
  const factory ChatState.loading([@Default([]) List<Sendable> chats]) =
      ChatLoading;
  const factory ChatState.loaded(List<Sendable> chats) = ChatLoaded;
  const factory ChatState.error(List<Sendable> chats, String message) =
      ChatError;

  bool get isLoading => switch (this) {
    ChatLoading() => true,
    ChatLoaded() => false,
    _ => false,
  };
}
