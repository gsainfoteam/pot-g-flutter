sealed class DepartureTimeException implements Exception {
  const DepartureTimeException();

  const factory DepartureTimeException.notAHost() = NotAHostException;
  const factory DepartureTimeException.afterDeparture() =
      AfterDepartureException;
  const factory DepartureTimeException.beforeNow() = BeforeNowException;
  const factory DepartureTimeException.potNotExist() = PotNotExistException;
  const factory DepartureTimeException.potAlreadyClosed() =
      PotAlreadyClosedException;
  const factory DepartureTimeException.notInAvailableTimeRange() =
      NotInAvailableTimeRangeException;
  const factory DepartureTimeException.unknownResponse(String invalidArgument) =
      UnknownResponseException;
  const factory DepartureTimeException.networkError(String error) =
      NetworkErrorException;
  const factory DepartureTimeException.unknown(Object error) = UnknownException;
}

class NotAHostException extends DepartureTimeException {
  const NotAHostException();
  @override
  String toString() => 'DepartureTimeException.NotAHostException';
}

class AfterDepartureException extends DepartureTimeException {
  const AfterDepartureException();
  @override
  String toString() => 'DepartureTimeException.AfterDepartureException';
}

class BeforeNowException extends DepartureTimeException {
  const BeforeNowException();
  @override
  String toString() => 'DepartureTimeException.BeforeNowException';
}

class PotNotExistException extends DepartureTimeException {
  const PotNotExistException();
  @override
  String toString() => 'DepartureTimeException.PotNotExistException';
}

class PotAlreadyClosedException extends DepartureTimeException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'DepartureTimeException.PotAlreadyClosedException';
}

class NotInAvailableTimeRangeException extends DepartureTimeException {
  const NotInAvailableTimeRangeException();
  @override
  String toString() =>
      'DepartureTimeException.NotInAvailableTimeRangeException';
}

class UnknownResponseException extends DepartureTimeException {
  final String invalidArgument;
  const UnknownResponseException(this.invalidArgument);
  @override
  String toString() =>
      'DepartureTimeException.UnknownResponseException(invalidArgument: $invalidArgument)';
}

class NetworkErrorException extends DepartureTimeException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() =>
      'DepartureTimeException.NetworkErrorException(error: $error)';
}

class UnknownException extends DepartureTimeException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'DepartureTimeException.UnknownException(error: $error)';
}
