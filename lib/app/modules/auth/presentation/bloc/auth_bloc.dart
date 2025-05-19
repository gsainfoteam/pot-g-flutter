import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<_Load>(_onLoad);
    on<_Login>(_onLogin);
    on<_Logout>(_onLogout);
  }

  Future<void> _onLoad(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    return emit.forEach(
      _repository.user,
      onData: (user) {
        if (user != null) {
          return AuthState.authenticated(user);
        } else {
          return const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> _onLogin(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final user = await _repository.signIn();
    emit(AuthState.authenticated(user));
  }

  Future<void> _onLogout(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.unauthenticated());
    await _repository.signOut();
  }
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.logout() = _Logout;
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
