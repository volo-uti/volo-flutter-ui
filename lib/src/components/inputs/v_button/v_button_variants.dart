part of 'v_button.dart';

class _VButtonState extends State<VButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _tooltipOverlay;
  Timer? _tooltipTimer;
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
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _controller.reverseDuration = theme.animations.fast;
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveEaseOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _hideTooltip();
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

  void _handleLongPress() {
    if (!_isEnabled) return;
    if (widget.onLongPress != null) {
      widget.onLongPress!();
    } else if (widget.tooltip != null) {
      _showTooltip();
    }
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  void _showTooltip() {
    if (_tooltipOverlay != null || widget.tooltip == null) return;

    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final theme = VTheme.of(context);

    _tooltipOverlay = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: widget.tooltip!,
        targetPosition: position,
        targetSize: size,
        theme: theme,
        onDismiss: _hideTooltip,
      ),
    );

    Overlay.of(context).insert(_tooltipOverlay!);

    // Auto-hide after extraSlow duration (1500ms)
    _tooltipTimer?.cancel();
    _tooltipTimer = Timer(VTheme.of(context).animations.extraSlow, () {
      if (mounted) _hideTooltip();
    });
  }

  void _hideTooltip() {
    _tooltipTimer?.cancel();
    _tooltipTimer = null;
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  /// Returns properties by size.
  ({
    double height,
    double padding,
    double fontSize,
    double iconSize,
    double borderRadius,
    double spacing,
  })
  _getSizeProperties() {
    final sizes = VTheme.of(context).sizes;
    // The button's own size, then the enclosing group's, then medium.
    final size =
        widget.size ??
        VButtonGroupScope.maybeOf(context)?.size ??
        VButtonSize.md;
    switch (size) {
      case VButtonSize.xs:
        return (
          height: sizes.xs.height,
          padding: sizes.xs.paddingHorizontal,
          fontSize: sizes.xs.fontSize,
          iconSize: sizes.xs.iconSize,
          borderRadius: sizes.xs.borderRadius,
          spacing: sizes.xs.spacing,
        );
      case VButtonSize.sm:
        return (
          height: sizes.sm.height,
          padding: sizes.sm.paddingHorizontal,
          fontSize: sizes.sm.fontSize,
          iconSize: sizes.sm.iconSize,
          borderRadius: sizes.sm.borderRadius,
          spacing: sizes.sm.spacing,
        );
      case VButtonSize.md:
        return (
          height: sizes.md.height,
          padding: sizes.md.paddingHorizontal,
          fontSize: sizes.md.fontSize,
          iconSize: sizes.md.iconSize,
          borderRadius: sizes.md.borderRadius,
          spacing: sizes.md.spacing,
        );
      case VButtonSize.lg:
        return (
          height: sizes.lg.height,
          padding: sizes.lg.paddingHorizontal,
          fontSize: sizes.lg.fontSize,
          iconSize: sizes.lg.iconSize,
          borderRadius: sizes.lg.borderRadius,
          spacing: sizes.lg.spacing,
        );
      case VButtonSize.xl:
        return (
          height: sizes.xl.height,
          padding: sizes.xl.paddingHorizontal,
          fontSize: sizes.xl.fontSize,
          iconSize: sizes.xl.iconSize,
          borderRadius: sizes.xl.borderRadius,
          spacing: sizes.xl.spacing,
        );
    }
  }

  /// Returns properties by color.
  /// - [background]: filled variant background color
  /// - [foreground]: filled variant text color
  /// - [variantText]: non-filled variant text color
  /// - [outlineBorder]: outlined variant border color
  ({Color background, Color foreground, Color variantText, Color outlineBorder})
  _getColorProperties(VThemeData theme) {
    switch (widget.color) {
      case VButtonColor.primary:
        return (
          background: theme.colors.primary,
          foreground: theme.colors.primaryForeground,
          variantText: theme.colors.primary,
          outlineBorder: theme.colors.primary,
        );
      case VButtonColor.secondary:
        return (
          background: theme.colors.secondary,
          foreground: theme.colors.secondaryForeground,
          variantText: theme.colors.secondaryForeground,
          outlineBorder: theme.colors.border,
        );
      case VButtonColor.tertiary:
        return (
          background: theme.colors.accent,
          foreground: theme.colors.accentForeground,
          variantText: theme.colors.accentForeground,
          outlineBorder: theme.colors.accent,
        );
      case VButtonColor.destructive:
        return (
          background: theme.colors.destructive,
          foreground: theme.colors.destructiveForeground,
          variantText: theme.colors.destructive,
          outlineBorder: theme.colors.destructive,
        );
    }
  }

  /// Returns the border radius.
  ///
  /// Prioritizes [VButtonGroupScope]'s borderRadius when inside a group, then
  /// a square, pill or circle [VButton.corner], then [styleRadius] for a
  /// rounded corner, then the size's radius token.
  BorderRadius _getBorderRadius(
    BuildContext context,
    double sizeRadius,
    double height,
    double width,
    BorderRadius? styleRadius,
  ) {
    final groupData = VButtonGroupScope.maybeOf(context);
    if (groupData?.borderRadius != null) {
      return groupData!.borderRadius!;
    }

    switch (widget.corner) {
      case VButtonCorner.square:
        return BorderRadius.zero;
      case VButtonCorner.rounded:
        return styleRadius ?? BorderRadius.circular(sizeRadius);
      case VButtonCorner.pill:
        return BorderRadius.circular(height / 2);
      case VButtonCorner.circle:
        return BorderRadius.circular(width / 2);
    }
  }

  /// Returns the main axis alignment.
  MainAxisAlignment _getMainAxisAlignment() {
    switch (widget.align) {
      case VButtonAlign.left:
        return MainAxisAlignment.start;
      case VButtonAlign.center:
        return MainAxisAlignment.center;
      case VButtonAlign.right:
        return MainAxisAlignment.end;
    }
  }

  /// Returns the container alignment.
  Alignment _getContainerAlignment() {
    switch (widget.align) {
      case VButtonAlign.left:
        return Alignment.centerLeft;
      case VButtonAlign.center:
        return Alignment.center;
      case VButtonAlign.right:
        return Alignment.centerRight;
    }
  }

  /// Returns the alignment of wrapped label lines.
  TextAlign _getTextAlign() {
    switch (widget.align) {
      case VButtonAlign.left:
        return TextAlign.start;
      case VButtonAlign.center:
        return TextAlign.center;
      case VButtonAlign.right:
        return TextAlign.end;
    }
  }

  /// Builds the loading indicator.
  Widget _buildLoadingIndicator(Color color, double size) {
    if (widget.loadingIndicator != null) {
      return widget.loadingIndicator!;
    }
    return VLoadingSpinner(color: color, size: size);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final sizeProps = _getSizeProperties();
    final colorProps = _getColorProperties(theme);
    final isIconVariant = widget._variant == _VButtonVariant.icon;

    // Style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VButtonStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // Icon variant is square (height x height), regular buttons auto-size to content
    final buttonWidth = isIconVariant ? sizeProps.height : null;
    final borderRadius = _getBorderRadius(
      context,
      sizeProps.borderRadius,
      sizeProps.height,
      buttonWidth ?? sizeProps.height,
      resolvedStyle?.borderRadius,
    );

    // Variant-specific styles
    Color backgroundColor;
    Color foregroundColor;
    BoxBorder? border;
    TextDecoration? textDecoration;

    switch (widget._variant) {
      case _VButtonVariant.filled:
        backgroundColor = colorProps.background;
        foregroundColor = colorProps.foreground;
        border = null;
        textDecoration = null;
        break;
      case _VButtonVariant.outlined:
        backgroundColor = VColors.transparent;
        foregroundColor = colorProps.variantText;
        border = Border.all(color: colorProps.outlineBorder);
        textDecoration = null;
        break;
      case _VButtonVariant.text:
        backgroundColor = VColors.transparent;
        foregroundColor = colorProps.variantText;
        border = null;
        textDecoration = null;
        break;
      case _VButtonVariant.ghost:
        backgroundColor = VColors.transparent;
        foregroundColor = colorProps.variantText;
        border = null;
        textDecoration = null;
        break;
      case _VButtonVariant.icon:
        backgroundColor = VColors.transparent;
        foregroundColor = colorProps.variantText;
        border = null;
        textDecoration = null;
        break;
      case _VButtonVariant.link:
        backgroundColor = VColors.transparent;
        foregroundColor = colorProps.variantText;
        border = null;
        textDecoration = TextDecoration.underline;
        break;
    }

    // Apply style color overrides
    if (resolvedStyle != null) {
      backgroundColor = resolvedStyle.backgroundColor ?? backgroundColor;
      foregroundColor = resolvedStyle.foregroundColor ?? foregroundColor;
    }
    // Border color: the instance style, then the enclosing group's, then the
    // theme style, then the variant's border.
    final borderColor =
        widget.style?.borderColor ??
        VButtonGroupScope.maybeOf(context)?.borderColor ??
        themeStyle?.borderColor;
    if (borderColor != null) border = Border.all(color: borderColor);

    // Text style: the size's font size and medium weight, then the style's
    // textStyle on top. An explicit foregroundColor wins over its color.
    final labelColor =
        resolvedStyle?.foregroundColor ??
        resolvedStyle?.textStyle?.color ??
        foregroundColor;
    final textStyle = TextStyle(
      fontSize: sizeProps.fontSize,
      fontWeight: FontWeight.w500,
      decoration: textDecoration,
      decorationColor: labelColor,
      decorationThickness: textDecoration != null ? 2.0 : null,
    ).merge(resolvedStyle?.textStyle).copyWith(color: labelColor);
    final iconColor = resolvedStyle?.iconColor ?? foregroundColor;

    // Content composition
    Widget content;
    final isLoading = widget.loading;
    final loadingIndicator = _buildLoadingIndicator(
      foregroundColor,
      sizeProps.iconSize,
    );
    final effectiveLeadingGap =
        widget.leadingGap ?? resolvedStyle?.gap ?? sizeProps.spacing;
    final effectiveTrailingGap =
        widget.trailingGap ?? resolvedStyle?.gap ?? sizeProps.spacing;

    if (isLoading && widget.loadingPosition == VButtonLoadingPosition.center) {
      // Center loading: hide child and show loading only
      content = loadingIndicator;
    } else {
      // Normal content
      final childWidget = IconTheme.merge(
        data: IconThemeData(color: iconColor, size: sizeProps.iconSize),
        child: widget.child,
      );
      final items = <Widget>[];

      // Leading or loading (start)
      if (isLoading && widget.loadingPosition == VButtonLoadingPosition.start) {
        items
          ..add(loadingIndicator)
          ..add(SizedBox(width: effectiveLeadingGap));
      } else if (widget.leading != null) {
        items
          ..add(
            IconTheme(
              data: IconThemeData(color: iconColor, size: sizeProps.iconSize),
              child: widget.leading!,
            ),
          )
          ..add(SizedBox(width: effectiveLeadingGap));
      }

      // child: flexible, so a long label wraps instead of overflowing
      items.add(Flexible(child: childWidget));

      // Trailing or loading (end)
      if (isLoading && widget.loadingPosition == VButtonLoadingPosition.end) {
        items
          ..add(SizedBox(width: effectiveTrailingGap))
          ..add(loadingIndicator);
      } else if (widget.trailing != null) {
        items
          ..add(SizedBox(width: effectiveTrailingGap))
          ..add(
            IconTheme(
              data: IconThemeData(color: iconColor, size: sizeProps.iconSize),
              child: widget.trailing!,
            ),
          );
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: _getMainAxisAlignment(),
        children: items,
      );
    }

    // Wrap with DefaultTextStyle to apply color to Widget children; wrapped
    // lines follow the content alignment.
    content = DefaultTextStyle(
      style: textStyle,
      textAlign: _getTextAlign(),
      child: content,
    );

    // Button container
    final actualButtonWidth = isIconVariant
        ? sizeProps.height
        : (widget.fullWidth ? double.infinity : null);
    // The icon variant is a fixed square, so it takes no padding.
    final buttonPadding = isIconVariant
        ? EdgeInsets.zero
        : resolvedStyle?.padding ??
              EdgeInsets.symmetric(horizontal: sizeProps.padding);

    // Hover background color (for text, outlined, icon, link variants)
    Color hoverBackgroundColor;
    if (_isHovered && _isEnabled) {
      switch (widget._variant) {
        case _VButtonVariant.filled:
          hoverBackgroundColor = backgroundColor;
        case _VButtonVariant.ghost:
          hoverBackgroundColor = theme.colors.accent;
        case _VButtonVariant.outlined:
        case _VButtonVariant.text:
        case _VButtonVariant.icon:
        case _VButtonVariant.link:
          hoverBackgroundColor = theme.colors.accent;
      }
    } else {
      hoverBackgroundColor = backgroundColor;
    }

    // Hover scale (1.0 -> 1.02), press scale (1.0 -> 0.98)
    final hoverScale = _isHovered && _isEnabled ? 1.02 : 1.0;

    final buttonContent = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value * hoverScale,
        child: Opacity(
          opacity: !(widget.enabled && widget.onPressed != null)
              ? 0.5
              : _opacityAnimation.value,
          child: AnimatedContainer(
            duration: theme.animations.fast,
            curve: theme.animations.curveEaseOut,
            width: actualButtonWidth,
            // A minimum, not a fixed height: the button grows with the text
            // scale and with a label that wraps.
            constraints: BoxConstraints(minHeight: sizeProps.height),
            padding: buttonPadding,
            decoration: BoxDecoration(
              color: hoverBackgroundColor,
              borderRadius: borderRadius,
              border: border,
            ),
            child: Align(
              alignment: _getContainerAlignment(),
              heightFactor: 1,
              child: content,
            ),
          ),
        ),
      ),
    );

    // Shrink-wrap when not fullWidth (prevents expansion in loose constraints).
    // Skip when inside VButtonGroup to preserve group layout.
    final inGroup = VButtonGroupScope.maybeOf(context) != null;
    var button = (actualButtonWidth != null || inGroup)
        ? buttonContent
        : IntrinsicWidth(child: buttonContent);

    // MouseRegion + GestureDetector wrapping
    button = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        key: _buttonKey,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        onLongPress: (widget.onLongPress != null || widget.tooltip != null)
            ? _handleLongPress
            : null,
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7); Enter and Space press it.
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
          borderRadius: borderRadius,
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
      label: widget.semanticLabel,
      child: button,
    );

    return FocusTraversalGroup(child: button);
  }
}

