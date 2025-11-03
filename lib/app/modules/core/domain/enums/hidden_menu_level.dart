enum HiddenMenuLevel {
  none([]),
  all(HiddenMenuType.values),
  qa([HiddenMenuType.accessQa]);

  final List<HiddenMenuType> types;
  const HiddenMenuLevel(this.types);
}

enum HiddenMenuType { accessQa, accessAllChannels }
