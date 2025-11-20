import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_request_model.freezed.dart';
part 'report_request_model.g.dart';

@freezed
sealed class ReportRequestModel with _$ReportRequestModel {
  const factory ReportRequestModel({
    @JsonKey(name: 'user_pk') required String userPk,
    required String reason,
  }) = _ReportRequestModel;

  factory ReportRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestModelFromJson(json);
}
