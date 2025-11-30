import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_pot_api.dart';
import 'package:pot_g/app/modules/chat/data/models/report_request_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/report_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/report_repository.dart';
import 'package:pot_g/app/modules/chat/data/models/report_response_model.dart';

@Injectable(as: ReportRepository)
class RestReportRepository implements ReportRepository {
  RestReportRepository(this._potApi);

  final ChatPotApi _potApi;

  @override
  Future<void> submit({
    required PotInfoEntity pot,
    required PotUserEntity target,
    required String reason,
  }) async {
    try {
      final result = await _potApi.report(
        pot.id,
        ReportRequestModel(reportTargetId: target.id, reason: reason),
      );
      switch (result.result) {
        case ReportResult.ok:
          return;
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?) ??
                (e.message ?? 'Network error')
          : e.message ?? 'Network error';
      throw ReportException.networkError(message);
    } on ArgumentError catch (e) {
      throw ReportException.unknownResponse(e.invalidValue);
    } catch (e) {
      throw ReportException.unknown(e);
    }
  }
}
