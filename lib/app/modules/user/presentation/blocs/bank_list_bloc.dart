import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/user/domain/entities/bank_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/accounting_repository.dart';

part 'bank_list_bloc.freezed.dart';

@injectable
class BankListBloc extends Bloc<BankListEvent, BankListState> {
  final AccountingRepository _accountingRepository;
  BankListBloc(this._accountingRepository)
    : super(const BankListState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(BankListEvent event, Emitter<BankListState> emit) async {
    emit(const BankListState.loading());
    try {
      final banks = await _accountingRepository.getBankList();
      emit(BankListState.loaded(banks));
    } catch (e) {
      emit(BankListState.error(e.toString()));
    }
  }
}

@freezed
sealed class BankListEvent with _$BankListEvent {
  const factory BankListEvent.load() = _Load;
}

@freezed
sealed class BankListState with _$BankListState {
  const BankListState._();

  const factory BankListState.initial() = _Initial;
  const factory BankListState.loading() = _Loading;
  const factory BankListState.loaded(List<BankEntity> banks) = _Loaded;
  const factory BankListState.error(String message) = _Error;

  List<BankEntity> get banks => switch (this) {
    _Loaded(:final banks) => banks,
    _ => [],
  };
}
