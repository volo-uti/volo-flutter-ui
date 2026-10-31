import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_alert_style.dart';

/// Alert appearance variant.
///
/// Controls the visual style of [VAlert]:
/// - [standard] - Light background with colored border (default)
/// - [filled] - Solid colored background with white text
/// - [outlined] - Transparent background with colored border only
enum VAlertVariant {
  /// Filled style: solid colored background with white text.
  filled,

  /// Outlined style: transparent background with colored border.
  outlined,

  /// Standard style: light tinted background (default).
  standard,
}

/// {@template v_alert}
/// Inline box that shows an info, success, warning or error message.
///
/// Stays in the layout where it is placed; use [VSnackbar] or [VToast] for
/// messages that appear on top of the screen.
///
/// ```dart
/// VAlert.success(
///   title: Text('Saved'),
///   description: Text('Your changes have been saved.'),
///   onClose: () => setState(() => showAlert = false),
/// )
/// ```
///
/// Types: [VAlert] (neutral), [VAlert.info], [VAlert.success],
/// [VAlert.warning] and [VAlert.error]; [variant] changes the fill.
///
/// See also:
///
///  * [VToast], for temporary feedback messages
///  * [VSnackbar], for bottom screen notifications
/// {@endtemplate}
class VAlert extends StatelessWidget {
  /// Neutral alert.
  const VAlert({
    required this.description,
    super.key,
    this.title,
    this.icon,
    this.action,
    this.onClose,
    this.semanticLabel,
    this.variant = VAlertVariant.standard,
    this.style,
  }) : _variant = _VAlertVariant.defaultAlert;

  /// Info alert.
  const VAlert.info({
    required this.description,
    super.key,
    this.title,
    this.icon,
    this.action,
    this.onClose,
    this.semanticLabel,
    this.variant = VAlertVariant.standard,
    this.style,
  }) : _variant = _VAlertVariant.info;

  /// Success alert.
  const VAlert.success({
    required this.description,
    super.key,
    this.title,
    this.icon,
    this.action,
    this.onClose,
    this.semanticLabel,
    this.variant = VAlertVariant.standard,
    this.style,
  }) : _variant = _VAlertVariant.success;

  /// Warning alert.
  const VAlert.warning({
    required this.description,
    super.key,
    this.title,
    this.icon,
    this.action,
    this.onClose,
    this.semanticLabel,
    this.variant = VAlertVariant.standard,
    this.style,
  }) : _variant = _VAlertVariant.warning;

  /// Error alert.
  const VAlert.error({
    required this.description,
    super.key,
    this.title,
    this.icon,
    this.action,
    this.onClose,
    this.semanticLabel,
    this.variant = VAlertVariant.standard,
    this.style,
  }) : _variant = _VAlertVariant.destructive;

  final _VAlertVariant _variant;

  /// Style override.
  final VAlertStyle? style;

  /// Heading shown above [description], in the semibold title style.
  final Widget? title;

  /// Message body, in the muted body style.
  final Widget description;

  /// Replaces the icon that matches the alert type.
  final Widget? icon;

  /// Widget shown below [description], usually a button.
  final Widget? action;

  /// Called when the close button is tapped; the button is hidden when null.
  ///
  /// The alert does not remove itself, so the caller must stop building it.
  final VoidCallback? onClose;

  /// Screen reader label for the whole alert; announced as the alert text.
  final String? semanticLabel;

  /// Appearance variant.
  ///
  /// Controls the visual style:
  /// - [VAlertVariant.standard] - Light tinted background (default)
  /// - [VAlertVariant.filled] - Solid colored background with white text
  /// - [VAlertVariant.outlined] - Transparent background with colored border
  final VAlertVariant variant;

  Widget _getDefaultIcon(
    VColors colors,
    double iconSize, [
    Color? overrideColor,
  ]) {
    final isFilled =
        variant == VAlertVariant.filled &&
        _variant != _VAlertVariant.defaultAlert;

    switch (_variant) {
      case _VAlertVariant.defaultAlert:
      case _VAlertVariant.info:
        final iconColor =
            overrideColor ??
            (isFilled
                ? colors.background
                : (_variant == _VAlertVariant.info
                      ? colors.info
                      : colors.mutedForeground));
        return VIcons.info(color: iconColor, size: iconSize);
      case _VAlertVariant.success:
        final iconColor =
            overrideColor ?? (isFilled ? colors.background : colors.success);
        return VIcons.checkCircle(color: iconColor, size: iconSize);
      case _VAlertVariant.warning:
        final iconColor =
            overrideColor ?? (isFilled ? colors.background : colors.warning);
        return VIcons.warning(color: iconColor, size: iconSize);
      case _VAlertVariant.destructive:
        final iconColor =
            overrideColor ??
            (isFilled ? colors.background : colors.destructive);
        return VIcons.error(color: iconColor, size: iconSize);
    }
  }

