import 'package:material_ui/material_ui.dart';

abstract interface class PageLogger {
  String get pageName;
  Map<String, Object> get pageProperties => {};
}

mixin LogPage on StatelessWidget implements PageLogger {
  @override
  Map<String, Object> get pageProperties => {};
}

mixin LogPageState on StatefulWidget implements PageLogger {
  @override
  Map<String, Object> get pageProperties => {};
}
