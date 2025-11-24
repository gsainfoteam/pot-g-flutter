import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/exceptions/withdraw_exception.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'withdraw_bloc.freezed.dart';

@injectable
class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  final AuthRepository _repository;

  WithdrawBloc(this._repository) : super(const WithdrawState.initial()) {
    on<_Withdraw>(_onWithdraw);
  }

  Future<void> _onWithdraw(
    WithdrawEvent event,
    Emitter<WithdrawState> emit,
  ) async {
    emit(const WithdrawState.loading());
    try {
      await _repository.withdraw();
      emit(WithdrawState.success());
    } on WithdrawException catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(WithdrawState.error(e, errorId));
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(WithdrawState.error(WithdrawException.unknown(e), errorId));
    }
  }
}

@freezed
sealed class WithdrawEvent with _$WithdrawEvent {
  const factory WithdrawEvent.withdraw() = _Withdraw;
}

@freezed
sealed class WithdrawState with _$WithdrawState {
  const factory WithdrawState.initial() = _Initial;
  const factory WithdrawState.loading() = _Loading;
  const factory WithdrawState.success() = _Success;
  const factory WithdrawState.error(WithdrawException error, String errorId) =
      _Error;
}
