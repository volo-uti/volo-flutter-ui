import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_badge_style.dart';

/// Height presets for a [VBadge].
enum VBadgeSize {
  /// Small size (18px).
  sm,

  /// Medium size (22px).
  md,

  /// Large size (26px).
  lg,
}

/// Small pill that shows a status or a short count.
///
/// Each named constructor picks a color variant: [VBadge.primary],
/// [VBadge.secondary], [VBadge.success], [VBadge.warning],
/// [VBadge.destructive] and [VBadge.outline]. The default is muted.
/// [VBadge.count] shows a number and caps it at `max`, as in `99+`.
///
/// ```dart
/// Row(
///   spacing: 8,
///   children: [
///     VBadge.success(label: Text('Active')),
///     VBadge.count(
///       count: 120, // Shows '99+'.
///       size: VBadgeSize.sm,
///       semanticLabel: 'Many unread messages',
///     ),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VBadgeSize], the badge sizes.
class VBadge extends StatefulWidget {
  /// Muted badge on a neutral background.
  const VBadge({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.muted;

  /// Badge in the primary color.
  const VBadge.primary({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.primary;

  /// Badge in the secondary color.
  const VBadge.secondary({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.secondary;

  /// Badge in the success color.
  const VBadge.success({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.success;

  /// Badge in the warning color.
  const VBadge.warning({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.warning;

  /// Badge in the destructive color.
  const VBadge.destructive({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.destructive;

  /// Transparent badge with a border.
  const VBadge.outline({
    required this.label,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : _variant = _VBadgeVariant.outline;

  /// Destructive badge showing [count], or `'$max+'` when it exceeds [max].
  ///
  /// A negative [count] shows as 0 and a [max] below 1 counts as 1.
  VBadge.count({
    required int count,
    int max = 99,
    super.key,
    this.size = VBadgeSize.md,
    this.invisible = false,
    this.semanticLabel,
    this.style,
  }) : label = Text(_countText(count, max)),
       _variant = _VBadgeVariant.destructive;

  final _VBadgeVariant _variant;

  static String _countText(int count, int max) {
    final cap = max < 1 ? 1 : max;
    final shown = count < 0 ? 0 : count;
    return shown > cap ? '$cap+' : '$shown';
  }

  /// Content shown inside the badge, usually a short [Text].
  ///
  /// The foreground color, font size and weight come from the badge and its
  /// [VBadgeStyle.textStyle], so a plain [Text] needs no style.
  final Widget label;

  /// Screen reader label that replaces the text of [label].
  final String? semanticLabel;

  /// Height preset of the badge.
  final VBadgeSize size;

  /// Whether the badge is hidden and takes no space.
  final bool invisible;

  /// Per-instance style override merged over the theme style.
  final VBadgeStyle? style;

  @override
  State<VBadge> createState() => _VBadgeState();
}

enum _VBadgeVariant {
  muted,
  primary,
  secondary,
  success,
  warning,
  destructive,
  outline,
}

class _VBadgeState extends State<VBadge> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this);
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1, end: 1.1), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 1), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _scaleController.duration = theme.animations.fast;
  }

  @override
  void didUpdateWidget(VBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_changed(widget.label, oldWidget.label)) {
      unawaited(_scaleController.forward(from: 0));
    }
  }

  // WHY: A rebuilt `Text('5')` is a new object each time; compare the text so
  // only a real change pulses the badge.
  bool _changed(Widget now, Widget before) {
    if (now is Text && before is Text) return now.data != before.data;
    return now != before;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  VComponentSize get _sizeToken {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VBadgeSize.sm => theme.sizes.sm,
      VBadgeSize.md => theme.sizes.md,
      VBadgeSize.lg => theme.sizes.lg,
    };
  }

  EdgeInsets get _padding {
    final theme = VTheme.of(context);
    final sizeToken = _sizeToken;
    return EdgeInsets.symmetric(
      horizontal: sizeToken.spacing,
      vertical: switch (widget.size) {
        VBadgeSize.sm => theme.spacing.xxs,
        VBadgeSize.md => theme.spacing.xxs,
        VBadgeSize.lg => theme.spacing.xs,
      },
    );
  }

  double get _fontSize {
    final sizes = VTheme.of(context).sizes;
    return switch (widget.size) {
      VBadgeSize.sm => sizes.xs.fontSize,
      VBadgeSize.md => sizes.sm.fontSize,
      VBadgeSize.lg => sizes.md.fontSize,
    };
  }

  double get _borderRadius => _sizeToken.height / 2;

  @override
  Widget build(BuildContext context) {
    if (widget.invisible) {
      return const SizedBox.shrink();
    }

    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VBadgeStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    Color bgColor;
    Color fgColor;
    Border? border;

    switch (widget._variant) {
      case _VBadgeVariant.muted:
        bgColor = colors.muted;
        fgColor = colors.mutedForeground;
        break;
      case _VBadgeVariant.primary:
        bgColor = colors.primary;
        fgColor = colors.primaryForeground;
        break;
      case _VBadgeVariant.secondary:
        bgColor = colors.secondary;
        fgColor = colors.secondaryForeground;
        break;
      case _VBadgeVariant.success:
        bgColor = colors.success;
        fgColor = colors.successForeground;
        break;
      case _VBadgeVariant.warning:
        bgColor = colors.warning;
        fgColor = colors.warningForeground;
        break;
      case _VBadgeVariant.destructive:
        bgColor = colors.destructive;
        fgColor = colors.destructiveForeground;
        break;
      case _VBadgeVariant.outline:
        bgColor = VColors.transparent;
        fgColor = colors.foreground;
        border = Border.all(color: colors.border);
        break;
    }

    bgColor = resolvedStyle?.backgroundColor ?? bgColor;

    // The size preset sets the base; the style's textStyle lays over it, and
    // foregroundColor wins over the textStyle color.
    final textStyle = TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.w500,
      color: fgColor,
      height: 1.15,
    ).merge(resolvedStyle?.textStyle);
    final content = DefaultTextStyle.merge(
      style: textStyle.copyWith(color: resolvedStyle?.foregroundColor),
      child: widget.label,
    );

    return Semantics(
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: _padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                resolvedStyle?.borderRadius ??
                BorderRadius.circular(_borderRadius),
            border: border,
          ),
          child: Center(widthFactor: 1, heightFactor: 1, child: content),
        ),
      ),
    );
  }
}
