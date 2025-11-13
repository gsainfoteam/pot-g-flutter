import 'package:pot_g/app/modules/common/domain/enums/tooltip_type.dart';

abstract interface class TooltipRepository {
  /// Checks whether the tooltip should be shown.
  /// [type] is the tooltip type.
  /// Returns true if should show, false if already shown.
  /// Note: Detailed display conditions (e.g., pot status, user role) should be
  /// determined by the caller. This method only checks if the tooltip has been
  /// shown before.
  Future<bool> shouldShowTooltip(TooltipType type);

  /// Marks the tooltip as shown.
  /// After this, shouldShowTooltip will return false.
  Future<void> markTooltipAsShown(TooltipType type);
}
