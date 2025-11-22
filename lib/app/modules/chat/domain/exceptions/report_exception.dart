sealed class ReportException implements Exception {
  const ReportException();

  String get errorId;

  const factory ReportException.networkError(String error, String errorId) =
      ReportNetworkException;
  const factory ReportException.unknown(Object error, String errorId) =
      ReportUnknownException;
}

class ReportNetworkException extends ReportException {
  final String error;
  @override
  final String errorId;
  const ReportNetworkException(this.error, this.errorId);

  @override
  String toString() => 'ReportException.ReportNetworkException(error: $error)';
}

class ReportUnknownException extends ReportException {
  final Object error;
  @override
  final String errorId;
  const ReportUnknownException(this.error, this.errorId);

  @override
  String toString() =>
      'ReportException.ReportUnknownException(error: $error, errorId: $errorId)';
}
