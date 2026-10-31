import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_form_body_style.dart';

/// Form body type.
enum VFormBodyType {
  /// Border only.
  outlined,

  /// Filled background.
  filled,

  /// Bottom border only.
  underline,
}

/// Form body color.
enum VFormBodyColor {
  /// Primary color.
  primary,

  /// Secondary color.
  secondary,

  /// Destructive/delete color.
  destructive,
}

/// Form body size.
enum VFormBodySize {
  /// Small size (32px).
  sm,

  /// Medium size (40px).
  md,

  /// Large size (48px).
  lg,
}

/// Form body corner.
enum VFormBodyCorner {
  /// Square corners.
  square,

  /// Rounded corners (default).
  rounded,

  /// Pill shape.
  pill,
}

/// Bordered box that frames a form control, with leading and trailing slots.
///
/// [VFormField] wraps one around its child; use it directly for custom controls.
///
/// **Basic Usage:**
///
/// ```dart
/// VFormBody(
///   child: EditableText(...),
/// )
/// ```
///
/// **With Leading/Trailing:**
///
/// ```dart
/// VFormBody(
///   leading: Text('\$'),
///   trailing: Text('USD'),
///   child: EditableText(...),
/// )
/// ```
///
/// **Types:** [VFormBodyType.outlined], [VFormBodyType.filled], [VFormBodyType.underline]
///
/// See also:
/// - [VFormField] - Header + Body + Footer composition
class VFormBody extends StatefulWidget {
  /// Creates a form body.
  const VFormBody({
    required this.child,
    super.key,
    this.leading,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.enabled = true,
    this.readOnly = false,
    this.focused = false,
    this.error = false,
    this.success = false,
    this.style,
  });

  /// The control drawn inside the box.
  final Widget child;

  /// Widget shown before [child].
  final Widget? leading;

  /// Widget shown after [child].
  final Widget? trailing;

  /// Visual type: outlined, filled or underline.
  final VFormBodyType type;

  /// Accent color used for focus and borders.
  final VFormBodyColor color;

  /// Height preset.
  final VFormBodySize size;

  /// Corner shape.
  final VFormBodyCorner corner;

  /// Whether the box stretches to the available width.
  final bool fullWidth;

  /// Whether the body accepts pointer input. When false it is dimmed and ignores taps.
  final bool enabled;

  /// Whether the box is drawn in its read-only look.
  final bool readOnly;

  /// Whether the box is drawn with its focus ring.
  final bool focused;

  /// Whether the box is drawn with the error border.
  final bool error;

  /// Whether the box is drawn with the success border.
  final bool success;

  /// Style override.
  final VFormBodyStyle? style;

  @override
  State<VFormBody> createState() => _VFormBodyState();
}

class _VFormBodyState extends State<VFormBody> {
  Color _getCurrentBorderColor() {
    final theme = VTheme.of(context);
    final colors = theme.colors;

    if (!widget.enabled) return colors.muted;
    if (widget.error) return colors.destructive;
    if (widget.success) return colors.success;
    if (widget.focused) {
      switch (widget.color) {
        case VFormBodyColor.primary:
          return colors.primary;
        case VFormBodyColor.secondary:
          return colors.secondary;
        case VFormBodyColor.destructive:
          return colors.destructive;
      }
    }
    return colors.input;
  }

  double _getHeight() {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VFormBodySize.sm => theme.sizes.sm.height,
      VFormBodySize.md => theme.sizes.md.height,
      VFormBodySize.lg => theme.sizes.lg.height,
    };
  }

  EdgeInsets _getPadding() {
    final sizes = VTheme.of(context).sizes;
    final paddingH = switch (widget.size) {
      VFormBodySize.sm => sizes.sm.paddingHorizontal,
      VFormBodySize.md => sizes.md.paddingHorizontal,
      VFormBodySize.lg => sizes.lg.paddingHorizontal,
    };
    return EdgeInsets.symmetric(horizontal: paddingH);
  }

  BorderRadiusGeometry _getBorderRadius() {
    final theme = VTheme.of(context);

    switch (widget.corner) {
      case VFormBodyCorner.square:
        return BorderRadius.zero;
      case VFormBodyCorner.rounded:
        final sizeToken = switch (widget.size) {
          VFormBodySize.sm => theme.sizes.sm,
          VFormBodySize.md => theme.sizes.md,
          VFormBodySize.lg => theme.sizes.lg,
        };
        return BorderRadius.circular(sizeToken.borderRadius);
      case VFormBodyCorner.pill:
        return BorderRadius.circular(_getHeight() / 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFormBodyStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;

    final borderColor = _getCurrentBorderColor();
    final borderRadius = _getBorderRadius();
    final effectivePadding = resolvedStyle?.padding ?? _getPadding();

    // Background color
    Color? backgroundColor;
    if (widget.type == VFormBodyType.filled) {
      backgroundColor = colors.muted.withValues(alpha: 0.3);
    }

    // Border
    Border? border;
    switch (widget.type) {
      case VFormBodyType.outlined:
        border = Border.all(color: borderColor, width: widget.focused ? 2 : 1);
        break;
      case VFormBodyType.filled:
        border = null;
        break;
      case VFormBodyType.underline:
        border = Border(
          bottom: BorderSide(color: borderColor, width: widget.focused ? 2 : 1),
        );
        break;
    }

    final Widget content = Row(
      children: [
        if (widget.leading != null)
          Padding(
            padding: EdgeInsets.only(right: theme.spacing.sm),
            child: widget.leading,
          ),
        Expanded(child: widget.child),
        if (widget.trailing != null)
          Padding(
            padding: EdgeInsets.only(left: theme.spacing.sm),
            child: widget.trailing,
          ),
      ],
    );

    return FocusTraversalGroup(
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Container(
            height: _getHeight(),
            width: widget.fullWidth ? double.infinity : null,
            padding: effectivePadding,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: widget.type == VFormBodyType.underline
                  ? null
                  : borderRadius,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