/// Button variant type.
enum _VButtonVariant {
  /// Filled background.
  filled,

  /// Outlined.
  outlined,

  /// Text.
  text,

  /// Ghost (transparent, accent hover).
  ghost,

  /// Icon.
  icon,

  /// Link.
  link,
}

/// Tooltip overlay.
class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.message,
    required this.targetPosition,
    required this.targetSize,
    required this.theme,
    required this.onDismiss,
  });

  final String message;
  final Offset targetPosition;
  final Size targetSize;
  final VThemeData theme;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = theme.colors;
    final typography = theme.typography;

    // Tooltip position: centered above the button
    final tooltipTop = targetPosition.dy - 40;
    final tooltipLeft = targetPosition.dx + (targetSize.width / 2);

    return Stack(
      children: [
        // Dismiss on background tap
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        // Tooltip
        Positioned(
          top: tooltipTop,
          left: tooltipLeft,
          child: FractionalTranslation(
            translation: const Offset(-0.5, 0),
            child: DefaultTextStyle(
              style: TextStyle(
                decoration: TextDecoration.none,
                color: colors.background,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.md,
                  vertical: theme.spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.foreground,
                  borderRadius: theme.radius.xsRadius,
                ),
                child: Text(
                  message,
                  style: typography.bodySmall.copyWith(
                    color: colors.background,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
