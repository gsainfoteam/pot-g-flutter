import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/app_version_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/link_bloc.dart';
import 'package:pot_g/app/router.gr.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      final link = context.read<LinkBloc>().state.link;
      context.router.replaceAll([ListRoute()]);
      if (link.isNotEmpty) {
        context.router.pushPath(link);
      }
      context.read<AppVersionBloc>().add(const AppVersionEvent.init());
      Future.delayed(const Duration(milliseconds: 200), () {
        FlutterNativeSplash.remove();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
