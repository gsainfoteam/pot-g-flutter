import 'package:pot_g/gen/strings.g.dart';

enum WithdrawConsentType {
  accountDeletion,
  potInfoDeletion,
  restoreUnavailable;

  String getDescription(Translations locale) {
    switch (this) {
      case WithdrawConsentType.accountDeletion:
        return locale.profile.withdraw.consents.account_deletion;
      case WithdrawConsentType.potInfoDeletion:
        return locale.profile.withdraw.consents.pot_info_deletion;
      case WithdrawConsentType.restoreUnavailable:
        return locale.profile.withdraw.consents.restore_unavailable;
    }
  }
}
