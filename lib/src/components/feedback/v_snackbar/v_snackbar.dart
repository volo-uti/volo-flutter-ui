import 'dart:async';
import 'dart:collection';
import 'dart:ui' show FlutterView;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_snackbar_style.dart';

/// Text button shown at the end of a [VSnackbar], such as "Undo".
class VSnackbarAction {
  /// Creates an action that calls [onPressed] when [label] is tapped.
  const VSnackbarAction({
    required this.label,
    required this.onPressed,
    this.textColor,
  });

  /// Text of the action.
  final String label;

  /// Called when the action is tapped; the snackbar hides right after.
  final VoidCallback onPressed;

  /// Color of [label]; the snackbar's text color when null.
  final Color? textColor;
}

/// {@template v_snackbar}
/// Temporary message bar anchored to the bottom of the screen.
///
/// Shown with [show]; snackbars shown while another is visible wait in a queue
/// and appear one after another. Call [clear] before [show] to replace the
/// visible one instead. It hides itself after [duration].
///
/// ```dart
/// VSnackbar.show(
///   context,
///   VSnackbar(
///     content: const Text('Item deleted.'),
///     semanticLabel: 'Item deleted.',
///     action: VSnackbarAction(label: 'Undo', onPressed: undoDelete),
///   ),
/// );
/// ```
///
/// Types: [VSnackbar] (neutral), [VSnackbar.success], [VSnackbar.error],
/// [VSnackbar.warning] and [VSnackbar.info]. [showSuccess] and [showError]
/// show a plain message in one call.
///
/// See also:
///
///  * [VToast], a centered message that replaces the previous one
///  * [VAlert], an inline message
/// {@endtemplate}
class VSnackbar extends StatelessWidget {
  /// Default snackbar.
  const VSnackbar({
    required this.content,
    super.key,
    this.action,
    this.duration,
    this.behavior = VSnackbarBehavior.fixed,
    this.width,
    this.padding,
    this.margin,
    this.shape,
    this.backgroundColor,
    this.dismissDirection,
    this.onVisible,
    this.semanticLabel,
    this.style,
  }) : _variant = _VSnackbarVariant.defaultSnackbar;

  /// Success snackbar.
  const VSnackbar.success({
    required this.content,
    super.key,
    this.action,
    this.duration,
    this.behavior = VSnackbarBehavior.fixed,
    this.width,
    this.padding,
    this.margin,
    this.shape,
    this.backgroundColor,
    this.dismissDirection,
    this.onVisible,
    this.semanticLabel,
    this.style,
  }) : _variant = _VSnackbarVariant.success;

  /// Error snackbar.
  const VSnackbar.error({
    required this.content,
    super.key,
    this.action,
    this.duration,
    this.behavior = VSnackbarBehavior.fixed,
    this.width,
    this.padding,
    this.margin,
    this.shape,
    this.backgroundColor,
    this.dismissDirection,
    this.onVisible,
    this.semanticLabel,
    this.style,
  }) : _variant = _VSnackbarVariant.error;

  /// Warning snackbar.
  const VSnackbar.warning({
    required this.content,
    super.key,
    this.action,
    this.duration,
    this.behavior = VSnackbarBehavior.fixed,
    this.width,
    this.padding,
    this.margin,
    this.shape,
    this.backgroundColor,
    this.dismissDirection,
    this.onVisible,
    this.semanticLabel,
    this.style,
  }) : _variant = _VSnackbarVariant.warning;

  /// Info snackbar.
  const VSnackbar.info({
    required this.content,
    super.key,
    this.action,
    this.duration,
    this.behavior = VSnackbarBehavior.fixed,
    this.width,
    this.padding,
    this.margin,
    this.shape,
    this.backgroundColor,
    this.dismissDirection,
    this.onVisible,
    this.semanticLabel,
    this.style,
  }) : _variant = _VSnackbarVariant.info;

  final _VSnackbarVariant _variant;

  /// Style override.
  final VSnackbarStyle? style;

  /// Message shown in the bar, usually a [Text].
  final Widget content;

  /// Text button shown after [content].
  final VSnackbarAction? action;

  /// How long the snackbar stays; defaults to [VAnimations.snackbar].
  ///
  /// [Duration.zero] keeps it until [hide] or [clear] is called.
  final Duration? duration;

  /// Whether the bar is fixed to the bottom edge or floats above content.
  final VSnackbarBehavior behavior;

  /// Width of the bar when [behavior] is floating.
  final double? width;

  /// Padding inside the bar; defaults to the theme's large spacing.
  final EdgeInsets? padding;

  /// Margin around the bar when [behavior] is floating.
  final EdgeInsets? margin;

  /// Border shape; defaults to a rounded rectangle when floating.
  final ShapeBorder? shape;

