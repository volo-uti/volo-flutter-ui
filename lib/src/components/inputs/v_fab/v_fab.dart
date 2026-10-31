import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_fab_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Floating button for the primary action of a screen, in round and extended forms.
///
/// **Basic Usage:**
///
/// ```dart
/// VFab(
///   icon: Icon(Icons.add),
///   onPressed: () {},
/// )
/// ```
///
/// **Variants:**
///
/// - [VFab] - Default (56x56)
/// - [VFab.small] - Small size (40x40)
/// - [VFab.large] - Large size (96x96)
/// - [VFab.extended] - With text label
///
/// **Extended FAB:**
///
/// ```dart
/// VFab.extended(
///   icon: Icon(Icons.add),
///   label: Text('New item'),
///   onPressed: () {},
/// )
/// ```
class VFab extends StatefulWidget {
  /// Creates a 56x56 FAB.
  const VFab({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.heroTag,
    this.enabled = true,
    this.style,
  }) : _size = 56,
       label = null,
       _extended = false;

  /// Creates a 40x40 FAB.
  const VFab.small({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.heroTag,
    this.enabled = true,
    this.style,
  }) : _size = 40,
       label = null,
       _extended = false;

  /// Creates a 96x96 FAB.
  const VFab.large({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.heroTag,
    this.enabled = true,
    this.style,
  }) : _size = 96,
       label = null,
       _extended = false;

  /// Creates a pill-shaped FAB with an icon and a text label.
  const VFab.extended({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.heroTag,
    this.enabled = true,
    this.style,
  }) : _size = 48,
       _extended = true;

  /// Icon shown in the FAB; plain `Icon` children take the foreground color.
  final Widget? icon;

  /// Text shown next to [icon] in the extended FAB.
  final Widget? label;

  /// Called when the FAB is tapped; `null` renders it disabled.
  final VoidCallback? onPressed;

  /// Label announced by screen readers.
  final String? tooltip;

  /// Fill color; defaults to the primary color.
  final Color? backgroundColor;

  /// Icon and label color; defaults to the primary foreground color.
  final Color? foregroundColor;

  /// Shadow depth in logical pixels; defaults to the theme's medium shadow.
  final double? elevation;

  /// Tag that makes the FAB a [Hero] across route transitions.
  final Object? heroTag;

  /// Whether the FAB reacts to input; `false` dims it and blocks presses.
  final bool enabled;

  /// Per-instance style override merged over the theme's [VFabStyle].
  final VFabStyle? style;

  final bool _extended;

  final double _size;

  @override
  State<VFab> createState() => _VFabState();
}

class _VFabState extends State<VFab> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    _controller = AnimationController(vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _controller.reverseDuration = theme.animations.fast;
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.onPressed != null && widget.enabled;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = true);
    unawaited(_controller.forward());
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    setState(() => _isPressed = false);
    unawaited(_controller.reverse());
  }

  void _handleTap() {
    if (!_isEnabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFabStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    var backgroundColor = widget.backgroundColor ?? theme.colors.primary;
    var foregroundColor =
        widget.foregroundColor ?? theme.colors.primaryForeground;

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      backgroundColor = resolvedStyle.backgroundColor ?? backgroundColor;
      foregroundColor = resolvedStyle.foregroundColor ?? foregroundColor;
    }
    // Icon size
    final iconSize = widget._size == 96
        ? 36.0
        : (widget._size == 40 ? 18.0 : 24.0);

    // Text style
    final textStyle = TextStyle(
      fontSize: theme.sizes.md.fontSize,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    );

    // Content composition
    Widget content;
    if (widget._extended && widget.label != null) {
      final labelWidget = widget.label == null
          ? null
          : DefaultTextStyle.merge(style: textStyle, child: widget.label!);
      final items = <Widget>[];

      if (widget.icon != null) {
        items.add(
          IconTheme(
            data: IconThemeData(color: foregroundColor, size: iconSize),
            child: DefaultTextStyle(
              style: TextStyle(
                color: foregroundColor,
                fontSize: iconSize,
                height: 1,
              ),
              child: widget.icon!,
            ),
          ),
        );
        if (labelWidget != null) {
          items.add(SizedBox(width: theme.spacing.sm));
        }
      }

      if (labelWidget != null) {
        items.add(labelWidget);
      }

      content = Row(mainAxisSize: MainAxisSize.min, children: items);
    } else if (widget.icon != null) {
      content = IconTheme(
        data: IconThemeData(color: foregroundColor, size: iconSize),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foregroundColor,
            fontSize: iconSize,
            height: 1,
          ),
          child: widget.icon!,
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    // FAB size and corners
    final fabSize = widget._extended ? null : widget._size;
    final borderRadius =
        resolvedStyle?.borderRadius ?? BorderRadius.circular(widget._size / 2);
    final padding = widget._extended
        ? EdgeInsets.symmetric(horizontal: theme.spacing.lg)
        : EdgeInsets.zero;

    // Shadow: lg when pressed, md by default
    final elevation = widget.elevation;
    final shadow = elevation != null
        ? [
            BoxShadow(
              color: theme.colors.foreground.withValues(alpha: 0.2),
              blurRadius: elevation * 2,
              offset: Offset(0, elevation / 2),
            ),
          ]
        : (_isPressed ? theme.shadows.lg : theme.shadows.md);

    Widget fab = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.38,
          child: Container(
            width: fabSize,
            height: widget._size,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              boxShadow: shadow,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );

    // WCAG 2.5.8: Explicit minimum touch target 24x24
    fab = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: fab,
    );

    // Gesture wrapping
    fab = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: fab,
    );

    // Hero wrapping
    if (widget.heroTag != null) {
      fab = Hero(tag: widget.heroTag!, child: fab);
    }

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    fab = FocusableActionDetector(
      focusNode: _focusNode,
      enabled: _isEnabled,
      shortcuts: _activateShortcuts,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleTap();
            return null;
          },
        ),
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: fab,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    fab = Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.tooltip ?? VoloLocalizations.of(context).fabLabel,
      child: fab,
    );

    return FocusTraversalGroup(child: fab);
  }
}
