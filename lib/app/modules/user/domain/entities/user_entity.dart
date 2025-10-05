class UserEntity {
  /// 자신인 경우에는 `me` 를 사용합니다.
  /// 추후 서버 설계에 따라 달라질 수 있습니다
  final String id;
  final String name;

  const UserEntity({required this.id, required this.name});
}
