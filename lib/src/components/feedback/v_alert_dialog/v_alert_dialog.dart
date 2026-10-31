import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button/v_button.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_alert_dialog_style.dart';

/// Modal dialog that asks the user to confirm or cancel before going on.
///
/// Unlike [VDialog], a tap on the barrier does not close it unless
/// `barrierDismissible` is set. Both buttons close the dialog after calling
/// their callback.
///
/// ```dart
/// VAlertDialog.show<void>(
///   context,
///   title: const Text('Delete item'),
///   description: const Text('This cannot be undone.'),
///   confirmText: 'Delete',
///   cancelText: 'Cancel',
///   destructive: true,
///   onConfirm: deleteItem,
/// );
/// ```
class VAlertDialog extends StatelessWidget {
  /// Creates an alert dialog; use [show] to display it in a route.
  const VAlertDialog({
    required this.description,
    super.key,
    this.title,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.destructive = false,
    this.style,
  });

  /// Style override.
  final VAlertDialogStyle? style;

  /// Heading shown above [description], in the large title style.
  final Widget? title;

  /// Message body of the dialog.
  final Widget description;

  /// Label of the cancel button; no cancel button is shown when null.
  final String? cancelText;

  /// Label of the confirm button; defaults to "OK".
  final String? confirmText;

  /// Called when the cancel button is pressed, right after the dialog closes.
  ///
  /// The dialog is popped first, so a callback may push another route or open
  /// another dialog without that route being popped in its place.
  final VoidCallback? onCancel;

  /// Called when the confirm button is pressed, right after the dialog closes.
  ///
  /// The dialog is popped first, so a callback may push another route or open
  /// another dialog without that route being popped in its place.
  final VoidCallback? onConfirm;

  /// Whether the confirm button uses the destructive color.
  final bool destructive;

  /// Shows an alert dialog above the current route.
  ///
  /// Returns a future that completes when the dialog closes. When
  /// [barrierDismissible] is true a barrier tap closes it.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget description,
    Widget? title,
    String? cancelText,
    String? confirmText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool destructive = false,
    bool barrierDismissible = false,
  }) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: localizations.alertDialogDismissLabel,
      barrierColor: themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.fast ?? VAnimations.defaults.fast,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        final dialog = VAlertDialog(
          title: title,
          description: description,
          cancelText: cancelText,
          confirmText: confirmText,
          onCancel: onCancel,
          onConfirm: onConfirm,
          destructive: destructive,
        );
        return themeData != null
            ? VTheme(
                data: themeData,
                localizations: localizations,
                child: dialog,
              )
            : dialog;
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: themeData?.animations.curveEaseOut ?? Curves.easeOut,
                ),
              ),
              child: child,
            ),
          ),
    );
  }

  /// Closes the topmost route, returning [result] to the [show] future.
  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VAlertDialogStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    var bgColor = colors.card;
    var borderRadius = theme.radius.lgRadius;
    var contentPadding = EdgeInsets.all(theme.spacing.xxl);
    var titleTextColor = colors.foreground;
    var descTextColor = colors.mutedForeground;

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      borderRadius = resolvedStyle.borderRadius ?? borderRadius;
      contentPadding = resolvedStyle.padding ?? contentPadding;
      titleTextColor = resolvedStyle.foregroundColor ?? titleTextColor;
      descTextColor = resolvedStyle.foregroundColor ?? descTextColor;
    }

    final effectiveTitleStyle =
        (resolvedStyle?.titleStyle ?? typography.titleLarge).copyWith(
          color: titleTextColor,
          decoration: TextDecoration.none,
        );

    return FocusTraversalGroup(
      child: DefaultTextStyle(
        style: typography.bodyMedium.copyWith(
          color: descTextColor,
          decoration: TextDecoration.none,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.xxl),
              child: Container(
                padding: contentPadding,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: borderRadius,
                  boxShadow: theme.shadows.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: theme.spacing.sm),
                        child: DefaultTextStyle.merge(
                          style: effectiveTitleStyle,
                          child: title!,
                        ),
                      ),
                    // WCAG 4.1.3: liveRegion for alert dialog description
                    Semantics(liveRegion: true, child: description),
                    Padding(
                      padding: EdgeInsets.only(top: theme.spacing.xxl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (cancelText != null) ...[
                            VButton.outlined(
                              onPressed: () {
                                close<void>(context);
                                onCancel?.call();
                              },
                              child: Text(cancelText!),
                            ),
                            SizedBox(width: theme.spacing.sm),
                          ],
                          VButton(
                            color: destructive
                                ? VButtonColor.destructive
                                : VButtonColor.primary,
                            onPressed: () {
                              close<void>(context);
                              onConfirm?.call();
                            },
                            child: Text(
                              confirmText ??
                                  VoloLocalizations.of(context).dialogOk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
