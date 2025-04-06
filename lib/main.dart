import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/gen/strings.g.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await configureDependencies();
  runApp(TranslationProvider(child: const PotApp()));
}
