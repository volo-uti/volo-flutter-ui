import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_label_style.dart';

/// Label size.
enum VLabelSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// Label for a form field with an optional required mark.
///
/// Plain `Text` children are drawn in the label's size and weight.
///
/// ```dart
/// VLabel(
///   required: true,
///   child: Text('Password'),
/// )
/// ```
///
/// See also:
///
/// - [VFormField] - Complete form field wrapper with label, input, and footer.
class VLabel extends StatelessWidget {
  /// Creates a label around [child].
  const VLabel({
    required this.child,
    super.key,
    this.required = false,
    this.size = VLabelSize.md,
    this.requiredMark = '*',
    this.style,
  });

  /// Content of the label; plain `Text` takes the label style.
  final Widget child;

  /// Whether the required mark is shown after [child].
  final bool required;

  /// Font size preset.
  final VLabelSize size;

  /// Text of the required mark.
  final String requiredMark;

  /// Per-instance style override merged over the theme's [VLabelStyle].
  final VLabelStyle? style;

  double _getFontSize(VSizes sizes) {
    switch (size) {
      case VLabelSize.sm:
        return sizes.sm.fontSize;
      case VLabelSize.md:
        return sizes.md.fontSize;
      case VLabelSize.lg:
        return sizes.lg.fontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VLabelStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;

    final colors = theme.colors;
    final fontSize = _getFontSize(theme.sizes);

    var foregroundColor = colors.foreground;
    var requiredColor = colors.error;

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      foregroundColor = resolvedStyle.foregroundColor ?? foregroundColor;
      requiredColor = resolvedStyle.requiredColor ?? requiredColor;
    }

    final textStyle = (resolvedStyle?.textStyle ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
      height: 1,
    );

    return DefaultTextStyle(
      style: textStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (required)
            Padding(
              padding: EdgeInsets.only(left: theme.spacing.xxs),
              child: Text(
                requiredMark,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: requiredColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
