import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/report_request_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';

@Injectable(as: ReportRepository)
class RestReportRepository implements ReportRepository {
  RestReportRepository(this._potApi);

  final ChatPotApi _potApi;

  @override
  Future<void> submit({
    required PotInfoEntity pot,
    required PotUserEntity target,
    required String reasonKey,
  }) async {
    try {
      await _potApi.report(
        pot.id,
        ReportRequestModel(userPk: target.id, reason: reasonKey),
      );
    } on DioException catch (e, stackTrace) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?) ??
                (e.message ?? 'Network error')
          : e.message ?? 'Network error';
      final errorId = L.e(e, stackTrace);
      throw ReportException.networkError(message, errorId);
    } catch (e, stackTrace) {
      final errorId = L.e(e, stackTrace);
      throw ReportException.unknown(e, errorId);
    }
  }
}
