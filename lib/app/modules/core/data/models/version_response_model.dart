import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_response_model.freezed.dart';
part 'version_response_model.g.dart';

@Freezed(toJson: false)
sealed class VersionResponseModel with _$VersionResponseModel {
  const factory VersionResponseModel({
    required String iosMinVersion,
    required String iosLatestVersion,
    required String aosMinVersion,
    required String aosLatestVersion,
  }) = _VersionResponseModel;

  factory VersionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VersionResponseModelFromJson(json);
}
