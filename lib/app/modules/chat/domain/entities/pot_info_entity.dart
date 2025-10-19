import 'package:pot_g/app/modules/chat/domain/entities/pot_accounting_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/enums/pot_status.dart';
import 'package:pot_g/app/modules/list/domain/entities/pot_overview_entity.dart';

abstract class PotInfoEntity implements PotOverviewEntity {
  DateTime? get departureTime;
  PotStatus get status;
  PotAccountingInfoEntity get accountingInfo;
}
