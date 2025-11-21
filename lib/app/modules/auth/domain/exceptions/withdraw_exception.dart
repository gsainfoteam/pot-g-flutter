sealed class WithdrawException implements Exception {
  const WithdrawException();

  const factory WithdrawException.notAllConsentsGiven() =
      NotAllConsentsGivenException;
  const factory WithdrawException.networkError(String error) =
      NetworkErrorException;
  const factory WithdrawException.unknown(Object error) = UnknownException;
}

class NotAllConsentsGivenException extends WithdrawException {
  const NotAllConsentsGivenException();
  @override
  String toString() => 'WithdrawException.NotAllConsentsGivenException';
}

class NetworkErrorException extends WithdrawException {
  final String error;
  const NetworkErrorException(this.error);
  @override
  String toString() => 'WithdrawException.NetworkErrorException(error: $error)';
}

class UnknownException extends WithdrawException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => 'WithdrawException.UnknownException(error: $error)';
}
