import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_link_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Link underline behavior.
enum VLinkUnderline {
  /// Always show underline.
  always,

  /// Show underline on hover (default).
  hover,

  /// Never show underline.
  none,
}

/// Link color variant.
enum VLinkColor {
  /// Primary color (default).
  primary,

  /// Secondary/muted color.
  secondary,

  /// Inherit from parent.
  inherit,
}

/// Inline link that underlines on hover and reports taps.
///
/// Plain `Text` children are drawn in the link color with the chosen
/// underline behavior.
///
/// ```dart
/// VLink(
///   onTap: () => launchUrl(Uri.parse('https://example.com')),
///   child: Text('Learn more'),
/// )
/// ```
///
/// See also:
///
/// - [VButton.link] - Link-style button variant.
class VLink extends StatefulWidget {
  /// Creates a link around [child].
  const VLink({
    required this.child,
    super.key,
    this.onTap,
    this.underline = VLinkUnderline.always,
    this.color = VLinkColor.primary,
    this.semanticLabel,
    this.style,
  });

  /// Content of the link; plain `Text` takes the link color and underline.
  final Widget child;

  /// Called when the link is tapped; `null` renders it inert.
  final VoidCallback? onTap;

  /// When the underline is drawn.
  final VLinkUnderline underline;

  /// Color role of the link.
  final VLinkColor color;

  /// Label announced by screen readers instead of the child's own text.
  final String? semanticLabel;

  /// Per-instance style override merged over the theme's [VLinkStyle].
  final VLinkStyle? style;

  @override
  State<VLink> createState() => _VLinkState();
}

class _VLinkState extends State<VLink> {
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
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  Color _getColor(VColors colors) {
    switch (widget.color) {
      case VLinkColor.primary:
        return colors.primary;
      case VLinkColor.secondary:
        return colors.mutedForeground;
      case VLinkColor.inherit:
        return DefaultTextStyle.of(context).style.color ?? colors.foreground;
    }
  }

  Color _getHoverColor(VColors colors) {
    switch (widget.color) {
      case VLinkColor.primary:
        return colors.primary.withValues(alpha: 0.8);
      case VLinkColor.secondary:
        return colors.foreground;
      case VLinkColor.inherit:
        return DefaultTextStyle.of(context).style.color ?? colors.foreground;
    }
  }

  TextDecoration? _getDecoration() {
    switch (widget.underline) {
      case VLinkUnderline.always:
        return TextDecoration.underline;
      case VLinkUnderline.hover:
        return _isHovered ? TextDecoration.underline : TextDecoration.none;
      case VLinkUnderline.none:
        return TextDecoration.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VLinkStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    var color = _isHovered ? _getHoverColor(colors) : _getColor(colors);
    final decoration = _getDecoration();

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      if (_isHovered) {
        color =
            resolvedStyle.hoverColor ?? resolvedStyle.foregroundColor ?? color;
      } else {
        color = resolvedStyle.foregroundColor ?? color;
      }
    }

    final textStyle = (resolvedStyle?.textStyle ?? const TextStyle()).copyWith(
      color: color,
      decoration: decoration,
      decorationColor: color,
    );

    var content = DefaultTextStyle.merge(
      style: textStyle,
      child: IconTheme.merge(
        data: IconThemeData(color: color),
        child: widget.child,
      ),
    );

    // WCAG 2.5.8: Minimum touch target 24x24
    content = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: content,
    );

    content = MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    content = FocusableActionDetector(
      focusNode: _focusNode,
      enabled: widget.onTap != null,
      shortcuts: _activateShortcuts,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.radius.smRadius,
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: content,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    content = Semantics(
      link: true,
      label: widget.semanticLabel,
      child: content,
    );

    return FocusTraversalGroup(child: content);
  }
}
