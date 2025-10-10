class LeavePotException implements Exception {
  const LeavePotException();

  factory LeavePotException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  factory LeavePotException.notYetPaymentConfirmed() =
      NotYetPaymentConfirmedException;
  factory LeavePotException.notYetPaymentCompleted() =
      NotYetPaymentCompletedException;
  factory LeavePotException.potNotExist() = PotNotExistException;
  factory LeavePotException.potAlreadyClosed() = PotAlreadyClosedException;
  factory LeavePotException.networkError(String error) = NetworkErrorException;
}

class AfterDepartureConfirmedException extends LeavePotException {
  const AfterDepartureConfirmedException();
}

class NotYetPaymentConfirmedException extends LeavePotException {
  const NotYetPaymentConfirmedException();
}

class NotYetPaymentCompletedException extends LeavePotException {
  const NotYetPaymentCompletedException();
}

class PotNotExistException extends LeavePotException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends LeavePotException {
  const PotAlreadyClosedException();
}

class NetworkErrorException extends LeavePotException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => error;
}
