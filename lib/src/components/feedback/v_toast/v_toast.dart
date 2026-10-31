import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_toast_style.dart';

/// Toast position.
///
/// Specifies the display position of [VToast]:
/// - [top] - Top of the screen
/// - [bottom] - Bottom of the screen (default)
enum VToastPosition {
  /// Top of the screen.
  top,

  /// Bottom of the screen (default).
  bottom,
}

/// Text button shown at the end of a [VToast], such as "Undo".
class VToastAction {
  /// Creates an action that calls [onPressed] when [label] is tapped.
  const VToastAction({required this.label, required this.onPressed});

  /// Text of the action.
  final String label;

  /// Called when the action is tapped.
  final VoidCallback onPressed;
}

/// {@template v_toast}
/// Short message that floats at the top or bottom center of the screen.
///
/// Shown with [show]; a new toast replaces the visible one. It hides itself
/// after [duration] and can be swiped away while [dismissible] is true.
///
/// ```dart
/// VToast.show(
///   context,
///   VToast.success(
///     message: const Text('Upload complete'),
///     semanticLabel: 'Upload complete',
///     position: VToastPosition.top,
///   ),
/// );
/// ```
///
/// Types: [VToast] (neutral), [VToast.success], [VToast.error],
/// [VToast.warning] and [VToast.info]. [showSuccess], [showError],
/// [showWarning] and [showInfo] show a plain message in one call.
///
/// See also:
///
///  * [VSnackbar], a full-width bar with a queue
///  * [VAlert], an inline message
/// {@endtemplate}
class VToast extends StatelessWidget {
  /// Default toast.
  const VToast({
    required this.message,
    super.key,
    this.position = VToastPosition.bottom,
    this.duration,
    this.action,
    this.dismissible = true,
    this.semanticLabel,
    this.style,
  }) : _variant = _VToastVariant.defaultToast;

  /// Success toast.
  const VToast.success({
    required this.message,
    super.key,
    this.position = VToastPosition.bottom,
    this.duration,
    this.action,
    this.dismissible = true,
    this.semanticLabel,
    this.style,
  }) : _variant = _VToastVariant.success;

  /// Error toast.
  const VToast.error({
    required this.message,
    super.key,
    this.position = VToastPosition.bottom,
    this.duration,
    this.action,
    this.dismissible = true,
    this.semanticLabel,
    this.style,
  }) : _variant = _VToastVariant.error;

  /// Warning toast.
  const VToast.warning({
    required this.message,
    super.key,
    this.position = VToastPosition.bottom,
    this.duration,
    this.action,
    this.dismissible = true,
    this.semanticLabel,
    this.style,
  }) : _variant = _VToastVariant.warning;

  /// Info toast.
  const VToast.info({
    required this.message,
    super.key,
    this.position = VToastPosition.bottom,
    this.duration,
    this.action,
    this.dismissible = true,
    this.semanticLabel,
    this.style,
  }) : _variant = _VToastVariant.info;

  final _VToastVariant _variant;

  /// Style override.
  final VToastStyle? style;

  /// Message shown in the toast, usually a [Text].
  final Widget message;

  /// Whether the toast sits at the top or the bottom of the screen.
  final VToastPosition position;

  /// How long the toast stays; defaults to [VAnimations.toast].
  ///
  /// [Duration.zero] keeps it until [dismiss] is called.
  final Duration? duration;

  /// Text button shown after [message].
  final VToastAction? action;

  /// Whether the toast can be swiped away.
  final bool dismissible;

  /// Text announced by screen readers for the toast.
  final String? semanticLabel;

  // WHY: Static singleton pattern (one overlay at a time) — dismiss-before-show
  // prevents toast stacking which causes visual clutter. Unlike VSnackbar's
  // queue system, toasts are lightweight ephemeral feedback that should
  // replace, not queue.
  static OverlayEntry? _currentEntry;
  static OverlayState? _currentOverlay;
  static Timer? _dismissTimer;

