import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_checkbox/v_checkbox.dart'
    show VWidgetSize;
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';

import 'v_switch_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

// WHY: Custom switch instead of CupertinoSwitch/Material Switch — both
// impose platform-specific visual styling and require their respective
// theme systems. Our implementation uses GestureDetector + AnimatedContainer
// for full token-driven customization without platform coupling.
/// Animated on/off switch with an optional label, also available with I/O marks.
///
/// Without [onChanged] the switch is disabled.
///
/// ```dart
/// VSwitch(
///   value: isOn,
///   onChanged: (value) => setState(() => isOn = value),
///   label: const Text('Dark mode'),
///   sublabel: const Text('Display the screen in dark colors'),
/// )
/// ```
class VSwitch extends StatefulWidget {
  /// Creates a plain switch.
  const VSwitch({
    required this.value,
    super.key,
    this.name,
    this.onChanged,
    this.label,
    this.sublabel,
    this.enabled = true,
    this.activeColor,
    this.size = VWidgetSize.md,
    this.style,
  }) : isLabeled = false;

  /// Creates a switch with I/O marks drawn inside the track.
  const VSwitch.labeled({
    required this.value,
    super.key,
    this.name,
    this.onChanged,
    this.label,
    this.sublabel,
    this.enabled = true,
    this.activeColor,
    this.size = VWidgetSize.md,
    this.style,
  }) : isLabeled = true;

  /// Key identifying this switch in debug logs.
  final String? name;

  /// Whether the switch is on.
  final bool value;

  /// Called with the new state when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Content shown beside the switch; inherits the label text style.
  final Widget? label;

  /// Secondary content below [label]; inherits the muted text style.
  final Widget? sublabel;

  /// Whether the switch reacts to input.
  final bool enabled;

  /// Track color while on; defaults to the theme primary color.
  final Color? activeColor;

  /// Size (sm/md/lg).
  final VWidgetSize size;

  /// Style override merged over the theme's [VSwitchStyle].
  final VSwitchStyle? style;

  /// Whether the I/O marks are drawn inside the track.
  final bool isLabeled;

  @override
  State<VSwitch> createState() => _VSwitchState();
}

class _VSwitchState extends State<VSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  bool _isHovered = false;
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

    if (widget.value) {
      _controller.value = 1.0;
    }

    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: theme.animations.curveEaseOut,
    );
  }

  void _setupAnimations() {
    // Position animation uses normalized 0.0-1.0; actual distance computed in build().
    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(VSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    final newValue = !widget.value;

    VDebug.log(
      category: VDebugCategory.input,
      component: 'VSwitch',
      name: widget.name,
      action: 'toggled',
      value: newValue,
    );

    widget.onChanged?.call(newValue);
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VSwitchStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // Switch dimensions derived from size tokens (component-specific proportional)
    final thumbSize = switch (widget.size) {
      VWidgetSize.sm => theme.sizes.sm.iconSize,
      VWidgetSize.md => theme.sizes.lg.iconSize,
      VWidgetSize.lg => theme.sizes.xl.iconSize,
    };
    final thumbPadding = theme.spacing.xxs;
    final trackHeight = thumbSize + thumbPadding * 2;
    final trackWidth = thumbSize * 2 + thumbPadding * 2;

    // Colors
    var activeColor = widget.activeColor ?? theme.colors.primary;
    var inactiveColor = theme.colors.muted;
    var thumbColor = theme.colors.background;

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      activeColor = resolvedStyle.activeTrackColor ?? activeColor;
      inactiveColor = resolvedStyle.inactiveTrackColor ?? inactiveColor;
      thumbColor = resolvedStyle.thumbColor ?? thumbColor;
      if (widget.value && resolvedStyle.activeThumbColor != null) {
        thumbColor = resolvedStyle.activeThumbColor!;
      }
    }

    // Scale on hover
    final hoverScale = _isHovered && _isEnabled ? 1.05 : 1.0;

    // Switch widget
    Widget switchWidget = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final trackColor = Color.lerp(
          inactiveColor,
          activeColor,
          _controller.value,
        );

        // Border on hover
        final border = _isHovered && _isEnabled && !widget.value
            ? Border.all(color: theme.colors.primary, width: 2)
            : null;

        return Transform.scale(
          scale: hoverScale,
          child: AnimatedContainer(
            duration: theme.animations.fast,
            curve: theme.animations.curveEaseOut,
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(trackHeight / 2),
              border: border,
            ),
            child: Stack(
              children: [
                // Internal On/Off text (labeled variant)
                if (widget.isLabeled) ...[
                  Positioned(
                    left: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: ExcludeSemantics(
                        child: Text(
                          'I',
                          style: theme.typography.labelSmall.copyWith(
                            color: widget.value
                                ? theme.colors.background
                                : theme.colors.mutedForeground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: ExcludeSemantics(
                        child: Text(
                          'O',
                          style: theme.typography.labelSmall.copyWith(
                            color: widget.value
                                ? theme.colors.mutedForeground
                                : theme.colors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                Positioned(
                  left:
                      thumbPadding +
                      _positionAnimation.value *
                          (trackWidth - thumbSize - thumbPadding * 2),
                  top: thumbPadding,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: theme.shadows.sm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Compose with Row if label exists
    if (widget.label != null) {
      final labelStyle = theme.typography.bodyMedium.copyWith(
        color: widget.enabled
            ? theme.colors.foreground
            : theme.colors.mutedForeground,
      );
      final sublabelStyle = theme.typography.bodySmall.copyWith(
        color: theme.colors.mutedForeground,
      );

      final labelWidget = DefaultTextStyle.merge(
        style: labelStyle,
        child: widget.label!,
      );
      final sublabelWidget = widget.sublabel == null
          ? null
          : DefaultTextStyle.merge(
              style: sublabelStyle,
              child: widget.sublabel!,
            );

      final labelColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          labelWidget,
          if (sublabelWidget != null) ...[
            SizedBox(height: theme.spacing.xxs),
            sublabelWidget,
          ],
        ],
      );
      final track = switchWidget;

      // WHY: Expanded needs a bounded width; in a shrink-wrapping parent
      // (a min-size Row, a Wrap) the label only takes the room it needs.
      switchWidget = LayoutBuilder(
        builder: (context, constraints) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (constraints.hasBoundedWidth)
              Expanded(child: labelColumn)
            else
              Flexible(child: labelColumn),
            SizedBox(width: theme.spacing.sm),
            track,
          ],
        ),
      );
    }

    // Opacity when disabled
    switchWidget = Opacity(
      opacity: _isEnabled ? 1.0 : 0.5,
      child: switchWidget,
    );

    // WCAG 2.5.8: Minimum touch target 24x24
    switchWidget = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: switchWidget,
    );

    // MouseRegion + gesture wrapping
    switchWidget = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: switchWidget,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    switchWidget = FocusableActionDetector(
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
          borderRadius: BorderRadius.circular(trackHeight / 2),
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: switchWidget,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    switchWidget = Semantics(
      toggled: widget.value,
      enabled: _isEnabled,
      child: switchWidget,
    );

    return FocusTraversalGroup(child: switchWidget);
  }
}
