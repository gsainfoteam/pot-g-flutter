import 'package:flutter/material.dart';

abstract class LogPage {
  String get pageName;
}

mixin LogPageStateless on StatelessWidget implements LogPage {}

mixin LogPageState<T extends StatefulWidget> on State<T> implements LogPage {}