  // WHY: dismiss(context) called first — ensures only one toast is visible.
  // The previous toast is immediately removed without exit animation to
  // prioritize showing the latest feedback quickly.
  /// Shows [toast], replacing the toast that is visible.
  static void show(BuildContext context, VToast toast) {
    dismiss(context);

    final overlay = Overlay.of(context);
    // WHY: Capture theme before inserting overlay — the overlay's BuildContext
    // may not have a VTheme ancestor (it sits above the app's widget tree).
    // Passing themeData explicitly ensures token access inside the overlay.
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();

    _currentEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        toast: toast,
        themeData: themeData,
        localizations: localizations,
      ),
    );

    _currentOverlay = overlay;
    overlay.insert(_currentEntry!);

    final effectiveDuration =
        toast.duration ??
        themeData?.animations.toast ??
        VAnimations.defaults.toast;
    if (effectiveDuration != Duration.zero) {
      _dismissTimer = Timer(effectiveDuration, () {
        dismiss(context);
      });
    }
  }

  /// Shows a success toast with the plain text [message].
  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      VToast.success(message: Text(message), semanticLabel: message),
    );
  }

  /// Shows an error toast with the plain text [message].
  static void showError(BuildContext context, String message) {
    show(context, VToast.error(message: Text(message), semanticLabel: message));
  }

  /// Shows a warning toast with the plain text [message].
  static void showWarning(BuildContext context, String message) {
    show(
      context,
      VToast.warning(message: Text(message), semanticLabel: message),
    );
  }

  /// Shows an info toast with the plain text [message].
  static void showInfo(BuildContext context, String message) {
    show(context, VToast.info(message: Text(message), semanticLabel: message));
  }

  /// Hides the visible toast.
  static void dismiss(BuildContext context) {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    final entry = _currentEntry;
    final overlay = _currentOverlay;
    _currentEntry = null;
    _currentOverlay = null;
    // WHY: An Overlay that was disposed (route popped, app root swapped)
    // already dropped its entries; removing the entry again asserts.
    if (entry != null && (overlay?.mounted ?? false)) entry.remove();
  }

  /// Variant-specific color (shared by left border and icon).
  Color _getVariantColor(VColors colors) => switch (_variant) {
    _VToastVariant.defaultToast => colors.info,
    _VToastVariant.success => colors.success,
    _VToastVariant.error => colors.error,
    _VToastVariant.warning => colors.warning,
    _VToastVariant.info => colors.info,
  };

  Widget? _getIcon(BuildContext context, VColors colors) {
    final iconSize = VTheme.of(context).sizes.md.iconSize;
    final iconColor = _getVariantColor(colors);

    switch (_variant) {
      case _VToastVariant.defaultToast:
        return null;
      case _VToastVariant.success:
        return VIcons.checkCircle(size: iconSize, color: iconColor);
      case _VToastVariant.error:
        return VIcons.error(size: iconSize, color: iconColor);
      case _VToastVariant.warning:
        return VIcons.warning(size: iconSize, color: iconColor);
      case _VToastVariant.info:
        return VIcons.info(size: iconSize, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VToastStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    var bgColor = colors.card;
    var textColor = colors.cardForeground;
    var borderRadius = theme.radius.mdRadius;
    var toastPadding = EdgeInsets.symmetric(
      horizontal: theme.spacing.lg,
      vertical: theme.spacing.md,
    );

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      textColor = resolvedStyle.foregroundColor ?? textColor;
      borderRadius = resolvedStyle.borderRadius ?? borderRadius;
      toastPadding = resolvedStyle.padding ?? toastPadding;
    }

    final messageStyle = (resolvedStyle?.textStyle ?? typography.bodyMedium)
        .copyWith(color: textColor);

    final icon = _getIcon(context, colors);
    // WHY: A label replaces the message text for assistive technology.
    // Merging it with the visible text would read the message twice.
    final hasLabel = semanticLabel != null && semanticLabel!.isNotEmpty;

    // Left color border marks the variant
    final leftBorder = _variant != _VToastVariant.defaultToast
        ? BorderDirectional(
            start: BorderSide(color: _getVariantColor(colors), width: 4),
          )
        : null;

    return Container(
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
      padding: toastPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: leftBorder,
        boxShadow: theme.shadows.lg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsetsDirectional.only(end: theme.spacing.md),
              child: icon,
            ),
          Flexible(
            child: Semantics(
              liveRegion: true,
              label: hasLabel ? semanticLabel : null,
              excludeSemantics: hasLabel,
              child: DefaultTextStyle.merge(
                style: messageStyle,
                child: message,
              ),
            ),
          ),
          if (action != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: theme.spacing.md),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  action!.onPressed();
                  // The action answers the message; dismiss it so it cannot
                  // fire twice (for example "Undo").
                  dismiss(context);
                },
                // Min 24x24px touch target (WCAG 2.2 SC 2.5.8)
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.sm,
                    vertical: theme.spacing.xs,
                  ),
                  child: Text(
                    action!.label,
                    style: typography.labelMedium.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _VToastVariant { defaultToast, success, error, warning, info }

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.toast,
    required this.localizations,
    this.themeData,
  });

  final VToast toast;
  final VThemeData? themeData;
  final VoloLocalizations localizations;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    final isTop = widget.toast.position == VToastPosition.top;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme =
        widget.themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();
    _controller.duration = theme.animations.normal;
    if (_controller.value == 0) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTop = widget.toast.position == VToastPosition.top;
    final theme =
        widget.themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();

    Widget toast = widget.toast;
    if (widget.themeData != null) {
      toast = VTheme(
        data: widget.themeData!,
        localizations: widget.localizations,
        child: toast,
      );
    }
    toast = DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
        color: theme.colors.cardForeground,
      ),
      child: toast,
    );

    return Positioned(
      top: isTop ? theme.spacing.lg + MediaQuery.of(context).padding.top : null,
      bottom: isTop
          ? null
          : theme.spacing.lg + MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.toast.dismissible
                ? Dismissible(
                    key: UniqueKey(),
                    onDismissed: (_) => VToast.dismiss(context),
                    child: toast,
                  )
                : toast,
          ),
        ),
      ),
    );
  }
}
