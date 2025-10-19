import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pot_g/app/modules/core/data/models/pot_model.dart';

part 'pot_list_model.freezed.dart';
part 'pot_list_model.g.dart';

@Freezed(toJson: false)
sealed class PotListModel with _$PotListModel {
  factory PotListModel({
    required int total,
    required int offset,
    required int limit,
    required List<PotModel> list,
  }) = _PotListModel;

  factory PotListModel.fromJson(Map<String, dynamic> json) =>
      _$PotListModelFromJson(json);
}
