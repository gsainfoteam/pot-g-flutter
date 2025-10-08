import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';

part 'pot_info_bloc.freezed.dart';

@injectable
class PotInfoBloc extends Bloc<PotInfoEvent, PotInfoState> {
  final PotInfoRepository _repository;

  PotInfoBloc(this._repository) : super(const PotInfoState.loading()) {
    on<_Init>(_onInit);
  }

  Future<void> _onInit(_Init event, Emitter<PotInfoState> emit) async {
    emit(PotInfoState.loaded(event.pot));
    return emit.forEach(
      _repository.getPotInfoStream(event.pot),
      onData: (pot) => PotInfoState.loaded(pot),
    );
  }
}

@freezed
sealed class PotInfoEvent with _$PotInfoEvent {
  const factory PotInfoEvent.init(PotInfoEntity pot) = _Init;
}

@freezed
sealed class PotInfoState with _$PotInfoState {
  const PotInfoState._();
  const factory PotInfoState.loading() = _Loading;
  const factory PotInfoState.loaded(PotInfoEntity pot) = _Loaded;

  PotInfoEntity? get pot => switch (this) {
    _Loaded(:final pot) => pot,
    _ => null,
  };
}
