import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/socket_interface.dart';
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
    final stream = emit.forEach(
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
    await _repository.connect();
    return stream;
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
    } catch (e, stackTrace) {
      emit(SocketAuthState.error(L.e(e, stackTrace)));
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
  const SocketAuthState._();

  const factory SocketAuthState.initial() = _Initial;
  const factory SocketAuthState.connecting() = SocketConnecting;
  const factory SocketAuthState.connected() = SocketConnected;
  const factory SocketAuthState.reconnecting() = SocketReconnecting;
  const factory SocketAuthState.disconnected() = SocketDisconnected;
  const factory SocketAuthState.failed() = SocketFailed;
  const factory SocketAuthState.authorized() = _Authorized;
  const factory SocketAuthState.error(String errorId) = SocketError;

  bool get isConnected => switch (this) {
    SocketConnected() => true,
    _ => false,
  };
}
