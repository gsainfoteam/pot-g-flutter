import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.child});

  final Widget child;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _isReady = true;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          FlutterNativeSplash.remove();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isReady ? widget.child : const Scaffold();
  }
}
