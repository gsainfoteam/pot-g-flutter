import 'package:flutter/foundation.dart';

sealed class JoinPotException implements Exception {
  const JoinPotException();

  const factory JoinPotException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  const factory JoinPotException.potNotExist() = PotNotExistException;
  const factory JoinPotException.potAlreadyClosed() = PotAlreadyClosedException;
  const factory JoinPotException.potFull() = PotFullException;
  const factory JoinPotException.networkError(String error) =
      NetworkErrorException;
  const factory JoinPotException.unknown(Object error) = UnknownException;
}

class AfterDepartureConfirmedException extends JoinPotException {
  const AfterDepartureConfirmedException();
  @override
  String toString() => 'JoinPotException.AfterDepartureConfirmedException';
}

class PotNotExistException extends JoinPotException {
  const PotNotExistException();
  @override
  String toString() => 'JoinPotException.PotNotExistException';
}

class PotAlreadyClosedException extends JoinPotException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'JoinPotException.PotAlreadyClosedException';
}

class PotFullException extends JoinPotException {
  const PotFullException();
  @override
  String toString() => 'JoinPotException.PotFullException';
}

class NetworkErrorException extends JoinPotException {
  final String error;
  const NetworkErrorException(this.error);
  @override
  String toString() => kDebugMode
      ? 'JoinPotException.NetworkErrorException(error: $error)'
      : 'JoinPotException.NetworkErrorException';
}

class UnknownException extends JoinPotException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => kDebugMode
      ? 'JoinPotException.UnknownException(error: $error)'
      : 'JoinPotException.UnknownException';
}
