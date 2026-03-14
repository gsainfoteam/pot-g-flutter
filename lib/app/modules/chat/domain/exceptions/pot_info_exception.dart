sealed class PotInfoException implements Exception {
  const PotInfoException();

  const factory PotInfoException.networkError(String error) =
      PotInfoNetworkErrorException;
  const factory PotInfoException.unknown(Object error) =
      PotInfoUnknownException;
}

class PotInfoNetworkErrorException extends PotInfoException {
  final String error;
  const PotInfoNetworkErrorException(this.error);

  @override
  String toString() => 'PotInfoException.NetworkErrorException(error: $error)';
}

class PotInfoUnknownException extends PotInfoException {
  final Object error;
  const PotInfoUnknownException(this.error);

  @override
  String toString() => 'PotInfoException.UnknownException(error: $error)';
}
