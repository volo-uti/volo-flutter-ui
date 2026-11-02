import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button/v_button.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_dialog_style.dart';

/// Dialog button alignment.
enum VDialogActionsAlignment {
  /// Left aligned.
  start,

  /// Center aligned.
  center,

  /// Right aligned (default).
  end,
}

/// {@template v_dialog}
/// Modal dialog with a title, content and a row of actions.
///
/// Built with [VDialog.alert] (one button), [VDialog.confirm] (cancel and
/// confirm) or [VDialog.custom] (your own actions), and shown with [show].
/// A tap on the barrier or Escape closes it while `barrierDismissible` is true.
///
/// ```dart
/// VDialog.show<void>(
///   context,
///   VDialog.confirm(
///     title: const Text('Delete item'),
///     content: const Text('This action cannot be undone.'),
///     confirmText: 'Delete',
///     destructive: true,
///     onConfirm: deleteItem,
///   ),
/// );
/// ```
///
/// See also:
///
///  * [VAlertDialog], for a dialog that must be answered
///  * [VAlert], for inline alert messages
/// {@endtemplate}
class VDialog extends StatelessWidget {
  /// Dialog with a single confirm button.
  const VDialog.alert({
    required this.content,
    super.key,
    this.title,
    this.confirmText,
    this.onConfirm,
    this.barrierDismissible = true,
    this.barrierColor,
    this.actionsAlignment = VDialogActionsAlignment.end,
    this.actionsExpanded = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VDialogVariant.alert,
       cancelText = null,
       onCancel = null,
       destructive = false,
       actions = null;

  /// Dialog with cancel and confirm buttons.
  const VDialog.confirm({
    required this.content,
    super.key,
    this.title,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.destructive = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.actionsAlignment = VDialogActionsAlignment.end,
    this.actionsExpanded = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VDialogVariant.confirm,
       actions = null;

  /// Custom dialog.
  const VDialog.custom({
    required this.content,
    super.key,
    this.title,
    this.actions,
    this.barrierDismissible = true,
    this.barrierColor,
    this.actionsAlignment = VDialogActionsAlignment.end,
    this.actionsExpanded = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VDialogVariant.custom,
       cancelText = null,
       confirmText = null,
       onCancel = null,
       onConfirm = null,
       destructive = false;

  final _VDialogVariant _variant;

  /// Style override.
  final VDialogStyle? style;

  /// Heading shown above [content], in the large title style.
  final Widget? title;

  /// Main body of the dialog.
  final Widget content;

  /// Label of the cancel button; defaults to the localized "Cancel".
  final String? cancelText;

  /// Label of the confirm button; defaults to the localized "Confirm".
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

  /// Whether a barrier tap or Escape closes the dialog.
  final bool barrierDismissible;

  /// Barrier color; defaults to the theme's scrim color.
  final Color? barrierColor;

  /// Buttons shown by [VDialog.custom], in order.
  final List<Widget>? actions;

  /// Horizontal alignment of the action row.
  final VDialogActionsAlignment actionsAlignment;

  /// Whether each action stretches to share the row width equally.
  final bool actionsExpanded;

  /// Screen reader name of the dialog route; defaults to "Dialog".
  final String? semanticLabel;

  // WHY: showGeneralDialog instead of showDialog — showDialog requires
  // MaterialLocalizations and pulls in Material's default transitions.
  // showGeneralDialog is framework-level, letting us define custom barrier
  // color, transition, and keyboard handling without Material dependency.
  /// Shows [dialog] above the current route and returns its result.
  static Future<T?> show<T>(BuildContext context, VDialog dialog) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: dialog.barrierDismissible,
      barrierLabel: localizations.dialogDismissLabel,
      barrierColor:
          dialog.barrierColor ?? themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.fast ?? VAnimations.defaults.fast,
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget child;
        if (themeData != null) {
          child = VTheme(
            data: themeData,
            localizations: localizations,
            child: dialog,
          );
        } else {
          child = dialog;
        }

        // WHY: Listen for Escape at the dialog level, as a native dialog
        // would. The listener owns its focus node, so route rebuilds do not
        // leak one each.
        return _EscapeToDismiss(
          enabled: dialog.barrierDismissible,
          onEscape: () => Navigator.of(context).pop(),
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
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
    final themeStyle = theme.componentOverrides.get<VDialogStyle>();
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

    final titleStyle = (resolvedStyle?.titleStyle ?? typography.titleLarge)
        .copyWith(color: titleTextColor, decoration: TextDecoration.none);
    final contentStyle = typography.bodyMedium.copyWith(
      color: descTextColor,
      decoration: TextDecoration.none,
    );

    final titleLabel =
        semanticLabel ?? VoloLocalizations.of(context).dialogLabel;

    // WHY: FocusTraversalGroup scopes Tab navigation within the dialog,
    // preventing focus from escaping to background content. Combined with
    // Semantics(scopesRoute: true) this creates a proper modal a11y trap.
    return FocusTraversalGroup(
      child: Semantics(
        namesRoute: true,
        scopesRoute: true,
        explicitChildNodes: true,
        label: titleLabel,
        child: DefaultTextStyle(
          style: contentStyle,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 512),
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xxl),
                child: Container(
                  padding: contentPadding,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: borderRadius,
                    boxShadow: resolvedStyle?.shadows ?? theme.shadows.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      if (title != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: theme.spacing.lg),
                          child: DefaultTextStyle.merge(
                            style: titleStyle,
                            child: title!,
                          ),
                        ),
                      // Content (WCAG 4.1.3: liveRegion for dialog content)
                      Semantics(liveRegion: true, child: content),
                      // Actions
                      Padding(
                        padding: EdgeInsets.only(top: theme.spacing.xxl),
                        child: _buildActions(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  MainAxisAlignment get _mainAxisAlignment {
    switch (actionsAlignment) {
      case VDialogActionsAlignment.start:
        return MainAxisAlignment.start;
      case VDialogActionsAlignment.center:
        return MainAxisAlignment.center;
      case VDialogActionsAlignment.end:
        return MainAxisAlignment.end;
    }
  }

  Widget _wrapButton(Widget button) {
    if (actionsExpanded) {
      return Expanded(child: button);
    }
    return button;
  }

  Widget _buildActions(BuildContext context) {
    final l10n = VoloLocalizations.of(context);
    switch (_variant) {
      case _VDialogVariant.alert:
        return Row(
          mainAxisAlignment: _mainAxisAlignment,
          children: [
            _wrapButton(
              VButton(
                onPressed: () {
                  VDialog.close<void>(context);
                  onConfirm?.call();
                },
                child: Text(confirmText ?? l10n.dialogConfirm),
              ),
            ),
          ],
        );
      case _VDialogVariant.confirm:
        return Row(
          mainAxisAlignment: _mainAxisAlignment,
          children: [
            _wrapButton(
              VButton.outlined(
                onPressed: () {
                  VDialog.close<void>(context);
                  onCancel?.call();
                },
                child: Text(cancelText ?? l10n.dialogCancel),
              ),
            ),
            SizedBox(width: VTheme.of(context).spacing.sm),
            _wrapButton(
              VButton(
                color: destructive
                    ? VButtonColor.destructive
                    : VButtonColor.primary,
                onPressed: () {
                  VDialog.close<void>(context);
                  onConfirm?.call();
                },
                child: Text(confirmText ?? l10n.dialogConfirm),
              ),
            ),
          ],
        );
      case _VDialogVariant.custom:
        if (actions == null || actions!.isEmpty) {
          return const SizedBox.shrink();
        }
        final wrappedActions = <Widget>[];
        for (var i = 0; i < actions!.length; i++) {
          if (i > 0) {
            wrappedActions.add(SizedBox(width: VTheme.of(context).spacing.sm));
          }
          wrappedActions.add(_wrapButton(actions![i]));
        }
        return Row(
          mainAxisAlignment: _mainAxisAlignment,
          children: wrappedActions,
        );
    }
  }
}

enum _VDialogVariant { alert, confirm, custom }

// Calls [onEscape] when Escape is pressed while the dialog has focus.
class _EscapeToDismiss extends StatefulWidget {
  const _EscapeToDismiss({
    required this.enabled,
    required this.onEscape,
    required this.child,
  });

  final bool enabled;
  final VoidCallback onEscape;
  final Widget child;

  @override
  State<_EscapeToDismiss> createState() => _EscapeToDismissState();
}

class _EscapeToDismissState extends State<_EscapeToDismiss> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'VDialog escape');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    focusNode: _focusNode,
    autofocus: true,
    onKeyEvent: (event) {
      if (widget.enabled &&
          event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onEscape();
      }
    },
    child: widget.child,
  );
}
