abstract class HiddenMenuRepository {
  Future<bool> isHiddenMenuEnabled();
  Future<void> tryEnable(String secret);
  Future<void> disable();
}
