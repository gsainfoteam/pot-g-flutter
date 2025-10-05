import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/socket/domain/socket_authorization_repository.dart';

part 'socket_auth_bloc.freezed.dart';

@injectable
class SocketAuthBloc extends Bloc<SocketAuthEvent, SocketAuthState> {
  final SocketAuthorizationRepository _repository;

  SocketAuthBloc(this._repository) : super(const SocketAuthState.initial()) {
    on<_Connect>(_onConnect);
    on<_Disconnect>(_onDisconnect);
  }

  Future<void> _onConnect(
    SocketAuthEvent event,
    Emitter<SocketAuthState> emit,
  ) async {
    await _repository.connect();
    emit(const SocketAuthState.connected());
  }

  Future<void> _onDisconnect(
    SocketAuthEvent event,
    Emitter<SocketAuthState> emit,
  ) async {
    await _repository.disconnect();
    emit(const SocketAuthState.disconnected());
  }
}

@freezed
sealed class SocketAuthEvent with _$SocketAuthEvent {
  const factory SocketAuthEvent.connect() = _Connect;
  const factory SocketAuthEvent.disconnect() = _Disconnect;
}

@freezed
sealed class SocketAuthState with _$SocketAuthState {
  const factory SocketAuthState.initial() = _Initial;
  const factory SocketAuthState.connected() = _Connected;
  const factory SocketAuthState.disconnected() = _Disconnected;
  const factory SocketAuthState.authorized() = _Authorized;
  const factory SocketAuthState.error(String message) = _Error;
}
