import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/app_bloc_observer.dart';
import 'package:pot_g/firebase_options.dart';
import 'package:pot_g/gen/strings.g.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  await configureDependencies();
  runApp(TranslationProvider(child: const PotApp()));
}
