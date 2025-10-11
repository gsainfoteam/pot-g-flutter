import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/kick_user_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/leave_pot_response_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/departure_time_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/kick_user_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/leave_pot_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_action_repository.dart';

@Injectable(as: PotActionRepository)
class WebsocketPotActionRepository implements PotActionRepository {
  final ChatPotApi _api;

  WebsocketPotActionRepository(this._api);

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
      throw DepartureTimeException.networkError(
        e.message ?? e.error.toString(),
      );
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
      throw KickUserException.networkError(e.message ?? e.error.toString());
    }
  }

  @override
  Future<void> leavePot(PotInfoEntity pot) async {
    try {
      final result = await _api.leavePot(pot.id);
      switch (result.result) {
        case LeavePotResult.ok:
          return;
        case LeavePotResult.afterDepartureConfirmed:
          throw LeavePotException.afterDepartureConfirmed();
        case LeavePotResult.notYetPaymentConfirmed:
          throw LeavePotException.notYetPaymentConfirmed();
        case LeavePotResult.notYetPaymentCompleted:
          throw LeavePotException.notYetPaymentCompleted();
        case LeavePotResult.potNotExist:
          throw LeavePotException.potNotExist();
        case LeavePotResult.potAlreadyClosed:
          throw LeavePotException.potAlreadyClosed();
      }
    } on DioException catch (e) {
      throw LeavePotException.networkError(e.message ?? e.error.toString());
    }
  }
}
