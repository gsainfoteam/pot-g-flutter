import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/extensions/toast.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/app_version_bloc.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/gen/strings.g.dart';

class UpdateListener extends StatelessWidget {
  const UpdateListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppVersionBloc, AppVersionState>(
      listener: (context, state) async {
        switch (state) {
          case AppVersionStateData(
            :final updateAvailable,
            :final updateRequired,
          ):
            if (updateRequired) {
              showOkAlertDialog(
                context: getAppRouter().navigatorKey.currentContext!,
                title: context.t.update.required.title,
                message: context.t.update.required.message,
                okLabel: context.t.update.required.button,
              );
              return;
            }
            if (updateAvailable) {
              showOkAlertDialog(
                context: getAppRouter().navigatorKey.currentContext!,
                title: context.t.update.available.title,
                message: context.t.update.available.message,
                okLabel: context.t.update.available.button,
              );
            }
            break;
          case AppVersionStateError(:final message):
            context.showToast('App version error: $message');
            break;
          default:
        }
      },
      child: child,
    );
  }
}