  /// Fill color; defaults to the color of the snackbar type.
  final Color? backgroundColor;

  /// Swipe direction that hides the snackbar; swiping is off when null.
  final DismissDirection? dismissDirection;

  /// Called right after the snackbar is inserted into the overlay.
  final VoidCallback? onVisible;

  /// Text announced by screen readers when the snackbar appears.
  final String? semanticLabel;

  // WHY: Queue system (FIFO) — unlike VToast's replace-last pattern,
  // snackbars carry actionable content (e.g. "Undo") that must not be
  // lost. The queue ensures every snackbar is seen in order.
  // PERF: Static fields avoid per-instance allocation. Only one overlay
  // entry exists at any time; the queue holds pending VSnackbar widgets.
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;
  static final Queue<VSnackbar> _queue = Queue();
  static OverlayState? _overlayState;
  static VThemeData? _cachedTheme;
  static VoloLocalizations _cachedLocalizations = const VoloLocalizationsEn();
  static FlutterView? _cachedView;
  static TextDirection _cachedTextDirection = TextDirection.ltr;

  // WHY: The statics outlive any Overlay. When the Overlay that holds the
  // visible snackbar is disposed (route popped, app root swapped), nothing
  // would ever clear `_currentEntry`, and every later `show` would only queue.
  static bool get _overlayIsAlive => _overlayState?.mounted ?? false;

  // Forgets a visible snackbar whose Overlay is gone, with its queue.
  static void _dropStaleState() {
    if (_currentEntry == null || _overlayIsAlive) return;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry = null;
    _queue.clear();
    _overlayState = null;
    _cachedTheme = null;
    _cachedView = null;
  }

  /// Shows [snackbar], or queues it while another one is visible.
  ///
  /// To replace the visible snackbar instead of waiting for it, call [clear]
  /// first; it hides the visible one and drops the queue.
  ///
  /// ```dart
  /// VSnackbar.clear(context);
  /// VSnackbar.show(context, VSnackbar(content: const Text('Saved')));
  /// ```
  static void show(BuildContext context, VSnackbar snackbar) {
    _dropStaleState();
    if (_currentEntry != null) {
      _queue.add(snackbar);
      return;
    }

    _overlayState = Overlay.of(context);
    _cachedTheme = VTheme.maybeOf(context);
    _cachedLocalizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    _cachedView = View.of(context);
    _cachedTextDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    _showSnackbar(snackbar);
  }

