sealed class CreatePotException implements Exception {
  const CreatePotException();

  const factory CreatePotException.invalidCapacity() = InvalidCapacityException;
  const factory CreatePotException.departureAvailableBeforeNow() =
      DepartureAvailableBeforeNowException;
  const factory CreatePotException.invalidDepartureAvailableTime() =
      InvalidDepartureAvailableTimeException;
  const factory CreatePotException.tooFarDepartureAvailableTime() =
      TooFarDepartureAvailableTimeException;
  const factory CreatePotException.networkError(String error) =
      NetworkErrorException;
  const factory CreatePotException.unknown(Object error) = UnknownException;
}

class InvalidCapacityException extends CreatePotException {
  const InvalidCapacityException();
}

class DepartureAvailableBeforeNowException extends CreatePotException {
  const DepartureAvailableBeforeNowException();
}

class InvalidDepartureAvailableTimeException extends CreatePotException {
  const InvalidDepartureAvailableTimeException();
}

class TooFarDepartureAvailableTimeException extends CreatePotException {
  const TooFarDepartureAvailableTimeException();
}

class NetworkErrorException extends CreatePotException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => error;
}

class UnknownException extends CreatePotException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'CreatePotException.UnknownException(error: $error)';
}
