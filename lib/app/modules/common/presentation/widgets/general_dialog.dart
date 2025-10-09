import 'package:adaptive_dialog/adaptive_dialog.dart';
// ignore: implementation_imports
import 'package:adaptive_dialog/src/extensions/string.dart';
// ignore: depend_on_referenced_packages
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@useResult
Future<OkCancelResult> showGeneralOkCancelAdaptiveDialog({
  required BuildContext context,
  String? title,
  String? okLabel,
  String? cancelLabel,
  Widget? child,
  OkCancelAlertDefaultType? defaultType,
  bool isDestructiveAction = false,
  bool barrierDismissible = true,
  AdaptiveStyle? style,
  bool useRootNavigator = true,
  VerticalDirection actionsOverflowDirection = VerticalDirection.up,
  bool fullyCapitalizedForMaterial = true,
  bool canPop = true,
  PopInvokedWithResultCallback<OkCancelResult>? onPopInvokedWithResult,
  AdaptiveDialogBuilder? builder,
  RouteSettings? routeSettings,
}) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final adaptiveStyle = style ?? AdaptiveDialog.instance.defaultStyle;
  final isMaterial = adaptiveStyle.isMaterial(theme);
  String defaultCancelLabel() {
    final label = MaterialLocalizations.of(context).cancelButtonLabel;
    return isMaterial ? label : label.capitalizedForce;
  }

  void pop({required BuildContext context, required OkCancelResult? key}) =>
      Navigator.of(context, rootNavigator: useRootNavigator).pop(key);

  final titleText = title == null ? null : Text(title);
  final effectiveStyle = adaptiveStyle.effectiveStyle(theme);

  final actions = [
    AlertDialogAction(
      label: cancelLabel ?? defaultCancelLabel(),
      key: OkCancelResult.cancel,
      isDefaultAction: defaultType == OkCancelAlertDefaultType.cancel,
    ),
    AlertDialogAction(
      label: okLabel ?? MaterialLocalizations.of(context).okButtonLabel,
      key: OkCancelResult.ok,
      isDefaultAction:
          defaultType == null || defaultType == OkCancelAlertDefaultType.ok,
      isDestructiveAction: isDestructiveAction,
    ),
  ];

  switch (effectiveStyle) {
    // ignore: deprecated_member_use
    case AdaptiveStyle.cupertino:
    case AdaptiveStyle.iOS:
      final result = await showCupertinoDialog(
        context: context,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        builder: (context) {
          final dialog = PopScope(
            canPop: canPop,
            onPopInvokedWithResult: onPopInvokedWithResult,
            child: CupertinoAlertDialog(
              title: titleText,
              content: child,
              actions:
                  actions
                      .map(
                        (a) => a.convertToIOSDialogAction(
                          onPressed: (key) => pop(context: context, key: key),
                        ),
                      )
                      .toList(),
            ),
          );
          return builder == null ? dialog : builder(context, dialog);
        },
      );
      return result ?? OkCancelResult.cancel;
    case AdaptiveStyle.macOS:
      throw UnsupportedError('macOS is not supported');
    case AdaptiveStyle.material:
      final result = await showModal(
        context: context,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        configuration: FadeScaleTransitionConfiguration(
          barrierDismissible: barrierDismissible,
        ),
        builder: (context) {
          final dialog = PopScope(
            canPop: canPop,
            onPopInvokedWithResult: onPopInvokedWithResult,
            child: AlertDialog(
              title: titleText,
              content: child,
              actions:
                  actions
                      .map(
                        (a) => a.convertToMaterialDialogAction(
                          onPressed: (key) => pop(context: context, key: key),
                          destructiveColor: colorScheme.error,
                          fullyCapitalized: fullyCapitalizedForMaterial,
                        ),
                      )
                      .toList(),
              actionsOverflowDirection: actionsOverflowDirection,
              scrollable: true,
            ),
          );
          return builder == null ? dialog : builder(context, dialog);
        },
      );
      return result ?? OkCancelResult.cancel;
    case AdaptiveStyle.adaptive:
      throw StateError('unintended');
  }
}
