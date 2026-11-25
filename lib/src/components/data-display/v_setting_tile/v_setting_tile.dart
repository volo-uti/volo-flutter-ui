import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_checkbox/v_checkbox.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_radio/v_radio.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_switch/v_switch.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_setting_tile_style.dart';

/// Row for a settings screen: a plain item, a navigation link, a switch or a checkbox.
///
/// Pick the variant with a named constructor: [VSettingTile.simple],
/// [VSettingTile.navigation], [VSettingTile.switchTile] or
/// [VSettingTile.checkbox] or [VSettingTile.radio]. The toggle variants flip on
/// a tap anywhere on the row and report the new value through `onChanged`;
/// the radio variant reports its own value.
///
/// ```dart
/// VSettingTile.switchTile(
///   leading: const Icon(Icons.notifications),
///   title: const Text('Notifications'),
///   subtitle: const Text('Receive push notifications'),
///   value: notifications,
///   onChanged: (v) => setState(() => notifications = v),
/// )
/// ```
class VSettingTile extends StatefulWidget {
  /// Creates a plain item with an optional [trailing] widget.
  const VSettingTile.simple({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.style,
  }) : _variant = _VSettingTileVariant.simple,
       value = null,
       _checked = false,
       _onChanged = null;

  /// Creates a link row with an optional [value] label and a chevron.
  const VSettingTile.navigation({
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.leading,
    this.value,
    this.enabled = true,
    this.style,
  }) : _variant = _VSettingTileVariant.navigation,
       trailing = null,
       _checked = false,
       _onChanged = null;

  /// Creates a row with a switch at the end.
  const VSettingTile.switchTile({
    required this.title,
    required bool value,
    super.key,
    this.subtitle,
    this.leading,
    this._onChanged,
    this.enabled = true,
    this.style,
  }) : _variant = _VSettingTileVariant.switchTile,
       trailing = null,
       value = null,
       onTap = null,
       _checked = value;

  /// Creates a row with a checkbox at the end.
  const VSettingTile.checkbox({
    required this.title,
    required bool value,
    super.key,
    this.subtitle,
    this.leading,
    this._onChanged,
    this.enabled = true,
    this.style,
  }) : _variant = _VSettingTileVariant.checkbox,
       trailing = null,
       value = null,
       onTap = null,
       _checked = value;

  VSettingTile._radio({
    required this.title,
    required bool selected,
    required VoidCallback? onSelected,
    required this.enabled,
    super.key,
    this.subtitle,
    this.leading,
    this.style,
  }) : _variant = _VSettingTileVariant.radio,
       trailing = null,
       value = null,
       onTap = null,
       _checked = selected,
       _onChanged = onSelected == null ? null : ((_) => onSelected());

  /// Creates a row with a radio button at the end, one option of a group.
  ///
  /// The row is selected when [value] equals [groupValue]. A tap anywhere on
  /// the row, or Enter and Space when focused, calls `onChanged` with [value].
  static VSettingTile radio<T>({
    required Widget title,
    required T value,
    required T? groupValue,
    Key? key,
    Widget? subtitle,
    Widget? leading,
    ValueChanged<T?>? onChanged,
    bool enabled = true,
    VSettingTileStyle? style,
  }) => VSettingTile._radio(
    title: title,
    selected: value == groupValue,
    key: key,
    subtitle: subtitle,
    leading: leading,
    onSelected: onChanged == null ? null : () => onChanged(value),
    enabled: enabled,
    style: style,
  );

  final _VSettingTileVariant _variant;

  /// Setting name, typically a [Text].
  final Widget title;

  /// Description below [title], typically a [Text].
  final Widget? subtitle;

  /// Widget before the text, such as an icon.
  final Widget? leading;

  /// Custom widget at the end; only the simple variant shows it.
  final Widget? trailing;

  /// Called when the row is tapped; only the simple and navigation variants use it.
  final VoidCallback? onTap;

  /// Current value shown before the chevron; only the navigation variant shows it.
  final String? value;

  /// Whether the row reacts to input; false dims it and ignores taps.
  final bool enabled;

  final bool _checked;

  final ValueChanged<bool>? _onChanged;

  /// Per-instance style override merged over the theme's [VSettingTileStyle].
  final VSettingTileStyle? style;

  @override
  State<VSettingTile> createState() => _VSettingTileState();
}

enum _VSettingTileVariant { simple, navigation, switchTile, checkbox, radio }

class _VSettingTileState extends State<VSettingTile> {
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isTappable {
    if (!widget.enabled) return false;
    switch (widget._variant) {
      case _VSettingTileVariant.simple:
        return widget.onTap != null;
      case _VSettingTileVariant.navigation:
        return widget.onTap != null;
      case _VSettingTileVariant.switchTile:
        return widget._onChanged != null;
      case _VSettingTileVariant.checkbox:
      case _VSettingTileVariant.radio:
        return widget._onChanged != null;
    }
  }

