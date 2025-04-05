abstract class PotEntity {
  const PotEntity({
    required this.id,
    required this.route,
    required this.date,
    required this.current,
    required this.total,
  });

  final String id;
  final String route;
  final DateTime date;
  final int current;
  final int total;
}
