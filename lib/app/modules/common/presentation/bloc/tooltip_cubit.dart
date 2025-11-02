import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/domain/enums/tooltip_type.dart';
import 'package:pot_g/app/modules/common/domain/repositories/tooltip_repository.dart';

@injectable
class TooltipCubit extends Cubit<void> {
  final TooltipRepository _repository;

  TooltipCubit(this._repository) : super(null);

  Future<bool> shouldShowTooltip(TooltipType type) async {
    return await _repository.shouldShowTooltip(type);
  }

  Future<void> markTooltipAsShown(TooltipType type) async {
    await _repository.markTooltipAsShown(type);
  }
}

