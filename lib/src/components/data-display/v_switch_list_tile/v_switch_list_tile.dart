import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_switch/v_switch.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_switch_list_tile_style.dart';

/// Tile with a switch that toggles when the whole row is tapped.
///
/// The switch sits at the end by default, at the start with
/// [VSwitchListTile.leading], and inside a bordered card with
/// [VSwitchListTile.card].
///
/// ```dart
/// VSwitchListTile(
///   title: const Text('Location Services'),
///   subtitle: const Text('Allow the app to use location data'),
///   secondary: const Icon(Icons.location_on),
///   value: locationEnabled,
///   onChanged: (v) => setState(() => locationEnabled = v),
/// )
/// ```
class VSwitchListTile extends StatefulWidget {
  /// Creates a tile with the switch at the end.
  const VSwitchListTile({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.onChanged,
    this.secondary,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.activeColor,
    this.style,
  }) : _variant = _VSwitchListTileVariant.trailing;

  /// Creates a tile with the switch at the start.
  const VSwitchListTile.leading({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.onChanged,
    this.secondary,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.activeColor,
    this.style,
  }) : _variant = _VSwitchListTileVariant.leading;

  /// Creates a bordered card tile with the switch at the end.
  const VSwitchListTile.card({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.onChanged,
    this.secondary,
    this.selected = false,
    this.enabled = true,
    this.contentPadding,
    this.activeColor,
    this.style,
  }) : _variant = _VSwitchListTileVariant.card;

  final _VSwitchListTileVariant _variant;

  /// Primary content, typically a [Text]; styled with the tile's title style.
  final Widget title;

  /// Secondary content below [title], typically a [Text].
  final Widget? subtitle;

  /// Whether the switch is on.
  final bool value;

  /// Called with the next value when the tile is tapped; null disables it.
  final ValueChanged<bool>? onChanged;

  /// Widget on the side opposite the switch, such as an icon.
  final Widget? secondary;

  /// Whether the tile is drawn as the current selection.
  final bool selected;

  /// Whether the tile reacts to input; false dims it and ignores taps.
  final bool enabled;

  /// Padding around the content.
  final EdgeInsets? contentPadding;

  /// Track color while on; overridden by [VSwitchListTileStyle.activeColor].
  final Color? activeColor;

  /// Per-instance style override merged over the theme's [VSwitchListTileStyle].
  final VSwitchListTileStyle? style;

  @override
  State<VSwitchListTile> createState() => _VSwitchListTileState();
}

enum _VSwitchListTileVariant { trailing, leading, card }

class _VSwitchListTileState extends State<VSwitchListTile> {
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  void _handleTap() {
    if (!widget.enabled || widget.onChanged == null) return;
    widget.onChanged?.call(!widget.value);
  }

  @override
  void didUpdateWidget(VSwitchListTile oldWidget) {
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
    final themeStyle = theme.componentOverrides.get<VSwitchListTileStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final typography = theme.typography;

    final fgColor = resolvedStyle?.foregroundColor ?? colors.foreground;

    Color bgColor;
    if (!widget.enabled) {
      bgColor = resolvedStyle?.backgroundColor ?? VColors.transparent;
    } else if (_isPressed) {
      bgColor = colors.accent;
    } else if (_isHovered) {
      bgColor = colors.accent;
    } else if (widget.selected) {
      bgColor = colors.muted;
    } else if (widget._variant == _VSwitchListTileVariant.card) {
      bgColor = resolvedStyle?.backgroundColor ?? colors.card;
    } else {
      bgColor = resolvedStyle?.backgroundColor ?? VColors.transparent;
    }

    final titleStyle = typography.bodyLarge.copyWith(color: fgColor);

    final subtitleStyle = typography.bodyMedium.copyWith(
      color: colors.mutedForeground,
    );

    final Widget switchWidget = VSwitch(
      value: widget.value,
      onChanged: widget.enabled ? widget.onChanged : null,
      activeColor: resolvedStyle?.activeColor ?? widget.activeColor,
    );

    final Widget contentColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tileText(widget.title, titleStyle),
        if (widget.subtitle != null)
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xxs),
            child: _tileText(widget.subtitle!, subtitleStyle),
          ),
      ],
    );

    List<Widget> rowChildren;
    if (widget._variant == _VSwitchListTileVariant.leading) {
      rowChildren = [
        switchWidget,
        SizedBox(width: theme.spacing.lg),
        Expanded(child: contentColumn),
        if (widget.secondary != null)
          Padding(
            padding: EdgeInsets.only(left: theme.spacing.lg),
            child: widget.secondary,
          ),
      ];
    } else {
      rowChildren = [
        if (widget.secondary != null)
          Padding(
            padding: EdgeInsets.only(right: theme.spacing.lg),
            child: widget.secondary,
          ),
        Expanded(child: contentColumn),
        SizedBox(width: theme.spacing.lg),
        switchWidget,
      ];
    }

    // Focus ring (WCAG 2.4.7)
    final isCard = widget._variant == _VSwitchListTileVariant.card;
    final effectiveRadius =
        resolvedStyle?.borderRadius ?? (isCard ? theme.radius.lgRadius : null);
    final cardBorder = isCard ? Border.all(color: colors.border) : null;

    Widget tile = DecoratedBox(
      decoration: _isFocused && widget.enabled
          ? BoxDecoration(
              borderRadius: effectiveRadius,
              border: Border.all(color: colors.ring, width: 2),
            )
          : const BoxDecoration(),
      child: AnimatedContainer(
        duration: theme.animations.fast,
        curve: Curves.easeOut,
        constraints: BoxConstraints(minHeight: theme.sizes.xl.height),
        padding:
            resolvedStyle?.padding ??
            widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: theme.spacing.lg,
              vertical: theme.spacing.sm,
            ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: effectiveRadius,
          border: cardBorder,
        ),
        child: Opacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          child: Row(children: rowChildren),
        ),
      ),
    );

    if (widget.enabled && widget.onChanged != null) {
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
            _handleTap();
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
            onTap: _handleTap,
            child: tile,
          ),
        ),
      );
    }

    return Semantics(
      toggled: widget.value,
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
