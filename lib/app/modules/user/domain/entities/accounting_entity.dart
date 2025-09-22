abstract class AccountingEntity {
  const AccountingEntity({
    required this.isSet,
    this.bankShortName,
    this.account,
  });

  final bool isSet;
  final String? bankShortName;
  final String? account;
}
