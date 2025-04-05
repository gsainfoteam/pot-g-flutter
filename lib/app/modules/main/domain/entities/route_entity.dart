import 'package:pot_g/app/modules/main/domain/entities/stop_entity.dart';

abstract class RouteEntity {
  const RouteEntity({required this.id, required this.from, required this.to});

  final String id;
  final StopEntity from;
  final StopEntity to;

  @override
  String toString() => '$from → $to';
}
