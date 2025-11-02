abstract class StopEntity {
  const StopEntity({required this.id, required this.name});

  final String id;
  final String name;
}

// NOTE: temporarily hardcoded
extension StopEntityX on StopEntity {
  double get latitude => 35.229439;
  double get longitude => 126.847013;
}
