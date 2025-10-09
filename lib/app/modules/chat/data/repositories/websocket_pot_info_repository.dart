import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/kick_user_response_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/departure_time_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/kick_user_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_info_repository.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_detail_entity.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/pot_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/accounting_request_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/archive_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/departure_confirm_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_in_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_kick_v1_event.dart';
import 'package:pot_g/app/modules/socket/data/models/pot_events/user_leave_v1_event.dart';

@Injectable(as: PotInfoRepository)
class WebsocketPotInfoRepository implements PotInfoRepository {
  final PotGSocket _socket;
  final ChatPotApi _api;

  WebsocketPotInfoRepository(this._socket, this._api);

  @override
  Stream<PotInfoEntity> getPotInfoStream(PotDetailEntity pot) async* {
    yield await _api.getPotInfo(pot.id);
    yield* _socket
        .createStreamFor<PotEventModel>()
        .where(
          (p) =>
              p is PotEventModel<UserInV1Event> ||
              p is PotEventModel<UserLeaveV1Event> ||
              p is PotEventModel<UserKickV1Event> ||
              p is PotEventModel<DepartureConfirmV1Event> ||
              p is PotEventModel<AccountingRequestV1Event> ||
              p is PotEventModel<AccountingConfirmV1Event> ||
              p is PotEventModel<ArchiveV1Event>,
        )
        .map((e) => e.body)
        .where((e) => e.potPk == pot.id)
        .asyncMap((e) => _api.getPotInfo(pot.id));
  }

  @override
  Future<void> setDepartureTime(PotInfoEntity pot, DateTime date) async {
    try {
      final result = await _api.confirmDepartureTime(
        pot.id,
        ConfirmDepartureTimeRequestModel(departureTime: date),
      );
      switch (result.result) {
        case PotDepartureTimeResult.ok:
          return;
        case PotDepartureTimeResult.notAHost:
          throw DepartureTimeException.notAHost();
        case PotDepartureTimeResult.afterDeparture:
          throw DepartureTimeException.afterDeparture();
        case PotDepartureTimeResult.beforeNow:
          throw DepartureTimeException.beforeNow();
        case PotDepartureTimeResult.potNotExist:
          throw DepartureTimeException.potNotExist();
        case PotDepartureTimeResult.potAlreadyClosed:
          throw DepartureTimeException.potAlreadyClosed();
      }
    } on DioException catch (e) {
      throw DepartureTimeException.networkError(e.error.toString());
    }
  }

  @override
  Future<void> kickUser(PotInfoEntity pot, PotUserEntity user) async {
    try {
      final result = await _api.kickUser(pot.id, user.id);
      switch (result.result) {
        case KickUserResult.ok:
          return;
        case KickUserResult.notAHost:
          throw KickUserException.notAHost();
        case KickUserResult.notAParticipant:
          throw KickUserException.notAParticipant();
        case KickUserResult.userNotInPot:
          throw KickUserException.userNotInPot();
        case KickUserResult.afterDepartureConfirmed:
          throw KickUserException.afterDepartureConfirmed();
        case KickUserResult.notYetPaymentConfirmed:
          throw KickUserException.notYetPaymentConfirmed();
        case KickUserResult.potNotExist:
          throw KickUserException.potNotExist();
        case KickUserResult.potAlreadyClosed:
          throw KickUserException.potAlreadyClosed();
      }
    } on DioException catch (e) {
      throw KickUserException.networkError(e.error.toString());
    }
  }
}
