sealed class AccountingConfirmException implements Exception {
  const AccountingConfirmException();

  factory AccountingConfirmException.notYetRequested() =
      NotYetRequestedException;
  factory AccountingConfirmException.notAccountingRequester() =
      NotAccountingRequesterException;
  factory AccountingConfirmException.potNotExist() = PotNotExistException;
  factory AccountingConfirmException.potAlreadyClosed() =
      PotAlreadyClosedException;

  factory AccountingConfirmException.networkError(String error) =
      NetworkErrorException;
}

class NotYetRequestedException extends AccountingConfirmException {
  const NotYetRequestedException();
}

class NotAccountingRequesterException extends AccountingConfirmException {
  const NotAccountingRequesterException();
}

class PotNotExistException extends AccountingConfirmException {
  const PotNotExistException();
}

class PotAlreadyClosedException extends AccountingConfirmException {
  const PotAlreadyClosedException();
}

class NetworkErrorException extends AccountingConfirmException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => error;
}
