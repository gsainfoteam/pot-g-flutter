import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/core/domain/entities/pot_summary_entity.dart';

abstract class PotDetailEntity extends PotSummaryEntity {
  const PotDetailEntity({
    required super.id,
    required super.route,
    required super.startsAt,
    required super.endsAt,
    required super.current,
    required super.total,
    required this.name,
    required this.departureTime,
    required this.status,
    required this.accountingRequested,
  });

  final String name;
  final DateTime departureTime;
  final PotStatus status;
  final int accountingRequested;
}
