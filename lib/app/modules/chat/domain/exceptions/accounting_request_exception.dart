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
  factory AccountingRequestException.unknown(Object error) = UnknownException;
}

class AlreadyRequestedException extends AccountingRequestException {
  const AlreadyRequestedException();
  @override
  String toString() => 'AccountingRequestException.AlreadyRequestedException';
}

class AccountInfoNotSetException extends AccountingRequestException {
  const AccountInfoNotSetException();
  @override
  String toString() => 'AccountingRequestException.AccountInfoNotSetException';
}

class CostCannotBeNegativeException extends AccountingRequestException {
  const CostCannotBeNegativeException();
  @override
  String toString() =>
      'AccountingRequestException.CostCannotBeNegativeException';
}

class CostPerUserMismatchException extends AccountingRequestException {
  const CostPerUserMismatchException();
  @override
  String toString() =>
      'AccountingRequestException.CostPerUserMismatchException';
}

class BeforeDepartureException extends AccountingRequestException {
  const BeforeDepartureException();
  @override
  String toString() => 'AccountingRequestException.BeforeDepartureException';
}

class NotAParticipantException extends AccountingRequestException {
  const NotAParticipantException();
  @override
  String toString() => 'AccountingRequestException.NotAParticipantException';
}

class PotNotExistException extends AccountingRequestException {
  const PotNotExistException();
  @override
  String toString() => 'AccountingRequestException.PotNotExistException';
}

class PotAlreadyClosedException extends AccountingRequestException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'AccountingRequestException.PotAlreadyClosedException';
}

class NetworkErrorException extends AccountingRequestException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() =>
      'AccountingRequestException.NetworkErrorException(error: $error)';
}

class UnknownException extends AccountingRequestException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'AccountingRequestException.UnknownException';
}
