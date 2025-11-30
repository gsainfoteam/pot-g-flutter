import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/create/domain/exceptions/create_pot_exception.dart';
import 'package:pot_g/gen/strings.g.dart';

extension CreateErrorX on CreatePotException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.create.errors;
    switch (this) {
      case InvalidCapacityException():
        return errors.invalid_capacity;
      case DepartureAvailableBeforeNowException():
        return errors.departure_available_before_now;
      case InvalidDepartureAvailableTimeException():
        return errors.invalid_departure_available_time;
      case TooFarDepartureAvailableTimeException():
        return errors.too_far_departure_available_time;
      case UnknownResponseException():
        return errors.unknown;
      case NetworkErrorException():
        return errors.network_error;
      case UnknownException():
        return errors.unknown;
    }
  }
}
