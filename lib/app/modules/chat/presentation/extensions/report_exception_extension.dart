import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/gen/strings.g.dart';

extension ReportExceptionX on ReportException {
  String getErrorMessage(BuildContext context) {
    final errors = context.t.chat_room.drawer.actions.report.error;
    switch (this) {
      case AlreadyReportedException():
        return errors.already_reported;
      case InvalidTargetException():
        return errors.invalid_target;
      case InvalidReasonException():
        return errors.invalid_reason;
      case PotNotFoundException():
        return errors.pot_not_found;
      case ReportNetworkException():
        return errors.network_error;
      case ReportUnknownException():
        return errors.unknown;
    }
  }
}
