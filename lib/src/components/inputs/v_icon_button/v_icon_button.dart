import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/feedback/v_loading_spinner/v_loading_spinner.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button/v_button.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_icon_button_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Icon button size.
enum VIconButtonSize {
  /// Extra small (24px).
  xs,

  /// Small (32px).
  sm,

  /// Medium (40px).
  md,

  /// Large (48px).
  lg,

  /// Extra large (56px).
  xl,
}

/// Round button that shows a single icon, optionally toggling between two.
///
/// Set [VIconButton.isSelected] to make it a toggle.
///
/// **Basic Usage:**
///
/// ```dart
/// VIconButton(
///   icon: Icon(Icons.search),
///   onPressed: () {},
/// )
/// ```
///
/// **Variants:**
///
/// - [VIconButton] - Default (transparent background)
/// - [VIconButton.filled] - Filled background
/// - [VIconButton.outlined] - Bordered
/// - [VIconButton.filledTonal] - Tonal filled
///
/// **Toggle State:**
///
/// ```dart
/// VIconButton(
///   icon: Icon(Icons.favorite_border),
///   selectedIcon: Icon(Icons.favorite),
///   isSelected: isFavorite,
///   onPressed: () => setState(() => isFavorite = !isFavorite),
/// )
/// ```
class VIconButton extends StatefulWidget {
  /// Creates an icon button with a transparent background.
  const VIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.selectedIcon,
    this.isSelected,
    this.tooltip,
    this.size = VIconButtonSize.md,
    this.color = VButtonColor.primary,
    this.loading = false,
    this.enabled = true,
    this.style,
  }) : _variant = _VIconButtonVariant.standard;

  /// Creates an icon button with a filled background.
  const VIconButton.filled({
    required this.icon,
    super.key,
    this.onPressed,
    this.selectedIcon,
    this.isSelected,
    this.tooltip,
    this.size = VIconButtonSize.md,
    this.color = VButtonColor.primary,
    this.loading = false,
    this.enabled = true,
    this.style,
  }) : _variant = _VIconButtonVariant.filled;

  /// Creates an icon button with a border.
  const VIconButton.outlined({
    required this.icon,
    super.key,
    this.onPressed,
    this.selectedIcon,
    this.isSelected,
    this.tooltip,
    this.size = VIconButtonSize.md,
    this.color = VButtonColor.primary,
    this.loading = false,
    this.enabled = true,
    this.style,
  }) : _variant = _VIconButtonVariant.outlined;

  /// Creates an icon button with a tonal background.
  const VIconButton.filledTonal({
    required this.icon,
    super.key,
    this.onPressed,
    this.selectedIcon,
    this.isSelected,
    this.tooltip,
    this.size = VIconButtonSize.md,
    this.color = VButtonColor.primary,
    this.loading = false,
    this.enabled = true,
    this.style,
  }) : _variant = _VIconButtonVariant.filledTonal;

  /// Icon shown in the button; plain `Icon` children take the button's color and size.
  final Widget icon;

  /// Called when the button is tapped; `null` renders it disabled.
  final VoidCallback? onPressed;

  /// Icon shown instead of [icon] while [isSelected] is true.
  final Widget? selectedIcon;

  /// Whether the toggle is on; `null` means the button is not a toggle.
  final bool? isSelected;

  /// Label announced by screen readers.
  final String? tooltip;

  /// Diameter preset of the button.
  final VIconButtonSize size;

  /// Color role of the button.
  final VButtonColor color;

  /// Whether a spinner replaces the icon and presses are blocked.
  final bool loading;

  /// Whether the button reacts to input; `false` dims it and blocks presses.
  final bool enabled;

  /// Per-instance style override merged over the theme's [VIconButtonStyle].
  final VIconButtonStyle? style;

  final _VIconButtonVariant _variant;

  @override
  State<VIconButton> createState() => _VIconButtonState();
}

