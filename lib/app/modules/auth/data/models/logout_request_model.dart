import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_request_model.freezed.dart';
part 'logout_request_model.g.dart';

@Freezed(toJson: true)
sealed class LogoutRequestModel with _$LogoutRequestModel {
  const factory LogoutRequestModel({required String refreshToken}) =
      _LogoutRequestModel;
}
