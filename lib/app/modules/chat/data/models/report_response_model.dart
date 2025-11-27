import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_response_model.freezed.dart';
part 'report_response_model.g.dart';

@Freezed(toJson: false)
sealed class ReportResponseModel with _$ReportResponseModel {
  const factory ReportResponseModel({required String result}) =
      _ReportResponseModel;

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReportResponseModelFromJson(json);
}
