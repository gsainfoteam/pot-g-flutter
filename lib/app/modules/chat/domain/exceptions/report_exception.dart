sealed class ReportException implements Exception {
  const ReportException();

  String? get errorId;

  const factory ReportException.networkError(String error, [String? errorId]) =
      ReportNetworkException;
  const factory ReportException.unknownResponse(
    String invalidArgument, [
    String? errorId,
  ]) = ReportUnknownResponseException;
  const factory ReportException.unknown(Object error, [String? errorId]) =
      ReportUnknownException;

  ReportException withErrorId(String errorId);
}

class ReportUnknownResponseException extends ReportException {
  final String invalidArgument;
  @override
  final String? errorId;
  const ReportUnknownResponseException(this.invalidArgument, [this.errorId]);

  @override
  ReportException withErrorId(String errorId) =>
      ReportException.unknownResponse(invalidArgument, errorId);

  @override
  String toString() =>
      'ReportException.ReportUnknownResponseException(invalidArgument: $invalidArgument, errorId: $errorId)';
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
