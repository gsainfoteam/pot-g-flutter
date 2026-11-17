import 'package:material_ui/material_ui.dart';

extension BuildContextX on BuildContext {
  void showToast(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), showCloseIcon: true));
  }
}
