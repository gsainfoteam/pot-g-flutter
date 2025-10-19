import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_model.freezed.dart';
part 'consent_model.g.dart';

@Freezed(toJson: true)
sealed class ConsentModel with _$ConsentModel {
  const factory ConsentModel({
    required List<String> requiredTerms,
    required List<String> optionalTerms,
  }) = _ConsentModel;
}
