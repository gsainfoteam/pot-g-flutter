abstract class CreatePotRepository {
  Future<String> createPot({
    required String routeId,
    required DateTime startsAt,
    required DateTime endsAt,
    required int maxCount,
  });
}
