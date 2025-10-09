import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_request_model.dart';
import 'package:pot_g/app/modules/chat/data/models/confirm_departure_time_response_model.dart';
import 'package:pot_g/app/modules/chat/data/models/get_pot_events_query_model.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_events_model.dart';
import 'package:pot_g/app/modules/chat/data/models/pot_info_model.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_pot_api.g.dart';

@injectable
@RestApi(baseUrl: '/api/v1/pot/')
abstract class ChatPotApi {
  @factoryMethod
  factory ChatPotApi(PotDio dio) = _ChatPotApi;

  @GET('{id}/info')
  Future<PotInfoModel> getPotInfo(@Path('id') String id);

  @GET('{id}/events')
  Future<PotEventsModel> getPotEvents(
    @Path('id') String id,
    @Queries() GetPotEventsQueryModel query,
  );

  @POST('{id}/departure/confirm')
  Future<ConfirmDepartureTimeResponseModel> confirmDepartureTime(
    @Path('id') String id,
    @Body() ConfirmDepartureTimeRequestModel request,
  );
}
