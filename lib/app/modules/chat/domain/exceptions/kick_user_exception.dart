import 'package:flutter/foundation.dart';

sealed class KickUserException implements Exception {
  const KickUserException();

  const factory KickUserException.notAHost() = NotAHostException;
  const factory KickUserException.notAParticipant() = NotAParticipantException;
  const factory KickUserException.userNotInPot() = UserNotInPotException;
  const factory KickUserException.afterDepartureConfirmed() =
      AfterDepartureConfirmedException;
  const factory KickUserException.notYetPaymentConfirmed() =
      NotYetPaymentConfirmedException;
  const factory KickUserException.potNotExist() = PotNotExistException;
  const factory KickUserException.potAlreadyClosed() =
      PotAlreadyClosedException;
  const factory KickUserException.unknownJsonValue(String unknownValue) =
      UnknownJsonValueException;
  const factory KickUserException.networkError(String error) =
      NetworkErrorException;
  const factory KickUserException.unknown(Object error) = UnknownException;
}

class NotAHostException extends KickUserException {
  const NotAHostException();
  @override
  String toString() => 'KickUserException.NotAHostException';
}

class NotAParticipantException extends KickUserException {
  const NotAParticipantException();
  @override
  String toString() => 'KickUserException.NotAParticipantException';
}

class UserNotInPotException extends KickUserException {
  const UserNotInPotException();
  @override
  String toString() => 'KickUserException.UserNotInPotException';
}

class AfterDepartureConfirmedException extends KickUserException {
  const AfterDepartureConfirmedException();
  @override
  String toString() => 'KickUserException.AfterDepartureConfirmedException';
}

class NotYetPaymentConfirmedException extends KickUserException {
  const NotYetPaymentConfirmedException();
  @override
  String toString() => 'KickUserException.NotYetPaymentConfirmedException';
}

class PotNotExistException extends KickUserException {
  const PotNotExistException();
  @override
  String toString() => 'KickUserException.PotNotExistException';
}

class PotAlreadyClosedException extends KickUserException {
  const PotAlreadyClosedException();
  @override
  String toString() => 'KickUserException.PotAlreadyClosedException';
}

class UnknownJsonValueException extends KickUserException {
  final String unknownValue;
  const UnknownJsonValueException(this.unknownValue);
  @override
  String toString() => kDebugMode
      ? 'KickUserException.UnknownJsonValueException(error: $unknownValue)'
      : 'KickUserException.UnknownJsonValueException';
}

class NetworkErrorException extends KickUserException {
  final String error;
  const NetworkErrorException(this.error);

  @override
  String toString() => kDebugMode
      ? 'KickUserException.NetworkErrorException(error: $error)'
      : 'KickUserException.NetworkErrorException';
}

class UnknownException extends KickUserException {
  final Object error;
  const UnknownException(this.error);
  @override
  String toString() => kDebugMode
      ? 'KickUserException.UnknownException(error: $error)'
      : 'KickUserException.UnknownException';
}
