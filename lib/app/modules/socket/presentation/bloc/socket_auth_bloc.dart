import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/domain/socket_authorization_repository.dart';

part 'socket_auth_bloc.freezed.dart';

@injectable
class SocketAuthBloc extends Bloc<SocketAuthEvent, SocketAuthState> {
  final SocketAuthorizationRepository _repository;
  final PotGSocket _socket;

  SocketAuthBloc(this._repository, this._socket)
    : super(const SocketAuthState.initial()) {
    on<_Connect>(_onConnect, transformer: restartable());
    on<_Disconnect>(_onDisconnect);
    on<_Retry>(_onRetry);
  }

  Future<void> _onConnect(
    SocketAuthEvent event,
    Emitter<SocketAuthState> emit,
  ) async {
    await _repository.connect();

    // 연결 상태 Stream을 구독하여 State에 반영
    return emit.forEach(
      _socket.connectionState,
      onData: (state) {
        return switch (state) {
          SocketConnectionState.connected => const SocketAuthState.connected(),
          SocketConnectionState.connecting =>
            const SocketAuthState.connecting(),
          SocketConnectionState.reconnecting =>
            const SocketAuthState.reconnecting(),
          SocketConnectionState.disconnected =>
            const SocketAuthState.disconnected(),
          SocketConnectionState.failed => const SocketAuthState.failed(),
        };
      },
    );
  }

  Future<void> _onDisconnect(
    SocketAuthEvent event,
    Emitter<SocketAuthState> emit,
  ) async {
    await _repository.disconnect();
    emit(const SocketAuthState.disconnected());
  }

  Future<void> _onRetry(
    SocketAuthEvent event,
    Emitter<SocketAuthState> emit,
  ) async {
    try {
      await _socket.connect();
    } catch (e) {
      emit(SocketAuthState.error(e.toString()));
    }
  }
}

@freezed
sealed class SocketAuthEvent with _$SocketAuthEvent {
  const factory SocketAuthEvent.connect() = _Connect;
  const factory SocketAuthEvent.disconnect() = _Disconnect;
  const factory SocketAuthEvent.retry() = _Retry;
}

@freezed
sealed class SocketAuthState with _$SocketAuthState {
  const factory SocketAuthState.initial() = _Initial;
  const factory SocketAuthState.connecting() = _Connecting;
  const factory SocketAuthState.connected() = _Connected;
  const factory SocketAuthState.reconnecting() = _Reconnecting;
  const factory SocketAuthState.disconnected() = _Disconnected;
  const factory SocketAuthState.failed() = _Failed;
  const factory SocketAuthState.authorized() = _Authorized;
  const factory SocketAuthState.error(String message) = _Error;
}
