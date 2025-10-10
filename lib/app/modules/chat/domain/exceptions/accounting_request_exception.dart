sealed class AccountingRequestException implements Exception {
  const AccountingRequestException();

  factory AccountingRequestException.alreadyRequested() =
      AlreadyRequestedException;
  factory AccountingRequestException.accountInfoNotSet() =
      AccountInfoNotSetException;
  factory AccountingRequestException.costCannotBeNegative() =
      CostCannotBeNegativeException;
  factory AccountingRequestException.costPerUserMismatch() =
      CostPerUserMismatchException;
  factory AccountingRequestException.beforeDeparture() =
      BeforeDepartureException;
  factory AccountingRequestException.notAParticipant() =
      NotAParticipantException;
  factory AccountingRequestException.potNotExist() = PotNotExistException;
  factory AccountingRequestException.potAlreadyClosed() =
      PotAlreadyClosedException;

  factory AccountingRequestException.networkError(String error) =
      NetworkErrorException;
}

class AlreadyRequestedException extends AccountingRequestException {
  const AlreadyRequestedException();
}

class AccountInfoNotSetException extends AccountingRequestException {
  const AccountInfoNotSetException();
}

class CostCannotBeNegativeException extends AccountingRequestException {
  const CostCannotBeNegativeException();
}

class CostPerUserMismatchException extends AccountingRequestException {
  const CostPerUserMismatchException();
}

class BeforeDepartureException extends AccountingRequestException {
  const BeforeDepartureException();
}

class NotAParticipantException extends AccountingRequestException {
  const NotAParticipantException();
}

class PotNotExistException extends AccountingRequestException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends AccountingRequestException {
  const PotAlreadyClosedException();
}

class NetworkErrorException extends AccountingRequestException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => error;
}
