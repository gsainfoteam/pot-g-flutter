sealed class AccountingConfirmException implements Exception {
  const AccountingConfirmException();

  const factory AccountingConfirmException.notYetRequested() =
      NotYetRequestedException;
  const factory AccountingConfirmException.notAccountingRequester() =
      NotAccountingRequesterException;
  const factory AccountingConfirmException.potNotExist() = PotNotExistException;
  const factory AccountingConfirmException.potAlreadyClosed() =
      PotAlreadyClosedException;
  const factory AccountingConfirmException.unknownResponse(
    String invalidArgument,
  ) = UnknownResponseException;
  const factory AccountingConfirmException.networkError(String error) =
      NetworkErrorException;
  const factory AccountingConfirmException.unknown(Object error) =
      UnknownException;
}

class NotYetRequestedException extends AccountingConfirmException {
  const NotYetRequestedException();
  @override
  String toString() => 'AccountingConfirmException.NotYetRequestedException';
}

class NotAccountingRequesterException extends AccountingConfirmException {
  const NotAccountingRequesterException();
  @override
  String toString() =>
      'AccountingConfirmException.NotAccountingRequesterException';
}

class PotNotExistException extends AccountingConfirmException {
  const PotNotExistException();
  @override
  String toString() => 'AccountingConfirmException.PotNotExistException';
}

class PotAlreadyClosedException extends AccountingConfirmException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'AccountingConfirmException.PotAlreadyClosedException';
}

class UnknownResponseException extends AccountingConfirmException {
  final String invalidArgument;
  const UnknownResponseException(this.invalidArgument);
  @override
  String toString() =>
      'AccountingConfirmException.UnknownResponseException(invalidArgument: $invalidArgument)';
}

class NetworkErrorException extends AccountingConfirmException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() =>
      'AccountingConfirmException.NetworkErrorException(error: $error)';
}

class UnknownException extends AccountingConfirmException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() =>
      'AccountingConfirmException.UnknownException(error: $error)';
}
