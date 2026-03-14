import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/pot_info_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_id_entity.dart';

part 'pot_info_bloc.freezed.dart';

@injectable
class PotInfoBloc extends Bloc<PotInfoEvent, PotInfoState> {
  final PotInfoRepository _repository;

  PotInfoBloc(this._repository) : super(const PotInfoState.loading()) {
    on<_Init>(_onInit, transformer: restartable());
  }

  Future<void> _onInit(_Init event, Emitter<PotInfoState> emit) async {
    return emit.forEach(
      _repository.getPotInfoStream(event.pot),
      onData: (pot) => PotInfoState.loaded(pot),
      onError: (error, stackTrace) {
        final errorId = L.e(error, stackTrace);
        final exception = error is PotInfoException
            ? error
            : PotInfoException.unknown(error);
        return PotInfoState.error(exception, errorId);
      },
    );
  }
}

@freezed
sealed class PotInfoEvent with _$PotInfoEvent {
  const factory PotInfoEvent.init(PotIdEntity pot) = _Init;
}

@freezed
sealed class PotInfoState with _$PotInfoState {
  const PotInfoState._();
  const factory PotInfoState.loading() = _Loading;
  const factory PotInfoState.loaded(PotInfoEntity pot) = _Loaded;
  const factory PotInfoState.error(PotInfoException err, String errorId) =
      _Error;

  PotInfoEntity? get pot => switch (this) {
    _Loaded(:final pot) => pot,
    _ => null,
  };
  ({PotInfoException err, String errorId})? get error => switch (this) {
    _Error(:final err, :final errorId) => (err: err, errorId: errorId),
    _ => null,
  };
}
