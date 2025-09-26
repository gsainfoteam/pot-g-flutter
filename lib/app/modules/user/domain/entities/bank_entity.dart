abstract class BankEntity {
  const BankEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;
}
