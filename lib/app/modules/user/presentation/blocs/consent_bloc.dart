import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/consent_repository.dart';

part 'consent_bloc.freezed.dart';

@injectable
class ConsentBloc extends Bloc<ConsentEvent, ConsentState> {
  final ConsentRepository _repository;

  ConsentBloc(this._repository) : super(const ConsentState.initial()) {
    on<_Update>(_onUpdate);
  }

  Future<void> _onUpdate(_Update event, Emitter<ConsentState> emit) async {
    emit(const ConsentState.loading());
    try {
      await _repository.updateConsent(event.terms);
      emit(const ConsentState.loaded());
    } catch (e, stackTrace) {
      emit(ConsentState.error(L.e(e, stackTrace)));
    }
  }
}

@freezed
sealed class ConsentEvent with _$ConsentEvent {
  const factory ConsentEvent.update(List<TermEntity> terms) = _Update;
}

@freezed
sealed class ConsentState with _$ConsentState {
  const factory ConsentState.initial() = _Initial;
  const factory ConsentState.loading() = _Loading;
  const factory ConsentState.loaded() = _Loaded;
  const factory ConsentState.error(String errorId) = _Error;
}
