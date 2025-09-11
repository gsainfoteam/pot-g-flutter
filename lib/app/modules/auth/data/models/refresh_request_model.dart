import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_request_model.freezed.dart';
part 'refresh_request_model.g.dart';

@freezed
sealed class RefreshRequestModel with _$RefreshRequestModel {
  const factory RefreshRequestModel({required String refreshToken}) =
      _RefreshRequestModel;

  factory RefreshRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestModelFromJson(json);
}
