import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_form_header_style.dart';

/// Label row above a form control, with required mark, tooltip and side note.
///
/// [VFormField] builds one for you; use it directly only to label a custom control.
///
/// **Basic Usage:**
///
/// ```dart
/// VFormHeader(
///   label: 'Email',
///   required: true,
///   child: VFormBody(...),
/// )
/// ```
///
/// **With Tooltip:**
///
/// ```dart
/// VFormHeader(
///   label: 'Password',
///   tooltip: Text('?'),
///   child: VFormBody(...),
/// )
/// ```
///
/// See also:
/// - [VFormField] - Header + Body + Footer composition
class VFormHeader extends StatefulWidget {
  /// Creates a form header.
  const VFormHeader({
    required this.child,
    super.key,
    this.label,
    this.more,
    this.required = false,
    this.requiredMark = '*',
    this.tooltip,
    this.floatingLabel = false,
    this.style,
  });

  /// The control the label belongs to.
  final Widget child;

  /// Label text. No header is drawn when null.
  ///
  /// A label too long for the row wraps onto more lines.
  final String? label;

  /// Note shown at the right end of the label row.
  final String? more;

  /// Whether to show [requiredMark] after the label.
  final bool required;

  /// Character shown after the label when [required] is true.
  final String requiredMark;

  /// Widget shown next to the label, typically a help icon.
  final Widget? tooltip;

  /// Whether the label floats over the top edge of [child] instead of sitting above it.
  final bool floatingLabel;

  /// Style override merged over the theme's [VFormHeaderStyle].
  final VFormHeaderStyle? style;

  @override
  State<VFormHeader> createState() => _VFormHeaderState();
}

class _VFormHeaderState extends State<VFormHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFormHeaderStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    final label = widget.label;

    // WHY: Every branch keeps the child at the same place in the same kind of
    // parent, so the control is not rebuilt (and its text input connection
    // not closed) when the label appears or goes away.
    if (label == null) {
      return widget.floatingLabel
          ? Stack(
              clipBehavior: Clip.none,
              children: [widget.child, const SizedBox.shrink()],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const SizedBox.shrink(), widget.child],
            );
    }

    // A style's own color wins over the default color.
    final titleStyle = resolvedStyle?.titleStyle;
    final labelStyle = (titleStyle ?? typography.labelMedium).copyWith(
      color: titleStyle?.color ?? colors.foreground,
    );

    final subtitleStyle = resolvedStyle?.subtitleStyle;
    final moreStyle = (subtitleStyle ?? typography.labelSmall).copyWith(
      color: subtitleStyle?.color ?? colors.mutedForeground,
    );

    final requiredStyle = typography.labelMedium.copyWith(
      color: colors.destructive,
    );

    // Label widget composition. The label text is flexible, so a long label
    // wraps and the required mark and tooltip stay next to it.
    final Widget labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Semantics(header: true, child: Text(label, style: labelStyle)),
        ),
        if (widget.required)
          Padding(
            padding: EdgeInsetsDirectional.only(start: theme.spacing.xxs),
            child: Semantics(
              label: VoloLocalizations.of(context).requiredFieldLabel,
              child: Text(widget.requiredMark, style: requiredStyle),
            ),
          ),
        if (widget.tooltip != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: theme.spacing.xs),
            child: widget.tooltip,
          ),
      ],
    );

    // Floating label: sits on the top border of the control, like the legend
    // of a fieldset, so it never covers the text typed inside.
    if (widget.floatingLabel) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          PositionedDirectional(
            start: 12,
            top: 0,
            child: IgnorePointer(
              child: FractionalTranslation(
                translation: const Offset(0, -0.5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
                  color: colors.background,
                  child: labelWidget,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Normal label
    final headerPadding = resolvedStyle?.padding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: headerPadding ?? EdgeInsets.only(bottom: theme.spacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: labelWidget),
              if (widget.more != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(start: theme.spacing.sm),
                  child: Text(widget.more!, style: moreStyle),
                ),
            ],
          ),
        ),
        widget.child,
      ],
    );
  }
}
