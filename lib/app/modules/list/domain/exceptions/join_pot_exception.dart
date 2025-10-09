sealed class JoinPotException implements Exception {
  const JoinPotException();

  factory JoinPotException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  factory JoinPotException.potNotExist() = PotNotExistException;
  factory JoinPotException.potAlreadyClosed() = PotAlreadyClosedException;
  factory JoinPotException.potFull() = PotFullException;
  factory JoinPotException.networkError(String error) = NetworkErrorException;
}

class AfterDepartureConfirmedException extends JoinPotException {
  const AfterDepartureConfirmedException();
}

class PotNotExistException extends JoinPotException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends JoinPotException {
  const PotAlreadyClosedException();
}

class PotFullException extends JoinPotException {
  const PotFullException();
}

class NetworkErrorException extends JoinPotException {
  final String error;
  const NetworkErrorException(this.error);
}
