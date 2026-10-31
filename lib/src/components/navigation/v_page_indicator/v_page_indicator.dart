import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_page_indicator_style.dart';

/// Look of a [VPageIndicator]: dots, a number or lines.
enum VPageIndicatorStyle {
  /// Dot style (● ○ ○ ○).
  dots,

  /// Number style (2 / 5).
  number,

  /// Line style (━━━ ─── ───).
  line,
}

/// {@template v_page_indicator}
/// Dots, number or lines that show the current position in a short page set.
///
/// Use it for carousels, onboarding flows and galleries. Unlike
/// [VPagination], it is mostly visual; [onPageChanged] makes it tappable.
///
/// ## Basic Usage:
///
/// ```dart
/// VPageIndicator.dots(
///   total: 5,
///   current: 2,
/// )
/// ```
///
/// ## Variants:
///
/// - [VPageIndicator.dots] - Dot style indicator (● ○ ○)
/// - [VPageIndicator.number] - Number style indicator (2 / 5)
/// - [VPageIndicator.line] - Line style indicator (━━━ ─── ───)
///
/// ## Customized Dots:
///
/// ```dart
/// VPageIndicator.dots(
///   total: 5,
///   current: 2,
///   size: 10,
///   activeSize: 14,
///   spacing: 8,
///   activeColor: Color(0xFF2563EB),
///   inactiveColor: Color(0xFF9CA3AF),
///   borderColor: Color(0xFF2563EB),
///   borderWidth: 1,
/// )
/// ```
///
/// ## Number Style:
///
/// ```dart
/// VPageIndicator.number(
///   total: 5,
///   current: 2,
///   separator: VPageIndicatorSeparator.of,  // "2 of 5"
/// )
/// ```
///
/// ## Line Style (Instagram Stories):
///
/// ```dart
/// VPageIndicator.line(
///   total: 5,
///   current: 2,
///   lineHeight: 3,
///   lineSpacing: 4,
/// )
/// ```
///
/// ## With Tap Interaction:
///
/// ```dart
/// VPageIndicator.dots(
///   total: 5,
///   current: _currentPage,
///   onPageChanged: (index) => _controller.jumpToPage(index),
/// )
/// ```
///
/// See also:
///
/// - [VCarousel], carousel component
/// - [VPagination], list/table page navigation
/// {@endtemplate}
class VPageIndicator extends StatelessWidget {
  /// {@macro v_page_indicator}
  ///
  /// Dot style indicator.
  const VPageIndicator.dots({
    required this.total,
    required this.current,
    super.key,
    this.onPageChanged,
    this.size = 8,
    this.activeSize,
    this.spacing = 6,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.activeBorderColor,
    this.borderWidth = 0,
    this.activeBorderWidth,
    this.expandActive = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.style,
  }) : _style = VPageIndicatorStyle.dots,
       separator = VPageIndicatorSeparator.slash,
       textStyle = null,
       activeTextStyle = null,
       lineHeight = 3,
       lineSpacing = 4;

  /// {@macro v_page_indicator}
  ///
  /// Number style indicator.
  const VPageIndicator.number({
    required this.total,
    required this.current,
    super.key,
    this.onPageChanged,
    this.separator = VPageIndicatorSeparator.slash,
    this.textStyle,
    this.activeTextStyle,
    this.animationDuration = const Duration(milliseconds: 200),
    this.style,
  }) : _style = VPageIndicatorStyle.number,
       size = 8,
       activeSize = null,
       spacing = 6,
       activeColor = null,
       inactiveColor = null,
       borderColor = null,
       activeBorderColor = null,
       borderWidth = 0,
       activeBorderWidth = null,
       expandActive = false,
       lineHeight = 3,
       lineSpacing = 4;

