import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/gen/strings.g.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(TranslationProvider(child: const PotApp()));
}