  /// Returns the accent color for the current alert type.
  Color _getAccentColor(VColors colors) {
    switch (_variant) {
      case _VAlertVariant.defaultAlert:
        return colors.mutedForeground;
      case _VAlertVariant.info:
        return colors.info;
      case _VAlertVariant.success:
        return colors.success;
      case _VAlertVariant.warning:
        return colors.warning;
      case _VAlertVariant.destructive:
        return colors.destructive;
    }
  }

  Color _getBackgroundColor(VColors colors) {
    final accent = _getAccentColor(colors);
    switch (variant) {
      case VAlertVariant.filled:
        return _variant == _VAlertVariant.defaultAlert ? colors.muted : accent;
      case VAlertVariant.outlined:
        return VColors.transparent;
      case VAlertVariant.standard:
        switch (_variant) {
          case _VAlertVariant.defaultAlert:
            return colors.muted;
          case _VAlertVariant.info:
          case _VAlertVariant.success:
          case _VAlertVariant.warning:
            return accent.withValues(alpha: 0.1);
          case _VAlertVariant.destructive:
            return accent.withValues(alpha: 0.1);
        }
    }
  }

  Color _getBorderColor(VColors colors) {
    final accent = _getAccentColor(colors);
    switch (variant) {
      case VAlertVariant.filled:
        return _variant == _VAlertVariant.defaultAlert ? colors.border : accent;
      case VAlertVariant.outlined:
        return _variant == _VAlertVariant.defaultAlert ? colors.border : accent;
      case VAlertVariant.standard:
        switch (_variant) {
          case _VAlertVariant.defaultAlert:
            return colors.border;
          case _VAlertVariant.info:
          case _VAlertVariant.success:
          case _VAlertVariant.warning:
            return accent.withValues(alpha: 0.3);
          case _VAlertVariant.destructive:
            return accent.withValues(alpha: 0.3);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VAlertStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    final isFilled =
        variant == VAlertVariant.filled &&
        _variant != _VAlertVariant.defaultAlert;
    final titleColor = isFilled ? colors.background : colors.foreground;
    final descColor = isFilled
        ? colors.background.withValues(alpha: 0.9)
        : colors.mutedForeground;

    var effectiveBgColor = _getBackgroundColor(colors);
    var effectiveBorderColor = _getBorderColor(colors);
    var effectiveBorderRadius = theme.radius.mdRadius;
    var effectivePadding = EdgeInsets.all(theme.spacing.lg);
    final effectiveTitleColor = resolvedStyle?.foregroundColor ?? titleColor;
    final effectiveIconColor = resolvedStyle?.iconColor;

    if (resolvedStyle != null) {
      effectiveBgColor = resolvedStyle.backgroundColor ?? effectiveBgColor;
      effectiveBorderColor = resolvedStyle.borderColor ?? effectiveBorderColor;
      effectiveBorderRadius =
          resolvedStyle.borderRadius ?? effectiveBorderRadius;
      effectivePadding = resolvedStyle.padding ?? effectivePadding;
    }

    final effectiveTitleStyle =
        (resolvedStyle?.titleStyle ?? typography.bodyMedium).copyWith(
          fontWeight: FontWeight.w600,
          color: effectiveTitleColor,
        );
    final descriptionStyle = typography.bodySmall.copyWith(color: descColor);

    return Semantics(
      container: true,
      label: semanticLabel,
      child: Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: effectiveBgColor,
          border: Border.all(color: effectiveBorderColor),
          borderRadius: effectiveBorderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: theme.spacing.md,
                top: theme.spacing.xxs,
              ),
              child:
                  icon ??
                  _getDefaultIcon(
                    colors,
                    theme.sizes.lg.iconSize,
                    effectiveIconColor,
                  ),
            ),
            // Content (WCAG 4.1.3: liveRegion for dynamic alert content)
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: theme.spacing.xs),
                        child: DefaultTextStyle.merge(
                          style: effectiveTitleStyle,
                          child: title!,
                        ),
                      ),
                    DefaultTextStyle.merge(
                      style: descriptionStyle,
                      child: description,
                    ),
                    if (action != null)
                      Padding(
                        padding: EdgeInsets.only(top: theme.spacing.md),
                        child: action,
                      ),
                  ],
                ),
              ),
            ),
            // Close button
            if (onClose != null)
              Focus(
                onKeyEvent: (node, event) {
                  // Enter and Space close the alert from the keyboard.
                  if (event is KeyDownEvent &&
                      (event.logicalKey == LogicalKeyboardKey.enter ||
                          event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                          event.logicalKey == LogicalKeyboardKey.space)) {
                    onClose!();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: Semantics(
                  button: true,
                  label: VoloLocalizations.of(context).alertCloseLabel,
                  onTap: onClose,
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: theme.spacing.sm,
                      ),
                      child: VIcons.close(
                        color: isFilled
                            ? colors.background.withValues(alpha: 0.8)
                            : colors.mutedForeground,
                        size: theme.sizes.md.iconSize,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _VAlertVariant { defaultAlert, info, success, warning, destructive }
