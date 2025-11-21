sealed class ReportException implements Exception {
  const ReportException();

  const factory ReportException.alreadyReported() = AlreadyReportedException;
  const factory ReportException.invalidTarget() = InvalidTargetException;
  const factory ReportException.invalidReason() = InvalidReasonException;
  const factory ReportException.potNotFound() = PotNotFoundException;
  const factory ReportException.networkError(String error) =
      ReportNetworkException;
  const factory ReportException.unknown(Object error) = ReportUnknownException;
}

class AlreadyReportedException extends ReportException {
  const AlreadyReportedException();
  @override
  String toString() => 'ReportException.AlreadyReportedException';
}

class InvalidTargetException extends ReportException {
  const InvalidTargetException();
  @override
  String toString() => 'ReportException.InvalidTargetException';
}

class InvalidReasonException extends ReportException {
  const InvalidReasonException();
  @override
  String toString() => 'ReportException.InvalidReasonException';
}

class PotNotFoundException extends ReportException {
  const PotNotFoundException();
  @override
  String toString() => 'ReportException.PotNotFoundException';
}

class ReportNetworkException extends ReportException {
  final String error;
  const ReportNetworkException(this.error);

  @override
  String toString() => 'ReportException.ReportNetworkException(error: $error)';
}

class ReportUnknownException extends ReportException {
  final Object error;
  const ReportUnknownException(this.error);
  @override
  String toString() => 'ReportException.ReportUnknownException(error: $error)';
}
