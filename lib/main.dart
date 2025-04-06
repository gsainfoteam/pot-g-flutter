import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/firebase_options.dart';
import 'package:pot_g/gen/strings.g.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(TranslationProvider(child: const PotApp()));
}
