abstract class PushSettingEntity {
  const PushSettingEntity({
    required this.anyPush,
    required this.chatPush,
    required this.potInOutPush,
    required this.marketingPush,
  });

  final bool anyPush;
  final bool chatPush;
  final bool potInOutPush;
  final bool marketingPush;
}
