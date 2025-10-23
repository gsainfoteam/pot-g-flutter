sealed class CreatePotException implements Exception {
  const CreatePotException();

  factory CreatePotException.invalidCapacity() = InvalidCapacityException;
  factory CreatePotException.departureAvailableBeforeNow() =
      DepartureAvailableBeforeNowException;
  factory CreatePotException.invalidDepartureAvailableTime() =
      InvalidDepartureAvailableTimeException;
  factory CreatePotException.tooFarDepartureAvailableTime() =
      TooFarDepartureAvailableTimeException;
  factory CreatePotException.networkError(String error) = NetworkErrorException;
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
