import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_list_tile_style.dart';

/// Tile with leading, title, subtitle and trailing slots for list rows.
///
/// Comes in default (56), [VListTile.dense] (48) and [VListTile.threeLine]
/// (88) heights. Taps and long presses are reported through [onTap] and
/// [onLongPress]; the tile is inert while [enabled] is false.
///
/// ```dart
/// VListTile(
///   leading: const Icon(Icons.person),
///   title: const Text('Profile'),
///   subtitle: const Text('Manage account information'),
///   trailing: const Icon(Icons.chevron_right),
///   selected: page == Page.profile,
///   onTap: () => navigateToProfile(),
/// )
/// ```
class VListTile extends StatefulWidget {
  /// Creates a 56px tile (72px with a subtitle).
  const VListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.style,
  }) : _variant = _VListTileVariant.normal;

  /// Creates a compact 48px tile.
  const VListTile.dense({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.style,
  }) : _variant = _VListTileVariant.dense;

  /// Creates an 88px tile whose title and subtitle wrap to two lines.
  const VListTile.threeLine({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.style,
  }) : _variant = _VListTileVariant.threeLine;

  final _VListTileVariant _variant;

  /// Primary content, typically a [Text]; styled with the tile's title style.
  final Widget title;

  /// Secondary content below [title], typically a [Text].
  final Widget? subtitle;

  /// Widget before the text, such as an icon or avatar.
  final Widget? leading;

  /// Widget after the text, such as a chevron or a switch.
  final Widget? trailing;

  /// Called when the tile is tapped; the tile does not react to taps when null.
  final VoidCallback? onTap;

  /// Called when the tile is long pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is drawn as the current selection.
  final bool selected;

  /// Whether the tile reacts to input; false dims it and ignores taps.
  final bool enabled;

  /// Padding around the content; defaults to the horizontal large spacing.
  final EdgeInsets? contentPadding;

  /// Background color when not selected, hovered or pressed.
  final Color? tileColor;

  /// Background color while [selected].
  final Color? selectedTileColor;

  /// Per-instance style override merged over the theme's [VListTileStyle].
  final VListTileStyle? style;

  @override
  State<VListTile> createState() => _VListTileState();
}

enum _VListTileVariant { normal, dense, threeLine }

class _VListTileState extends State<VListTile> {
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  double get _minHeight {
    final theme = VTheme.of(context);
    final sizes = theme.sizes;
    switch (widget._variant) {
      case _VListTileVariant.dense:
        return sizes.lg.height; // 48
      case _VListTileVariant.normal:
        // 72 = 48 + 24(xxl)
        return widget.subtitle != null
            ? sizes.lg.height + theme.spacing.xxl
            : sizes.xl.height; // 56
      case _VListTileVariant.threeLine:
        // 88 = 56 + 32(xxxl)
        return sizes.xl.height + theme.spacing.xxxl;
    }
  }

  CrossAxisAlignment get _leadingAlignment =>
      widget._variant == _VListTileVariant.threeLine
      ? CrossAxisAlignment.start
      : CrossAxisAlignment.center;

  int get _maxLines => widget._variant == _VListTileVariant.threeLine ? 2 : 1;

  @override
  void didUpdateWidget(VListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) {
      // A disabled control keeps no hover, press or focus state for later.
      _isPressed = false;
      _isHovered = false;
      _isFocused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VListTileStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final typography = theme.typography;

    final fgColor = resolvedStyle?.foregroundColor ?? colors.foreground;

    Color bgColor;
    if (!widget.enabled) {
      bgColor =
          resolvedStyle?.backgroundColor ??
          widget.tileColor ??
          VColors.transparent;
    } else if (_isPressed) {
      bgColor = colors.accent;
    } else if (_isHovered) {
      bgColor = colors.accent;
    } else if (widget.selected) {
      bgColor =
          resolvedStyle?.selectedColor ??
          widget.selectedTileColor ??
          colors.muted;
    } else {
      bgColor =
          resolvedStyle?.backgroundColor ??
          widget.tileColor ??
          VColors.transparent;
    }

    final titleStyle =
        resolvedStyle?.titleStyle ??
        typography.bodyLarge.copyWith(color: fgColor);

    final subtitleStyle =
        resolvedStyle?.subtitleStyle ??
        typography.bodyMedium.copyWith(color: colors.mutedForeground);

    final Widget content = Row(
      crossAxisAlignment: _leadingAlignment,
      children: [
        if (widget.leading != null)
          Padding(
            padding: EdgeInsets.only(right: theme.spacing.lg),
            child: SizedBox(
              width: theme.sizes.md.height,
              height: theme.sizes.md.height,
              child: Center(child: widget.leading),
            ),
          ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tileText(widget.title, titleStyle, maxLines: _maxLines),
              if (widget.subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: theme.spacing.xxs),
                  child: _tileText(
                    widget.subtitle!,
                    subtitleStyle,
                    maxLines: _maxLines,
                  ),
                ),
            ],
          ),
        ),
        if (widget.trailing != null)
          Padding(
            padding: EdgeInsets.only(left: theme.spacing.lg),
            child: widget.trailing,
          ),
      ],
    );

    // Focus ring (WCAG 2.4.7)
    Widget tile = DecoratedBox(
      decoration: _isFocused && widget.enabled
          ? BoxDecoration(border: Border.all(color: colors.ring, width: 2))
          : const BoxDecoration(),
      child: AnimatedContainer(
        duration: theme.animations.normal,
        curve: Curves.easeOut,
        constraints: BoxConstraints(minHeight: _minHeight),
        padding:
            resolvedStyle?.padding ??
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: theme.spacing.lg),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: resolvedStyle?.borderRadius,
        ),
        child: Opacity(opacity: widget.enabled ? 1.0 : 0.5, child: content),
      ),
    );

    if (widget.enabled &&
        (widget.onTap != null || widget.onLongPress != null)) {
      tile = Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        onKeyEvent: (node, event) {
          // Enter and Space press a focused tile like a tap. Keys that reach it
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
            child: tile,
          ),
        ),
      );
    }

    return Semantics(
      button: widget.onTap != null || widget.onLongPress != null,
      // Only a selected tile announces a state; a plain one is not "unselected".
      selected: widget.selected ? true : null,
      enabled: widget.enabled,
      child: tile,
    );
  }
}

Widget _tileText(Widget child, TextStyle style, {int maxLines = 1}) =>
    DefaultTextStyle.merge(
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