  /// {@macro v_page_indicator}
  ///
  /// Line style indicator (Instagram Stories style).
  const VPageIndicator.line({
    required this.total,
    required this.current,
    super.key,
    this.onPageChanged,
    this.lineHeight = 3,
    this.lineSpacing = 4,
    this.activeColor,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.style,
  }) : _style = VPageIndicatorStyle.line,
       size = 8,
       activeSize = null,
       spacing = 6,
       borderColor = null,
       activeBorderColor = null,
       borderWidth = 0,
       activeBorderWidth = null,
       expandActive = false,
       separator = VPageIndicatorSeparator.slash,
       textStyle = null,
       activeTextStyle = null;

  final VPageIndicatorStyle _style;

  /// Number of pages.
  final int total;

  /// Current page index (zero-based).
  final int current;

  /// Called with the zero-based page the user taps; the widget is not
  /// interactive when null.
  final ValueChanged<int>? onPageChanged;

  /// Duration of the active-page transition.
  final Duration animationDuration;

  // === Dots style properties ===

  /// Diameter of an inactive dot.
  final double size;

  /// Diameter of the active dot; [size] when null.
  final double? activeSize;

  /// Gap between dots.
  final double spacing;

  /// Fill color of the active dot or lines up to the current page.
  final Color? activeColor;

  /// Fill color of inactive dots and the lines after the current page.
  final Color? inactiveColor;

  /// Border color of an inactive dot; its fill color when null.
  final Color? borderColor;

  /// Border color of the active dot; its fill color when null.
  final Color? activeBorderColor;

  /// Border width of an inactive dot; 0 draws none.
  final double borderWidth;

  /// Border width of the active dot; [borderWidth] when null.
  final double? activeBorderWidth;

  /// Whether the active dot stretches into a pill.
  final bool expandActive;

  // === Number style properties ===

  /// Text drawn between the current page and the total.
  final VPageIndicatorSeparator separator;

  /// Text style of the separator and the total; muted body text when null.
  final TextStyle? textStyle;

  /// Text style of the current page number; semibold body text when null.
  final TextStyle? activeTextStyle;

  // === Line style properties ===

  /// Thickness of each line.
  final double lineHeight;

  /// Gap between lines.
  final double lineSpacing;

