import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/bank_app_type.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/bank_app_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

part 'bank_app_cubit.freezed.dart';

@injectable
class BankAppCubit extends Cubit<BankAppState> {
  final BankAppRepository _repository;
  BankAppCubit(this._repository) : super(const BankAppState.initial());

  Future<void> sendMoney(
    BankAppType type,
    PotAccountingInfoEntity account,
  ) async {
    emit(const BankAppState.loading());
    try {
      await _repository.action(type, account);
      emit(const BankAppState.success());
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      emit(BankAppState.error(errorId));
    }
  }
}

@freezed
sealed class BankAppState with _$BankAppState {
  const factory BankAppState.initial() = _Initial;
  const factory BankAppState.loading() = _Loading;
  const factory BankAppState.success() = _Success;
  const factory BankAppState.error(String errorId) = _Error;
}
