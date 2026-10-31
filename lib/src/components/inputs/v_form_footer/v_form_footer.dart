import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_form_footer_style.dart';

/// Message row below a form control: helper, error or success text plus a counter.
///
/// [VFormField] builds one for you; use it directly only to annotate a custom control.
///
/// **Basic Usage:**
///
/// ```dart
/// VFormFooter(
///   helper: 'Enter your email',
///   child: VFormBody(...),
/// )
/// ```
///
/// **With Counter:**
///
/// ```dart
/// VFormFooter(
///   maxLength: 100,
///   currentLength: text.length,
///   child: VFormBody(...),
/// )
/// ```
///
/// See also:
/// - [VFormField] - Header + Body + Footer composition
class VFormFooter extends StatefulWidget {
  /// Creates a form footer.
  const VFormFooter({
    required this.child,
    super.key,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.counter,
    this.maxLength,
    this.currentLength = 0,
    this.style,
  });

  /// The control the footer belongs to.
  final Widget child;

  /// Helper text shown when no error or success message is active.
  final String? helper;

  /// Whether to show [errorText] in the destructive color.
  final bool error;

  /// Error message, shown when [error] is true.
  final String? errorText;

  /// Whether to show [successText] in the success color.
  final bool success;

  /// Success message, shown when [success] is true.
  final String? successText;

  /// Note that stays visible below the message.
  final String? extra;

  /// Replaces the generated `current/max` counter.
  final Widget? counter;

  /// Character limit; when set, a `current/max` counter is generated.
  final int? maxLength;

  /// Characters entered so far, used by the generated counter.
  final int currentLength;

  /// Style override.
  final VFormFooterStyle? style;

  @override
  State<VFormFooter> createState() => _VFormFooterState();
}

class _VFormFooterState extends State<VFormFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveEaseOut,
      ),
    );
  }

  @override
  void didUpdateWidget(VFormFooter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate on message change
    if (_getActiveMessage(oldWidget) != _getActiveMessage(widget)) {
      unawaited(_controller.forward(from: 0));
    }
  }

  String? _getActiveMessage(VFormFooter w) {
    if (w.error && w.errorText != null) return w.errorText;
    if (w.success && w.successText != null) return w.successText;
    return w.helper;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFormFooterStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    // Apply resolvedStyle overrides
    final footerPadding = resolvedStyle?.padding;

    // Message priority: error > success > helper
    String? activeMessage;
    Color messageColor;

    if (widget.error && widget.errorText != null) {
      activeMessage = widget.errorText;
      messageColor = colors.destructive;
    } else if (widget.success && widget.successText != null) {
      activeMessage = widget.successText;
      messageColor = colors.success;
    } else if (widget.helper != null) {
      activeMessage = widget.helper;
      messageColor = colors.mutedForeground;
    } else {
      activeMessage = null;
      messageColor = colors.mutedForeground;
    }

    final messageStyle = typography.labelSmall.copyWith(color: messageColor);

    final extraStyle = typography.labelSmall.copyWith(
      color: colors.mutedForeground,
    );

    // Counter widget
    var counterWidget = widget.counter;
    if (counterWidget == null && widget.maxLength != null) {
      final isOverLimit = widget.currentLength > widget.maxLength!;
      final counterStyle = typography.labelSmall.copyWith(
        color: isOverLimit ? colors.destructive : colors.mutedForeground,
      );
      counterWidget = Text(
        '${widget.currentLength}/${widget.maxLength}',
        style: counterStyle,
      );
    }

    final hasFooter =
        activeMessage != null || counterWidget != null || widget.extra != null;

    // WHY: The child keeps the same place in the tree whether or not a footer
    // shows. Swapping a bare child for a Column would rebuild the control and
    // close its text input connection while the user types.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.child,
        if (!hasFooter)
          const SizedBox.shrink()
        else
          Padding(
            padding: footerPadding ?? EdgeInsets.only(top: theme.spacing.xs),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (activeMessage != null)
                        Expanded(
                          child: Semantics(
                            liveRegion: true,
                            child: Text(activeMessage, style: messageStyle),
                          ),
                        )
                      else
                        const Spacer(),
                      ?counterWidget,
                    ],
                  ),
                  if (widget.extra != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: resolvedStyle?.spacing ?? theme.spacing.xxs,
                      ),
                      child: Text(widget.extra!, style: extraStyle),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
