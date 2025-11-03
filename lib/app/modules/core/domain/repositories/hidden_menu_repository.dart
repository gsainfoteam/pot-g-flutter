abstract class HiddenMenuRepository {
  Future<bool> isHiddenMenuEnabled();
  Future<void> setHiddenMenuEnabled(bool enabled);
}
