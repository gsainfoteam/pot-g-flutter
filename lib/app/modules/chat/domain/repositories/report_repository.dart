import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';

abstract interface class ReportRepository {
  Future<void> submit({
    required PotInfoEntity pot,
    required PotUserEntity target,
    required String reason,
  });
}
