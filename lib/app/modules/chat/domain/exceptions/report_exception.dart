sealed class ReportException implements Exception {
  const ReportException();

  String? get errorId;

  const factory ReportException.networkError(String error, [String? errorId]) =
      ReportNetworkException;
  const factory ReportException.unknown(Object error, [String? errorId]) =
      ReportUnknownException;

  ReportException withErrorId(String errorId);
}

class ReportNetworkException extends ReportException {
  final String error;
  @override
  final String? errorId;
  const ReportNetworkException(this.error, [this.errorId]);

  @override
  ReportException withErrorId(String errorId) =>
      ReportException.networkError(error, errorId);

  @override
  String toString() =>
      'ReportException.ReportNetworkException(error: $error, errorId: $errorId)';
}

class ReportUnknownException extends ReportException {
  final Object error;
  @override
  final String? errorId;
  const ReportUnknownException(this.error, [this.errorId]);

  @override
  ReportException withErrorId(String errorId) =>
      ReportException.unknown(error, errorId);

  @override
  String toString() =>
      'ReportException.ReportUnknownException(error: $error, errorId: $errorId)';
}
