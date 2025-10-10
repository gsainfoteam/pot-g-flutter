import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_confirm_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_confirm_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_request_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/accounting_request_response_model.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_accounting_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/accounting/pot/')
abstract class ChatAccountingApi {
  @factoryMethod
  factory ChatAccountingApi(PotDio dio) = _ChatAccountingApi;

  @POST('{id}/request')
  Future<AccountingRequestResponseModel> requestAccounting(
    @Path('id') String id,
    @Body() AccountingRequestRequestModel request,
  );

  @POST('{id}/confirm')
  Future<AccountingConfirmResponseModel> confirmAccounting(
    @Path('id') String id,
    @Body() AccountingConfirmRequestModel request,
  );
}
