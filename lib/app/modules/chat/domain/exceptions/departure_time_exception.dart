sealed class DepartureTimeException implements Exception {
  const DepartureTimeException();

  factory DepartureTimeException.notAHost() = NotAHostException;
  factory DepartureTimeException.afterDeparture() = AfterDepartureException;
  factory DepartureTimeException.beforeNow() = BeforeNowException;
  factory DepartureTimeException.potNotExist() = PotNotExistException;
  factory DepartureTimeException.potAlreadyClosed() = PotAlreadyClosedException;
  factory DepartureTimeException.networkError(String error) =
      NetworkErrorException;
}

class NotAHostException extends DepartureTimeException {
  const NotAHostException();
}

class AfterDepartureException extends DepartureTimeException {
  const AfterDepartureException();
}

class BeforeNowException extends DepartureTimeException {
  const BeforeNowException();
}

class PotNotExistException extends DepartureTimeException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends DepartureTimeException {
  const PotAlreadyClosedException();
}

class NetworkErrorException extends DepartureTimeException {
  final String error;
  const NetworkErrorException(this.error);
}
