import 'package:flutter/material.dart';

mixin LogPage on StatelessWidget {
  String get pageName;
  Map<String, Object> get pageProperties => {};
}

mixin LogPageState on StatefulWidget {
  String get pageName;
  Map<String, Object> get pageProperties => {};
}
