import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/main/domain/entities/pot_entity.dart';

part 'pot_list_bloc.freezed.dart';

class PotListBloc extends Bloc<PotListEvent, PotListState> {
  PotListBloc() : super(_Initial()) {
    on<_Init>(_onInit);
  }

  void _onInit(_Init event, Emitter<PotListState> emit) {}
}

@freezed
sealed class PotListEvent with _$PotListEvent {
  const factory PotListEvent.init() = _Init;
}

@freezed
sealed class PotListState with _$PotListState {
  const factory PotListState.initial([@Default([]) List<PotEntity> pots]) =
      _Initial;
}
