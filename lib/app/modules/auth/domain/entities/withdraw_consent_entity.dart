import 'package:pot_g/app/modules/auth/domain/enums/withdraw_consent_type.dart';

final class WithdrawConsentEntity {
  final WithdrawType type;
  final bool isAgreed;
  final String description;
  const WithdrawConsentEntity({
    required this.type,
    required this.isAgreed,
    required this.description,
  });
}
