import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/data_sources/remote/chat_accounting_api.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_confirm_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_confirm_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_request_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_request_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_result_model.dart';
import 'package:pot_g/app/modules/chat/domain/entities/accounting_result_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_info_entity.dart';
import 'package:pot_g/app/modules/chat/domain/entities/pot_user_entity.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/accounting_confirm_exception.dart';
import 'package:pot_g/app/modules/chat/domain/exceptions/accounting_request_exception.dart';
import 'package:pot_g/app/modules/chat/domain/repositories/pot_accounting_repository.dart';

@Injectable(as: PotAccountingRepository)
class WebsocketPotAccountingRepository implements PotAccountingRepository {
  final ChatAccountingApi _accountingApi;

  WebsocketPotAccountingRepository(this._accountingApi);

  @override
  Future<void> accounting(
    PotInfoEntity pot,
    int amount,
    List<PotUserEntity> targets,
  ) async {
    try {
      final result = await _accountingApi.requestAccounting(
        pot.id,
        AccountingRequestRequestModel(
          totalCost: amount,
          costPerUser: amount ~/ (targets.length + 1),
          accountInfo: AccountInfo(useExistInfo: true),
          requestedUser: targets.map((e) => e.id).toList(),
        ),
      );
      switch (result.result) {
        case AccountingResult.ok:
          return;
        case AccountingResult.alreadyRequested:
          throw AccountingRequestException.alreadyRequested();
        case AccountingResult.accountInfoNotSet:
          throw AccountingRequestException.accountInfoNotSet();
        case AccountingResult.costCannotBeNegative:
          throw AccountingRequestException.costCannotBeNegative();
        case AccountingResult.costPerUserMismatch:
          throw AccountingRequestException.costPerUserMismatch();
        case AccountingResult.beforeDeparture:
          throw AccountingRequestException.beforeDeparture();
        case AccountingResult.notAParticipant:
          throw AccountingRequestException.notAParticipant();
        case AccountingResult.potNotExist:
          throw AccountingRequestException.potNotExist();
        case AccountingResult.potAlreadyClosed:
          throw AccountingRequestException.potAlreadyClosed();
      }
    } on DioException catch (e) {
      throw AccountingRequestException.networkError(
        e.message ?? e.error.toString(),
      );
    } on ArgumentError catch (e) {
      throw AccountingRequestException.unknownResponse(
        e.invalidValue.toString(),
      );
    }
  }

  @override
  Future<void> confirmAccounting(
    PotInfoEntity pot,
    List<AccountingResultEntity> accountingResults,
  ) async {
    try {
      final result = await _accountingApi.confirmAccounting(
        pot.id,
        AccountingConfirmRequestModel(
          accountingResults: accountingResults.map(_toModel).toList(),
        ),
      );
      switch (result.result) {
        case AccountingConfirmResult.ok:
          return;
        case AccountingConfirmResult.notYetRequested:
          throw AccountingConfirmException.notYetRequested();
        case AccountingConfirmResult.notAccountingRequester:
          throw AccountingConfirmException.notAccountingRequester();
        case AccountingConfirmResult.potNotExist:
          throw AccountingConfirmException.potNotExist();
        case AccountingConfirmResult.potAlreadyClosed:
          throw AccountingConfirmException.potAlreadyClosed();
      }
    } on DioException catch (e) {
      throw AccountingConfirmException.networkError(
        e.message ?? e.error.toString(),
      );
    } on ArgumentError catch (e) {
      throw AccountingConfirmException.unknownResponse(
        e.invalidValue.toString(),
      );
    }
  }

  AccountingResultModel _toModel(AccountingResultEntity entity) {
    return AccountingResultModel(
      userPk: entity.userPk,
      accountingDone: entity.accountingDone,
    );
  }
}
