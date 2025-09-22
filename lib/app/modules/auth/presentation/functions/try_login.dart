import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/gen/strings.g.dart';

Future<bool> tryLogin(BuildContext context) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: context.t.unauthorized.title,
    message: context.t.unauthorized.description,
  );
  if (!context.mounted) return false;
  if (result != OkCancelResult.ok) return false;

  final bloc = context.read<AuthBloc>();
  final waiter = bloc.stream.firstWhere(
    (s) => s is AuthError || s is Authenticated,
  );
  bloc.add(const AuthEvent.login());
  final result2 = await waiter;
  if (!context.mounted) return false;
  if (result2 is! Authenticated) return false;
  return true;
}
