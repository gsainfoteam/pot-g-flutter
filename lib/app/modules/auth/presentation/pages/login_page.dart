import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/user/data/data_source/constant/term_storage.dart';
import 'package:pot_g/gen/strings.g.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onDone,
    required this.onConsent,
    required this.onCancel,
  });

  final VoidCallback onDone;
  final VoidCallback onConsent;
  final VoidCallback onCancel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!(await _showLoginDialog())) return widget.onCancel();
      if (!(await _login())) return widget.onCancel();
      if (!mounted) return;
      final user = context.read<AuthBloc>().state.user;
      if (user == null) return widget.onCancel();
      if (!user.agreedTerms.allRequired) return widget.onDone();
      return widget.onConsent();
    });
  }

  Future<bool> _showLoginDialog() async {
    L.v('loginDialog');
    final result = await showOkCancelAlertDialog(
      context: context,
      title: context.t.unauthorized.title,
      message: context.t.unauthorized.description,
    );
    if (result != OkCancelResult.ok) {
      L.c('cancelLogin', from: 'loginDialog');
      return false;
    }
    L.c('continueLogin', from: 'loginDialog');
    return true;
  }

  Future<bool> _login() async {
    final bloc = context.read<AuthBloc>();
    final waiter = bloc.stream.firstWhere(
      (s) => s is AuthError || s is Authenticated,
    );
    bloc.add(const AuthEvent.login());
    final result = await waiter;
    if (result is! Authenticated) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
