import 'package:pot_g/app/modules/core/domain/entities/route_entity.dart';

abstract class CreatePotRepository {
  Future<String> createPot({
    required String routeId,
    required DateTime startsAt,
    required DateTime endsAt,
    required int maxCount,
  });
}
