import 'package:flutter/widgets.dart';
import 'package:pot_g/app/modules/chat/domain/enums/report_reason.dart';
import 'package:pot_g/gen/strings.g.dart';

extension ReportReasonLocalizationX on ReportReason {
  String label(BuildContext context) {
    final items =
        context.t.chat_room.drawer.actions.report.page.fields.reason.items;
    switch (this) {
      case ReportReason.uncooperativeChat:
        return items.uncooperative_chat;
      case ReportReason.noShow:
        return items.no_show;
      case ReportReason.badBehaviorDuringRide:
        return items.bad_behavior_during_ride;
      case ReportReason.settlementNoResponse:
        return items.settlement_no_response;
      case ReportReason.other:
        return items.other;
    }
  }
}
