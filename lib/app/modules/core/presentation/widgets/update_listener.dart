import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/core/presentation/bloc/app_version_bloc.dart';
import 'package:pot_g/app/pot_app.dart';
import 'package:pot_g/app/values/config.dart';
import 'package:pot_g/gen/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchStore() {
  try {
    launchUrl(
      Platform.isAndroid
          ? Uri.parse(Config.playStoreUrl)
          : Uri.parse(Config.appStoreUrl),
    );
  } catch (_) {}
}

class UpdateListener extends StatelessWidget {
  const UpdateListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppVersionBloc, AppVersionState>(
      listener: (context, state) async {
        final context = getAppRouter().navigatorKey.currentContext;
        if (context == null) return;
        switch (state) {
          case AppVersionStateData(:final versionInfo):
            if (versionInfo.updateRequired) {
              await showOkAlertDialog(
                context: context,
                title: context.t.update.required.title,
                message: context.t.update.required.message(
                  currentVersion: versionInfo.currentVersion,
                  latestVersion: versionInfo.latestVersion,
                ),
                okLabel: context.t.update.required.button,
              );
              _launchStore();
              return;
            }
            if (versionInfo.updateAvailable) {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: context.t.update.available.title,
                message: context.t.update.available.message(
                  currentVersion: versionInfo.currentVersion,
                  latestVersion: versionInfo.latestVersion,
                ),
                okLabel: context.t.update.available.button,
                cancelLabel: context.t.update.available.next,
              );
              if (result == OkCancelResult.ok) _launchStore();
            }
            break;
          case AppVersionStateError(:final message):
            await showOkAlertDialog(
              context: context,
              title: 'App version error',
              message: message,
            );
            break;
          default:
        }
      },
      child: child,
    );
  }
}