  static void _showSnackbar(VSnackbar snackbar) {
    if (_overlayState == null) return;
    if (!_overlayIsAlive) {
      // The Overlay was disposed while this snackbar waited in the queue.
      _queue.clear();
      _overlayState = null;
      _cachedTheme = null;
      _cachedView = null;
      return;
    }

    _currentEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        snackbar: snackbar,
        themeData: _cachedTheme,
        localizations: _cachedLocalizations,
      ),
    );

    _overlayState!.insert(_currentEntry!);
    snackbar.onVisible?.call();

    // Announce to screen readers independent of overlay timing. Without a
    // semanticLabel the visible message is a live region instead.
    final announceText = snackbar.semanticLabel ?? '';
    if (announceText.isNotEmpty && _cachedView != null) {
      unawaited(
        SemanticsService.sendAnnouncement(
          _cachedView!,
          announceText,
          _cachedTextDirection,
        ),
      );
    }

    final effectiveDuration =
        snackbar.duration ??
        _cachedTheme?.animations.snackbar ??
        VAnimations.defaults.snackbar;
    if (effectiveDuration != Duration.zero) {
      _dismissTimer = Timer(effectiveDuration, _hide);
    }
  }

  /// Shows a success snackbar with the plain text [message].
  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      VSnackbar.success(content: Text(message), semanticLabel: message),
    );
  }

  /// Shows an error snackbar with the plain text [message].
  static void showError(BuildContext context, String message) {
    show(
      context,
      VSnackbar.error(content: Text(message), semanticLabel: message),
    );
  }

  /// Hides the visible snackbar and shows the next queued one.
  static void hide(BuildContext context) {
    _hide();
  }

  // WHY: Dismiss-then-dequeue pattern — the current snackbar must be fully
  // removed before the next one is inserted, otherwise two overlays coexist
  // causing z-order flicker. Cached refs are nulled only when the queue
  // is empty to prevent memory leaks from holding stale BuildContext refs.
  static void _hide() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    final entry = _currentEntry;
    _currentEntry = null;
    // A disposed Overlay already dropped its entries; removing again asserts.
    if (entry != null && _overlayIsAlive) entry.remove();

    // Show next in queue
    if (_queue.isNotEmpty) {
      final next = _queue.removeFirst();
      _showSnackbar(next);
    } else {
      // Clear cached references to prevent memory leaks
      _overlayState = null;
      _cachedTheme = null;
      _cachedView = null;
    }
  }

  /// Drops all queued snackbars and hides the visible one.
  static void clear(BuildContext context) {
    _queue.clear();
    _hide();
  }

  Widget? _getIcon(BuildContext context, VColors colors) {
    final iconSize = VTheme.of(context).sizes.md.iconSize;

    switch (_variant) {
      case _VSnackbarVariant.defaultSnackbar:
        return null;
      case _VSnackbarVariant.success:
        return VIcons.checkCircle(size: iconSize, color: colors.success);
      case _VSnackbarVariant.error:
        return VIcons.error(size: iconSize, color: colors.error);
      case _VSnackbarVariant.warning:
        return VIcons.warning(size: iconSize, color: colors.warning);
      case _VSnackbarVariant.info:
        return VIcons.info(size: iconSize, color: colors.info);
    }
  }

  Color _getBackgroundColor(VColors colors) {
    if (backgroundColor != null) return backgroundColor!;

    switch (_variant) {
      case _VSnackbarVariant.defaultSnackbar:
        return colors.foreground;
      case _VSnackbarVariant.success:
        return colors.success;
      case _VSnackbarVariant.error:
        return colors.error;
      case _VSnackbarVariant.warning:
        return colors.warning;
      case _VSnackbarVariant.info:
        return colors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VSnackbarStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    final isFloating = behavior == VSnackbarBehavior.floating;
    var bgColor = _getBackgroundColor(colors);
    var textColor = colors.background;
    var effectiveBorderRadius = isFloating
        ? theme.radius.mdRadius
        : BorderRadius.zero;
    var effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.lg,
        );
    Color? effectiveActionColor;

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      textColor = resolvedStyle.foregroundColor ?? textColor;
      effectiveBorderRadius =
          resolvedStyle.borderRadius ?? effectiveBorderRadius;
      effectivePadding = resolvedStyle.padding ?? effectivePadding;
      effectiveActionColor = resolvedStyle.actionColor;
    }

    final contentStyle = (resolvedStyle?.textStyle ?? typography.bodyMedium)
        .copyWith(color: textColor);
    final icon = _getIcon(context, colors);

    // WHY: The label replaces the message text for assistive technology (the
    // action stays a separate button). A live region speaks the message when
    // no label is given; with a label the announcement in `show` speaks it.
    final hasLabel = semanticLabel != null && semanticLabel!.isNotEmpty;
    Widget snackbarContent = DecoratedBox(
      decoration: ShapeDecoration(
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        color: bgColor,
        shadows: theme.shadows.md,
      ),
      child: Container(
        width: isFloating ? width : double.infinity,
        constraints: const BoxConstraints(minHeight: 48),
        padding: effectivePadding,
        margin: isFloating
            ? (margin ?? EdgeInsets.all(theme.spacing.sm))
            : null,
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsetsDirectional.only(end: theme.spacing.md),
                child: icon,
              ),
            Expanded(
              child: Semantics(
                liveRegion: !hasLabel,
                label: hasLabel ? semanticLabel : null,
                excludeSemantics: hasLabel,
                child: DefaultTextStyle.merge(
                  style: contentStyle,
                  child: content,
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
                    _hide();
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
                        color:
                            effectiveActionColor ??
                            action!.textColor ??
                            textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (dismissDirection != null) {
      snackbarContent = Dismissible(
        key: UniqueKey(),
        direction: dismissDirection!,
        onDismissed: (_) => _hide(),
        child: snackbarContent,
      );
    }

    return snackbarContent;
  }
}

enum _VSnackbarVariant { defaultSnackbar, success, error, warning, info }

/// Snackbar display behavior.
///
/// Controls whether the snackbar is anchored to the bottom ([fixed])
/// or floats above content ([floating]).
enum VSnackbarBehavior {
  /// Fixed to the bottom of the screen.
  fixed,

  /// Floats above content with margin.
  floating,
}

class _SnackbarOverlay extends StatefulWidget {
  const _SnackbarOverlay({
    required this.snackbar,
    required this.localizations,
    this.themeData,
  });

  final VSnackbar snackbar;
  final VThemeData? themeData;
  final VoloLocalizations localizations;

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
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
    final isFloating = widget.snackbar.behavior == VSnackbarBehavior.floating;
    final theme =
        widget.themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();

    Widget snackbar = widget.snackbar;
    if (widget.themeData != null) {
      snackbar = VTheme(
        data: widget.themeData!,
        localizations: widget.localizations,
        child: snackbar,
      );
    }
    snackbar = DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
        color: theme.colors.background,
      ),
      child: snackbar,
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: isFloating ? MediaQuery.of(context).padding.bottom : 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: isFloating ? Center(child: snackbar) : snackbar,
        ),
      ),
    );
  }
}
