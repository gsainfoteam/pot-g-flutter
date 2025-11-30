sealed class LeavePotException implements Exception {
  const LeavePotException();

  const factory LeavePotException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  const factory LeavePotException.notYetPaymentConfirmed() =
      NotYetPaymentConfirmedException;
  const factory LeavePotException.notYetPaymentCompleted() =
      NotYetPaymentCompletedException;
  const factory LeavePotException.potNotExist() = PotNotExistException;
  const factory LeavePotException.potAlreadyClosed() =
      PotAlreadyClosedException;
  const factory LeavePotException.unknownResponse(String invalidArgument) =
      UnknownResponseException;
  const factory LeavePotException.networkError(String error) =
      NetworkErrorException;
  const factory LeavePotException.unknown(Object error) = UnknownException;
}

class AfterDepartureConfirmedException extends LeavePotException {
  const AfterDepartureConfirmedException();
  @override
  String toString() => 'LeavePotException.AfterDepartureConfirmedException';
}

class NotYetPaymentConfirmedException extends LeavePotException {
  const NotYetPaymentConfirmedException();
  @override
  String toString() => 'LeavePotException.NotYetPaymentConfirmedException';
}

class NotYetPaymentCompletedException extends LeavePotException {
  const NotYetPaymentCompletedException();
  @override
  String toString() => 'LeavePotException.NotYetPaymentCompletedException';
}

class PotNotExistException extends LeavePotException {
  const PotNotExistException();
  @override
  String toString() => 'LeavePotException.PotNotExistException';
}

class PotAlreadyClosedException extends LeavePotException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'LeavePotException.PotAlreadyClosedException';
}

class UnknownResponseException extends LeavePotException {
  final String invalidArgument;
  const UnknownResponseException(this.invalidArgument);
  @override
  String toString() => 'LeavePotException.UnknownResponseException(invalidArgument: $invalidArgument)';
}

class NetworkErrorException extends LeavePotException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => 'LeavePotException.NetworkErrorException(error: $error)';
}

class UnknownException extends LeavePotException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'LeavePotException.UnknownException(error: $error)';
}
