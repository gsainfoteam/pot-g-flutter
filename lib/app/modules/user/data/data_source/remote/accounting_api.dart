import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:pot_g/app/modules/user/data/models/accounting_model.dart';
import 'package:pot_g/app/modules/user/data/models/bank_model.dart';
import 'package:pot_g/app/modules/user/data/models/set_accounting_model.dart';
import 'package:retrofit/retrofit.dart';

part 'accounting_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/accounting/')
abstract class AccountingApi {
  @factoryMethod
  factory AccountingApi(PotDio dio) = _AccountingApi;

  @POST('me')
  Future<AccountingModel> setAccounting(@Body() SetAccountingModel request);

  @GET('bank')
  Future<List<BankModel>> getBankList();
}
