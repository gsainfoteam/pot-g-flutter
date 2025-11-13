abstract interface class MessagingRepository {
  Future<void> init();
  Future<void> refresh();
}
