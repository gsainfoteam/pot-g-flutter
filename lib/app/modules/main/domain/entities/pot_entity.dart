import 'package:pot_g/app/modules/main/domain/entities/route_entity.dart';

abstract class PotEntity {
  const PotEntity({
    required this.id,
    required this.route,
    required this.startsAt,
    required this.endsAt,
    required this.current,
    required this.total,
  });

  final String id;
  final RouteEntity route;
  final DateTime startsAt;
  final DateTime endsAt;
  final int current;
  final int total;
}
