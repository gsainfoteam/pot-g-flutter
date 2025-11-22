import 'package:flutter/material.dart';
import 'package:pot_g/app/modules/auth/domain/enums/withdraw_consent_type.dart';
import 'package:pot_g/gen/strings.g.dart';

extension WithdrawConsentTypeX on WithdrawConsentType {
  String getDescription(BuildContext context) {
    final consents = context.t.profile.withdraw.consents;
    switch (this) {
      case WithdrawConsentType.accountDeletion:
        return consents.account_deletion;
      case WithdrawConsentType.potInfoDeletion:
        return consents.pot_info_deletion;
      case WithdrawConsentType.restoreUnavailable:
        return consents.restore_unavailable;
    }
  }
}
