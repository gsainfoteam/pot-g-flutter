import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/list/data/data_source/remote/join_pot_api.dart';
import 'package:pot_g/app/modules/list/data/models/join_pot_response_model.dart';
import 'package:pot_g/app/modules/list/domain/exceptions/join_pot_exception.dart';
import 'package:pot_g/app/modules/list/domain/repositories/join_pot_repository.dart';

@Injectable(as: JoinPotRepository)
class RestJoinPotRepository implements JoinPotRepository {
  final JoinPotApi _api;

  RestJoinPotRepository(this._api);

  @override
  Future<void> joinPot(String potId) async {
    try {
      final result = await _api.joinPot(potId);
      switch (result.result) {
        case JoinPotResult.ok:
          return;
        case JoinPotResult.afterDepartureConfirmed:
          throw JoinPotException.afterDepartureConfirmed();
        case JoinPotResult.potNotExist:
          throw JoinPotException.potNotExist();
        case JoinPotResult.potAlreadyClosed:
          throw JoinPotException.potAlreadyClosed();
        case JoinPotResult.potFull:
          throw JoinPotException.potFull();
      }
    } on DioException catch (e) {
      throw JoinPotException.networkError(e.error.toString());
    }
  }
}
