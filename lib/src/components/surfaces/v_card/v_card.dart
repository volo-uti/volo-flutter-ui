import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_card_style.dart';

/// {@template v_card}
/// Raised or outlined container that groups related content, optionally tappable.
///
/// ```dart
/// VCard(
///   onTap: () => debugPrint('opened'),
///   child: Column(
///     children: [
///       VCardHeader(
///         title: Text('Title'),
///         description: Text('A description for this card.'),
///       ),
///       Text('Card body content.'),
///       VCardFooter(
///         children: [
///           VButton.outlined(onPressed: () {}, child: Text('Cancel')),
///           VButton(onPressed: () {}, child: Text('Confirm')),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
///
/// **Variants:**
///
/// - [VCard] - Default. Elevated with shadow (floating effect)
/// - [VCard.outlined] - Outlined. Border only (flat style)
/// - [VCard.elevated] - Same as default. Floating effect with shadow
///
/// **Tappable Card:**
///
/// ```dart
/// VCard(
///   onTap: () => print('Card tapped'),
///   child: VCardHeader(
///     title: Text('Tappable Card'),
///     description: Text('Tap to perform an action.'),
///   ),
/// )
/// ```
///
/// **Elevated Card:**
///
/// ```dart
/// VCard.elevated(
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('A card with shadow.'),
///   ),
/// )
/// ```
///
/// See also:
///
/// - [VCardHeader], the title area at the top of the card
/// - [VCardFooter], the button area at the bottom of the card
/// - [VSheet], an overlay that slides from the screen edge
/// {@endtemplate}
class VCard extends StatefulWidget {
  /// {@macro v_card}
  ///
  /// Creates a default card with shadow for a floating effect.
  const VCard({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.style,
  }) : _variant = _VCardVariant.elevated;

  /// Outlined card.
  ///
  /// A flat-style card with border only.
  /// The transparent background gives a lightweight appearance.
  const VCard.outlined({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.style,
  }) : _variant = _VCardVariant.outlined;

  /// Elevated card.
  ///
  /// A card with shadow for a floating effect.
  /// The shadow grows larger on hover.
  const VCard.elevated({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.style,
  }) : _variant = _VCardVariant.elevated;

  final _VCardVariant _variant;

  /// Content shown inside the card.
  final Widget child;

  /// Inner padding. Defaults to the theme's large spacing on every side.
  final EdgeInsets? padding;

  /// Corner radius. Defaults to the theme's large radius.
  final BorderRadius? borderRadius;

  /// Called when the card is tapped; setting it makes the card pressable.
  final VoidCallback? onTap;

  /// Called when the card is long-pressed; setting it makes the card pressable.
  final VoidCallback? onLongPress;

  /// Style override.
  final VCardStyle? style;

  @override
  State<VCard> createState() => _VCardState();
}

enum _VCardVariant { outlined, elevated }

class _VCardState extends State<VCard> {
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isTappable => widget.onTap != null || widget.onLongPress != null;

  @override
  void didUpdateWidget(VCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isTappable) {
      // A card that is no longer pressable keeps no hover, press or focus state.
      _isPressed = false;
      _isHovered = false;
      _isFocused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VCardStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final radius =
        resolvedStyle?.borderRadius ??
        widget.borderRadius ??
        theme.radius.lgRadius;
    final padding =
        resolvedStyle?.padding ??
        widget.padding ??
        EdgeInsets.all(theme.spacing.lg);

    Color bgColor;
    Border? border;
    List<BoxShadow>? shadows;

    switch (widget._variant) {
      case _VCardVariant.outlined:
        bgColor = _isPressed
            ? colors.muted.withValues(alpha: 0.3)
            : VColors.transparent;
        border = Border.all(color: colors.border);
        break;
      case _VCardVariant.elevated:
        bgColor = _isPressed ? colors.muted : colors.card;
        shadows =
            resolvedStyle?.shadows ??
            (_isHovered ? theme.shadows.lg : theme.shadows.md);
        break;
    }

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      if (resolvedStyle.borderColor != null) {
        border = Border.all(color: resolvedStyle.borderColor!);
      }
    }

    Widget card = AnimatedContainer(
      duration: theme.animations.fast,
      curve: theme.animations.curveEaseOut,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: border,
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    if (_isTappable) {
      // Focus ring (WCAG 2.4.7)
      if (_isFocused) {
        card = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: colors.ring, width: 2),
          ),
          child: card,
        );
      }

      card = Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        onKeyEvent: (node, event) {
          // Enter and Space press a focused card like a tap. Keys that reach it
          // from a focused child are left to that child.
          if (node.hasPrimaryFocus &&
              event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onTap?.call();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: card,
          ),
        ),
      );
    }

    return FocusTraversalGroup(
      child: Semantics(
        button: _isTappable,
        container: !_isTappable,
        child: card,
      ),
    );
  }
}

/// {@template v_card_header}
/// Title area at the top of a [VCard], with an optional description and action.
///
/// ```dart
/// VCardHeader(
///   title: Text('Settings'),
///   description: Text('Manage app settings.'),
///   action: VIconButton(
///     icon: Icon(Icons.more_vert),
///     onPressed: () {},
///   ),
/// )
/// ```
///
/// See also:
///
/// - [VCard], a container that groups related content
/// - [VCardFooter], the button area at the bottom of the card
/// {@endtemplate}
class VCardHeader extends StatelessWidget {
  /// {@macro v_card_header}
  const VCardHeader({
    required this.title,
    super.key,
    this.description,
    this.action,
  });

  /// Heading of the card, usually a [Text].
  final Widget title;

  /// Smaller line shown below [title].
  final Widget? description;

  /// Widget at the end of the header, typically an icon button or menu.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final titleWidget = DefaultTextStyle.merge(
      style: typography.titleMedium.copyWith(color: colors.foreground),
      child: title,
    );

    final descriptionWidget = description == null
        ? null
        : DefaultTextStyle.merge(
            style: typography.bodyMedium.copyWith(
              color: colors.mutedForeground,
            ),
            child: description!,
          );

    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                if (descriptionWidget != null)
                  Padding(
                    padding: EdgeInsets.only(top: theme.spacing.xs),
                    child: descriptionWidget,
                  ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// {@template v_card_footer}
/// Row of buttons at the bottom of a [VCard], spaced evenly and right-aligned.
///
/// ```dart
/// VCardFooter(
///   children: [
///     VButton.outlined(onPressed: () {}, child: Text('Cancel')),
///     VButton(onPressed: () {}, child: Text('Confirm')),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VCard], a container that groups related content
/// - [VCardHeader], the title area at the top of the card
/// {@endtemplate}
class VCardFooter extends StatelessWidget {
  /// {@macro v_card_footer}
  const VCardFooter({
    required this.children,
    super.key,
    this.alignment = MainAxisAlignment.end,
  });

  /// Buttons shown in the footer, separated by a small gap.
  final List<Widget> children;

  /// Horizontal alignment of [children]. Defaults to the end edge.
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: theme.spacing.lg),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: theme.spacing.sm),
            children[i],
          ],
        ],
      ),
    );
  }
}
