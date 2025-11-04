import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/enums/api_channel.dart';
import 'package:pot_g/app/modules/core/domain/repositories/api_channel_repository.dart';

part 'api_channel_bloc.freezed.dart';

@injectable
class ApiChannelBloc extends Bloc<ApiChannelEvent, ApiChannelState> {
  final ApiChannelRepository _apiChannelRepository;

  ApiChannelBloc(this._apiChannelRepository)
    : super(const ApiChannelState.initial()) {
    on<_Init>((event, emit) {
      return emit.forEach(
        _apiChannelRepository.channel,
        onData: (channel) => ApiChannelState.loaded(channel),
        onError: (error, stackTrace) {
          L.e(error, stackTrace);
          return ApiChannelState.initial();
        },
      );
    }, transformer: restartable());
    on<_SetChannel>((event, emit) {
      _apiChannelRepository.setChannel(event.channel, expiredAt: event.expiredAt);
    });
  }
}

@freezed
sealed class ApiChannelEvent with _$ApiChannelEvent {
  const factory ApiChannelEvent.init() = _Init;
  const factory ApiChannelEvent.setChannel(
    ApiChannel channel, {
    DateTime? expiredAt,
  }) = _SetChannel;
}

@freezed
sealed class ApiChannelState with _$ApiChannelState {
  const ApiChannelState._();
  const factory ApiChannelState.initial() = _Initial;
  const factory ApiChannelState.loaded(ApiChannel channel) = _Loaded;

  ApiChannel? get channel => switch (this) {
    _Loaded(:final channel) => channel,
    _ => null,
  };
}
