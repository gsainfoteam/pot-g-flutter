import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/gen/strings.g.dart';

extension ReportExceptionX on ReportException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.drawer.actions.report.error;
    final message = switch (this) {
      ReportNetworkException() => errors.network_error,
      ReportUnknownException() => errors.unknown,
    };
    return '$message ($errorId)';
  }
}
