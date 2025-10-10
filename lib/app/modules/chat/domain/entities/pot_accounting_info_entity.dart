abstract class PotAccountingInfoEntity {
  bool get requested;
  String? get requestingUser;
  List<String> get requestedUsers;
  int? get totalCost;
  int? get costPerUser;
  String? get bankName;
  String? get bankAccount;
}
