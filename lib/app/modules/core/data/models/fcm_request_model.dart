import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/domain/enums/os.dart';

part 'fcm_request_model.freezed.dart';
part 'fcm_request_model.g.dart';

@Freezed(toJson: true)
sealed class FcmRequestModel with _$FcmRequestModel {
  factory FcmRequestModel({
    required String fcmToken,
    required OS os,
    required String version,
  }) = _FcmRequestModel;
}
