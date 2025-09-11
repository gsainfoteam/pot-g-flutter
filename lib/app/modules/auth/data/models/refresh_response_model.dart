import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_response_model.freezed.dart';
part 'refresh_response_model.g.dart';

@freezed
sealed class RefreshResponseModel with _$RefreshResponseModel {
  const factory RefreshResponseModel({required String accessToken}) =
      _RefreshResponseModel;

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseModelFromJson(json);
}
