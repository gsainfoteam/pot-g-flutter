import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';

abstract class ConsentRepository {
  Future<void> updateConsent(List<TermEntity> terms);
}
