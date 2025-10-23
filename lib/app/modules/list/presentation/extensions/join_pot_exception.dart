import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/list/domain/exceptions/join_pot_exception.dart';
import 'package:pot_g/gen/strings.g.dart';

extension JoinPotExceptionX on JoinPotException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.list.enter.errors;
    switch (this) {
      case AfterDepartureConfirmedException():
        return errors.after_departure_confirmed;
      case PotNotExistException():
        return errors.pot_not_exist;
      case PotAlreadyClosedException():
        return errors.pot_already_closed;
      case PotFullException():
        return errors.pot_full;
      case NetworkErrorException(:final error):
        return '${errors.network_error}: $error';
      case UnknownException(:final error):
        return '${errors.unknown}: $error';
    }
  }
}