  void _handleTap() {
    if (!widget.enabled) return;

    switch (widget._variant) {
      case _VSettingTileVariant.simple:
      case _VSettingTileVariant.navigation:
        widget.onTap?.call();
        break;
      case _VSettingTileVariant.switchTile:
      case _VSettingTileVariant.checkbox:
      case _VSettingTileVariant.radio:
        widget._onChanged?.call(!widget._checked);
        break;
    }
  }

  Widget _buildTrailing(VColors colors, VTypography typography) {
    switch (widget._variant) {
      case _VSettingTileVariant.simple:
        return widget.trailing ?? const SizedBox.shrink();
      case _VSettingTileVariant.navigation:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.value != null)
              Padding(
                padding: EdgeInsets.only(right: VTheme.of(context).spacing.sm),
                child: Text(
                  widget.value!,
                  style: typography.bodyMedium.copyWith(
                    color: colors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            VIcons.chevronRight(
              size: VTheme.of(context).sizes.xs.height,
              color: colors.mutedForeground,
            ),
          ],
        );
      case _VSettingTileVariant.switchTile:
        return VSwitch(
          value: widget._checked,
          onChanged: widget.enabled ? widget._onChanged : null,
        );
      case _VSettingTileVariant.checkbox:
        return VCheckbox(
          value: widget._checked,
          onChanged: widget.enabled
              ? (v) => widget._onChanged?.call(v ?? false)
              : null,
        );
      case _VSettingTileVariant.radio:
        // WHY: The inner radio gets a callback so it is not dimmed; the row
        // owns the tap, so a press on the radio itself selects the row too.
        return IgnorePointer(
          child: VRadio<bool>(
            value: true,
            groupValue: widget._checked ? true : null,
            onChanged: (_) {},
          ),
        );
    }
  }

  @override
  void didUpdateWidget(VSettingTile oldWidget) {
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
    final themeStyle = theme.componentOverrides.get<VSettingTileStyle>();
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
      bgColor = colors.accent.withValues(alpha: 0.5);
    } else {
      bgColor = resolvedStyle?.backgroundColor ?? VColors.transparent;
    }

    final titleStyle = typography.bodyLarge.copyWith(color: fgColor);

    final subtitleStyle = typography.bodySmall.copyWith(
      color: colors.mutedForeground,
    );

    // Focus ring (WCAG 2.4.7)
    Widget tile = DecoratedBox(
      decoration: _isFocused && widget.enabled
          ? BoxDecoration(
              borderRadius: resolvedStyle?.borderRadius,
              border: Border.all(color: colors.ring, width: 2),
            )
          : const BoxDecoration(),
      child: AnimatedContainer(
        duration: theme.animations.fast,
        curve: Curves.easeOut,
        constraints: BoxConstraints(minHeight: theme.sizes.xl.height),
        padding:
            resolvedStyle?.padding ??
            EdgeInsets.symmetric(
              horizontal: theme.spacing.lg,
              vertical: theme.spacing.md,
            ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: resolvedStyle?.borderRadius,
        ),
        child: Opacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          child: Row(
            children: [
              if (widget.leading != null)
                Padding(
                  padding: EdgeInsets.only(right: theme.spacing.lg),
                  child: SizedBox(
                    width: theme.sizes.xs.height,
                    height: theme.sizes.xs.height,
                    child: Center(child: widget.leading),
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tileText(widget.title, titleStyle),
                    if (widget.subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: theme.spacing.xxs),
                        child: _tileText(widget.subtitle!, subtitleStyle),
                      ),
                  ],
                ),
              ),
              // WHY: The row is the one toggled node (it carries the title and
              // the tap action), so the inner control is not a second one.
              ExcludeSemantics(
                excluding:
                    widget._variant == _VSettingTileVariant.switchTile ||
                    widget._variant == _VSettingTileVariant.checkbox ||
                    widget._variant == _VSettingTileVariant.radio,
                child: _buildTrailing(colors, typography),
              ),
            ],
          ),
        ),
      ),
    );

    if (_isTappable) {
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
      button: widget._variant == _VSettingTileVariant.navigation,
      toggled: widget._variant == _VSettingTileVariant.switchTile
          ? widget._checked
          : null,
      checked:
          widget._variant == _VSettingTileVariant.checkbox ||
              widget._variant == _VSettingTileVariant.radio
          ? widget._checked
          : null,
      inMutuallyExclusiveGroup: widget._variant == _VSettingTileVariant.radio
          ? true
          : null,
      enabled: widget.enabled,
      child: tile,
    );
  }
}

Widget _tileText(Widget child, TextStyle style) => DefaultTextStyle.merge(
  style: style,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  child: child,
);
