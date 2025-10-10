sealed class KickUserException implements Exception {
  const KickUserException();

  factory KickUserException.notAHost() = NotAHostException;
  factory KickUserException.notAParticipant() = NotAParticipantException;
  factory KickUserException.userNotInPot() = UserNotInPotException;
  factory KickUserException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  factory KickUserException.notYetPaymentConfirmed() =
      NotYetPaymentConfirmedException;
  factory KickUserException.potNotExist() = PotNotExistException;
  factory KickUserException.potAlreadyClosed() = PotAlreadyClosedException;
  factory KickUserException.networkError(String error) = NetworkErrorException;
}

class NotAHostException extends KickUserException {
  const NotAHostException();
}

class NotAParticipantException extends KickUserException {
  const NotAParticipantException();
}

class UserNotInPotException extends KickUserException {
  const UserNotInPotException();
}

class AfterDepartureConfirmedException extends KickUserException {
  const AfterDepartureConfirmedException();
}

class NotYetPaymentConfirmedException extends KickUserException {
  const NotYetPaymentConfirmedException();
}

class PotNotExistException extends KickUserException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends KickUserException {
  const PotAlreadyClosedException();
}

class NetworkErrorException extends KickUserException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => error;
}