  /// Overrides the theme's [VPageIndicatorThemeStyle] for this indicator.
  final VPageIndicatorThemeStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Semantics(
      label: VoloLocalizations.of(context).pageOf(current + 1, total),
      value: '${current + 1}',
      child: switch (_style) {
        VPageIndicatorStyle.dots => _buildDots(theme),
        VPageIndicatorStyle.number => _buildNumber(theme),
        VPageIndicatorStyle.line => _buildLine(theme),
      },
    );
  }

  /// Uses the theme token when the value matches the constructor default;
  /// returns the explicitly specified value otherwise.
  static const Duration _defaultAnimationDuration = Duration(milliseconds: 200);

  /// Returns the effective animation duration, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveDuration(VThemeData theme) {
    if (animationDuration == _defaultAnimationDuration) {
      return theme.animations.fast;
    }
    return animationDuration;
  }

  Widget _buildDots(VThemeData theme) {
    // Resolve style from theme
    final dotThemeStyle = theme.componentOverrides
        .get<VPageIndicatorThemeStyle>();
    final dotResolvedStyle = dotThemeStyle?.merge(style) ?? style;
    final effectiveActiveColor =
        dotResolvedStyle?.activeColor ?? activeColor ?? theme.colors.primary;
    final effectiveInactiveColor =
        dotResolvedStyle?.inactiveColor ??
        inactiveColor ??
        theme.colors.mutedForeground.withValues(alpha: 0.3);
    final effectiveActiveSize =
        dotResolvedStyle?.activeSize ?? activeSize ?? size;
    final effectiveInactiveSize = dotResolvedStyle?.inactiveSize ?? size;
    final effectiveActiveBorderWidth = activeBorderWidth ?? borderWidth;
    final duration = _effectiveDuration(theme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        final dotSize = isActive ? effectiveActiveSize : effectiveInactiveSize;
        final dotWidth = isActive && expandActive ? dotSize * 1.5 : dotSize;
        final currentBorderWidth = isActive
            ? effectiveActiveBorderWidth
            : borderWidth;
        final currentBorderColor = isActive
            ? (activeBorderColor ?? effectiveActiveColor)
            : (borderColor ?? effectiveInactiveColor);

        Widget dot = AnimatedContainer(
          duration: duration,
          curve: theme.animations.curveSmooth,
          width: dotWidth,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: isActive ? effectiveActiveColor : effectiveInactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
            border: currentBorderWidth > 0
                ? Border.all(
                    color: currentBorderColor,
                    width: currentBorderWidth,
                  )
                : null,
          ),
        );

        if (onPageChanged != null) {
          dot = GestureDetector(
            onTap: () => onPageChanged!(index),
            behavior: HitTestBehavior.opaque,
            // Min 24x24px touch target (WCAG 2.2 SC 2.5.8)
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              child: Center(child: dot),
            ),
          );
        }

        return dot;
      }),
    );
  }

  Widget _buildNumber(VThemeData theme) {
    final defaultStyle = theme.typography.bodyMedium.copyWith(
      color: theme.colors.mutedForeground,
    );
    final defaultActiveStyle = theme.typography.bodyMedium.copyWith(
      color: theme.colors.foreground,
      fontWeight: FontWeight.w600,
    );

    final effectiveStyle = textStyle ?? defaultStyle;
    final effectiveActiveStyle = activeTextStyle ?? defaultActiveStyle;

    final separatorText = switch (separator) {
      VPageIndicatorSeparator.slash => ' / ',
      VPageIndicatorSeparator.of => ' of ',
      VPageIndicatorSeparator.dash => ' - ',
      VPageIndicatorSeparator.pipe => ' | ',
    };

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${current + 1}', style: effectiveActiveStyle),
        Text(separatorText, style: effectiveStyle),
        Text('$total', style: effectiveStyle),
      ],
    );

    if (onPageChanged != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: current > 0 ? () => onPageChanged!(current - 1) : null,
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.sm),
              child: VIcons.chevronLeft(
                size: 18,
                color: current > 0
                    ? theme.colors.foreground
                    : theme.colors.mutedForeground.withValues(alpha: 0.5),
              ),
            ),
          ),
          content,
          GestureDetector(
            onTap: current < total - 1
                ? () => onPageChanged!(current + 1)
                : null,
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.sm),
              child: VIcons.chevronRight(
                size: 18,
                color: current < total - 1
                    ? theme.colors.foreground
                    : theme.colors.mutedForeground.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }

  Widget _buildLine(VThemeData theme) {
    final lineThemeStyle = theme.componentOverrides
        .get<VPageIndicatorThemeStyle>();
    final lineResolvedStyle = lineThemeStyle?.merge(style) ?? style;
    final effectiveActiveColor =
        lineResolvedStyle?.activeColor ?? activeColor ?? theme.colors.primary;
    final effectiveInactiveColor =
        lineResolvedStyle?.inactiveColor ??
        inactiveColor ??
        theme.colors.mutedForeground.withValues(alpha: 0.3);
    final duration = _effectiveDuration(theme);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final totalSpacing = lineSpacing * (total - 1);
        final lineWidth = (availableWidth - totalSpacing) / total;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(total, (index) {
            final isActive = index <= current;

            Widget line = AnimatedContainer(
              duration: duration,
              curve: theme.animations.curveSmooth,
              width: lineWidth,
              height: lineHeight,
              margin: EdgeInsets.only(
                right: index < total - 1 ? lineSpacing : 0,
              ),
              decoration: BoxDecoration(
                color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                borderRadius: BorderRadius.circular(lineHeight / 2),
              ),
            );

            if (onPageChanged != null) {
              line = GestureDetector(
                onTap: () => onPageChanged!(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
                  child: line,
                ),
              );
            }

            return Expanded(child: line);
          }),
        );
      },
    );
  }
}

/// Number style separator.
enum VPageIndicatorSeparator {
  /// Slash (2 / 5).
  slash,

  /// of (2 of 5).
  of,

  /// Dash (2 - 5).
  dash,

  /// Pipe (2 | 5).
  pipe,
}
