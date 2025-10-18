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
    on<ChatInit>(_onChatInit, transformer: restartable());
    on<ChatLoadMore>(_onChatLoadMore, transformer: droppable());
    on<ChatSendChat>(_onChatSendChat);
  }

  Future<void> _onChatInit(ChatInit event, Emitter<ChatState> emit) async {
    await _mutex.acquire();
    emit(const ChatState.loading());
    _pot = event.pot;
    _completer.complete();
    try {
      final chats = await _chatRepository.getChats(_pot, null);
      emit(
        ChatState.loaded(chats.reversed.toList(), endReached: chats.isEmpty),
      );
      // NOTE: getChats의 응답이 도착하고 다시 getChatsStream을 구독하는 사이에
      //       도착하는 메시지들이 누락 될 수 있습니다.
      return emit.forEach(
        _chatRepository.getChatsStream(_pot),
        onData: (chat) {
          return ChatState.loaded([
            chat,
            ...state.chats,
          ], endReached: state.endReached);
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
    try {
      await _chatRepository.sendChat(event.message, _pot);
      // TODO: optimistic UI
    } catch (e) {
      emit(ChatState.error(state.chats, e.toString()));
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
      emit(ChatState.loading(state.chats));
      final lastChat = state.chats.last;
      final chats = await _chatRepository.getChats(_pot, lastChat);
      emit(
        ChatState.loaded([
          ...state.chats,
          ...chats.reversed,
        ], endReached: chats.isEmpty),
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
  const ChatState._();
  const factory ChatState.initial([@Default([]) List<Sendable> chats]) =
      ChatInitial;
  const factory ChatState.loading([@Default([]) List<Sendable> chats]) =
      ChatLoading;
  const factory ChatState.loaded(
    List<Sendable> chats, {
    @Default(false) bool endReached,
  }) = ChatLoaded;
  const factory ChatState.error(List<Sendable> chats, String message) =
      ChatError;

  bool get isLoading => switch (this) {
    ChatLoading() => true,
    ChatLoaded() => false,
    _ => false,
  };
  String? get error => switch (this) {
    ChatError(:final message) => message,
    _ => null,
  };
  bool get endReached => switch (this) {
    ChatLoaded(:final endReached) => endReached,
    _ => false,
  };
}
