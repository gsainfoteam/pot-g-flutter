import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/departure_time_exception.dart'
    as departure;
import 'package:pot_g/app/modules/chat/domain/exceptions/kick_user_exception.dart'
    as kick;
import 'package:pot_g/app/modules/chat/domain/exceptions/leave_pot_exception.dart'
    as leave;
import 'package:pot_g/gen/strings.g.dart';

extension LeavePotExceptionX on leave.LeavePotException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.drawer.actions.leave.error;
    switch (this) {
      case leave.AfterDepartureConfirmedException():
        return errors.after_departure_confirmed;
      case leave.NotYetPaymentConfirmedException():
        return errors.not_yet_payment_confirmed;
      case leave.NotYetPaymentCompletedException():
        return errors.not_yet_payment_completed;
      case leave.PotNotExistException():
        return errors.pot_not_exist;
      case leave.PotAlreadyClosedException():
        return errors.pot_already_closed;
      case leave.NetworkErrorException(:final error):
        return '${errors.network_error}: $error';
      case leave.UnknownException(:final error):
        return '${errors.unknown}: $error';
    }
  }
}

extension KickUserExceptionX on kick.KickUserException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.drawer.members.kick.error;
    switch (this) {
      case kick.NotAHostException():
        return errors.not_a_host;
      case kick.NotAParticipantException():
        return errors.not_a_participant;
      case kick.UserNotInPotException():
        return errors.user_not_in_pot;
      case kick.AfterDepartureConfirmedException():
        return errors.after_departure_confirmed;
      case kick.NotYetPaymentConfirmedException():
        return errors.not_yet_payment_confirmed;
      case kick.PotNotExistException():
        return errors.pot_not_exist;
      case kick.PotAlreadyClosedException():
        return errors.pot_already_closed;
      case kick.NetworkErrorException(:final error):
        return '${errors.network_error}: $error';
      case kick.UnknownException(:final error):
        return '${errors.unknown}: $error';
    }
  }
}

extension DepartureTimeExceptionX on departure.DepartureTimeException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.set_departure_time.error;
    switch (this) {
      case departure.NotAHostException():
        return errors.not_a_host;
      case departure.AfterDepartureException():
        return errors.after_departure;
      case departure.BeforeNowException():
        return errors.before_now;
      case departure.PotNotExistException():
        return errors.pot_not_exist;
      case departure.PotAlreadyClosedException():
        return errors.pot_already_closed;
      case departure.NotInAvailableTimeRangeException():
        return errors.not_in_available_time_range;
      case departure.NetworkErrorException(:final error):
        return '${errors.network_error}: $error';
      case departure.UnknownException(:final error):
        return '${errors.unknown}: $error';
    }
  }
}
