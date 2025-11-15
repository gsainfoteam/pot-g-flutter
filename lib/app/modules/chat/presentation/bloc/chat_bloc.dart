import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/modules/chat/domain/entities/chat_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/chat_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  late PotInfoEntity _pot;
  final _completer = Completer<void>();
  final _mutex = Mutex();

  ChatBloc(this._chatRepository) : super(const ChatState(isLoading: true)) {
    on<ChatInit>(_onChatInit, transformer: restartable());
    on<ChatLoadMore>(_onChatLoadMore, transformer: droppable());
    on<ChatSendChat>(_onChatSendChat);
  }

  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async {
    await _mutex.acquire();
    emit(state.copyWith(isLoading: true));
    _pot = event.pot;
    if (!_completer.isCompleted) {
      _completer.complete();
    }
    try {
      final stream = emit.forEach(
        _chatRepository.getChatsStream(_pot),
        onData: (chat) {
          return state.copyWith(
            isLoading: false,
            chats: [chat, ...state.chats],
            endReached: state.endReached,
          );
        },
      );
      final chats = await _chatRepository.getChats(_pot, null);
      emit(
        state.copyWith(
          isLoading: false,
          chats: [...state.chats, ...chats.reversed],
          endReached: chats.isEmpty,
        ),
      );
      return stream;
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    } finally {
      _mutex.release();
    }
  }

  Future<void> _onChatSendChat(
    ChatSendChat event,
    Emitter<ChatState> emit,
  ) async {
    await _completer.future;
    try {
      await _chatRepository.sendChat(event.message, _pot);
      // TODO: optimistic UI
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onChatLoadMore(
    ChatLoadMore event,
    Emitter<ChatState> emit,
  ) async {
    await _completer.future;
    await _mutex.acquire();
    try {
      if (state.endReached) return;
      if (state.chats.isEmpty) return;
      emit(state.copyWith(isLoading: true));
      final lastChat = state.chats.last;
      final chats = await _chatRepository.getChats(_pot, lastChat);
      emit(
        state.copyWith(
          isLoading: false,
          chats: [...state.chats, ...chats.reversed],
          endReached: chats.isEmpty,
        ),
      );
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
  const factory ChatState({
    @Default([]) List<Sendable> chats,
    @Default([]) List<Sendable> waitingChats,
    @Default(false) bool endReached,
    @Default(false) bool isLoading,
    String? error,
  }) = _ChatState;
}