class _VIconButtonState extends State<VIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
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
    _controller = AnimationController(
      vsync: this,
      duration: VAnimations.defaults.fast, // fallback default
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _opacityAnimation = Tween<double>(begin: 1, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: theme.animations.curveEaseIn),
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

  bool get _isEnabled =>
      widget.enabled && !widget.loading && widget.onPressed != null;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    unawaited(_controller.forward());
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    unawaited(_controller.reverse());
  }

  void _handleTap() {
    if (!_isEnabled) return;
    widget.onPressed?.call();
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  /// Returns size properties from theme tokens.
  ({double height, double iconSize}) _getSizeProperties(VThemeData theme) {
    final sizes = theme.sizes;
    switch (widget.size) {
      case VIconButtonSize.xs:
        return (height: sizes.xs.height, iconSize: sizes.xs.iconSize);
      case VIconButtonSize.sm:
        return (height: sizes.sm.height, iconSize: sizes.sm.iconSize);
      case VIconButtonSize.md:
        return (height: sizes.md.height, iconSize: sizes.md.iconSize);
      case VIconButtonSize.lg:
        return (height: sizes.lg.height, iconSize: sizes.lg.iconSize);
      case VIconButtonSize.xl:
        return (height: sizes.xl.height, iconSize: sizes.xl.iconSize);
    }
  }

  /// Returns color properties from theme.
  ({Color background, Color foreground}) _getColorProperties(VThemeData theme) {
    switch (widget.color) {
      case VButtonColor.primary:
        return (
          background: theme.colors.primary,
          foreground: theme.colors.primaryForeground,
        );
      case VButtonColor.secondary:
        return (
          background: theme.colors.secondary,
          foreground: theme.colors.secondaryForeground,
        );
      case VButtonColor.tertiary:
        return (
          background: theme.colors.accent,
          foreground: theme.colors.accentForeground,
        );
      case VButtonColor.destructive:
        return (
          background: theme.colors.destructive,
          foreground: theme.colors.destructiveForeground,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VIconButtonStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final sizeProps = _getSizeProperties(theme);
    final colorProps = _getColorProperties(theme);
    final btnSize = sizeProps.height;
    var iconSize = sizeProps.iconSize;

    // Determine which icon to display
    Widget displayIcon;
    if (widget.loading) {
      displayIcon = VLoadingSpinner(
        color: colorProps.foreground,
        size: iconSize,
      );
    } else if ((widget.isSelected ?? false) && widget.selectedIcon != null) {
      displayIcon = widget.selectedIcon!;
    } else {
      displayIcon = widget.icon;
    }

    // Variant-specific styles
    Color backgroundColor;
    Color iconColor;
    BoxBorder? border;

    switch (widget._variant) {
      case _VIconButtonVariant.standard:
        backgroundColor = VColors.transparent;
        iconColor = colorProps.background;
        border = null;
        break;
      case _VIconButtonVariant.filled:
        backgroundColor = colorProps.background;
        iconColor = colorProps.foreground;
        border = null;
        break;
      case _VIconButtonVariant.outlined:
        backgroundColor = VColors.transparent;
        iconColor = colorProps.background;
        border = Border.all(color: theme.colors.border);
        break;
      case _VIconButtonVariant.filledTonal:
        backgroundColor = colorProps.background.withValues(alpha: 0.15);
        iconColor = colorProps.background;
        border = null;
        break;
    }

    // Highlight when selected
    if (widget.isSelected ?? false) {
      iconColor = colorProps.background;
    }

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      backgroundColor = resolvedStyle.backgroundColor ?? backgroundColor;
      iconColor =
          resolvedStyle.iconColor ?? resolvedStyle.foregroundColor ?? iconColor;
      iconSize = resolvedStyle.iconSize ?? iconSize;
      if (resolvedStyle.borderColor != null) {
        border = Border.all(color: resolvedStyle.borderColor!);
      }
    }

    // Apply opacity when disabled
    final effectiveOpacity = _isEnabled ? 1.0 : 0.5;

    // Background color on hover
    Color effectiveBackgroundColor;
    if (_isHovered && _isEnabled) {
      effectiveBackgroundColor = backgroundColor == VColors.transparent
          ? theme.colors.muted.withValues(alpha: 0.3)
          : backgroundColor;
    } else {
      effectiveBackgroundColor = backgroundColor;
    }

    // Scale on hover
    final hoverScale = _isHovered && _isEnabled ? 1.05 : 1.0;

    Widget button = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: hoverScale,
        child: Opacity(
          opacity: effectiveOpacity * _opacityAnimation.value,
          child: AnimatedContainer(
            duration: theme.animations.fast,
            curve: theme.animations.curveEaseOut,
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius:
                  resolvedStyle?.borderRadius ??
                  BorderRadius.circular(btnSize / 2),
              border: border,
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: iconSize),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: iconColor,
                    fontSize: iconSize,
                    height: 1,
                  ),
                  child: displayIcon,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // MouseRegion + GestureDetector wrapping
    button = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    button = FocusableActionDetector(
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
          borderRadius: BorderRadius.circular(btnSize / 2),
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: button,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    button = Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.tooltip,
      toggled: widget.isSelected,
      child: button,
    );

    return FocusTraversalGroup(child: button);
  }
}

/// Icon button variant type.
enum _VIconButtonVariant {
  /// Standard (transparent).
  standard,

  /// Filled.
  filled,

  /// Outlined.
  outlined,

  /// Tonal filled.
  filledTonal,
}
