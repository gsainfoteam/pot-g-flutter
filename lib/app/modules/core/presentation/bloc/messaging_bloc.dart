import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/repositories/messaging_repository.dart';

part 'messaging_bloc.freezed.dart';

@injectable
class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository _repository;

  MessagingBloc(this._repository) : super(const _Initial()) {
    on<_Init>((event, emit) async {
      emit(const _Loading());
      try {
        await _repository.init();
        emit(const _Loaded());
      } catch (e, stackTrace) {
        L.e(e, stackTrace);
        emit(_Error(e.toString()));
      }
    });
    on<_Refresh>((event, emit) async {
      emit(const _Loading());
      try {
        await _repository.refresh();
        emit(const _Loaded());
      } catch (e, stackTrace) {
        L.e(e, stackTrace);
        emit(_Error(e.toString()));
      }
    });
  }
}

@freezed
sealed class MessagingEvent with _$MessagingEvent {
  const factory MessagingEvent.init() = _Init;
  const factory MessagingEvent.refresh() = _Refresh;
}

@freezed
sealed class MessagingState with _$MessagingState {
  const factory MessagingState.initial() = _Initial;
  const factory MessagingState.loading() = _Loading;
  const factory MessagingState.loaded() = _Loaded;
  const factory MessagingState.error(String message) = _Error;
}
