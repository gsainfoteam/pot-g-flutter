enum ReportReason {
  uncooperativeChat('uncooperative_chat'),
  noShow('no_show'),
  badBehaviorDuringRide('bad_behavior_during_ride'),
  settlementNoResponse('settlement_no_response'),
  other('other');

  const ReportReason(this.key);

  final String key;

  bool get requiresDetail => this == ReportReason.other;

  static ReportReason fromKey(String key) {
    return ReportReason.values.firstWhere((reason) => reason.key == key);
  }
}
