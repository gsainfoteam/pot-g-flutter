enum ReportReason {
  uncooperativeChat,
  noShow,
  badBehaviorDuringRide,
  settlementNoResponse,
  other;

  bool get requiresDetail => this == ReportReason.other;
}
