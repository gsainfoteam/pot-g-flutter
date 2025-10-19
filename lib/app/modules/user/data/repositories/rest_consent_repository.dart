import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/user/data/data_source/remote/user_api.dart';
import 'package:pot_g/app/modules/user/data/models/consent_model.dart';
import 'package:pot_g/app/modules/user/domain/entities/term_entity.dart';
import 'package:pot_g/app/modules/user/domain/repositories/consent_repository.dart';

@Injectable(as: ConsentRepository)
class RestConsentRepository implements ConsentRepository {
  final UserApi _userApi;
  RestConsentRepository(this._userApi);

  @override
  Future<void> updateConsent(List<TermEntity> terms) {
    return _userApi.updateConsent(
      ConsentModel(
        requiredTerms: terms.map((e) => e.slug).toList(),
        optionalTerms: [],
      ),
    );
  }
}
