import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VBadge].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VBadgeStyle implements VComponentStyle {
  const VBadgeStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.textStyle,
    this.borderColor,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  ///
  /// Wins over the color of [textStyle].
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Text style merged over the badge default, so only the fields it sets change.
  ///
  /// The default is the size preset's font size, weight w500 and line height
  /// 1.15 in the variant's foreground color. An instance style's text style
  /// replaces the theme override's.
  final TextStyle? textStyle;

  /// Border color of the outline variant; defaults to the theme border color.
  final Color? borderColor;

  /// Space between the badge edge and its label; defaults to the size preset.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VBadgeStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    Color? borderColor,
    EdgeInsets? padding,
  }) => VBadgeStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    textStyle: textStyle ?? this.textStyle,
    borderColor: borderColor ?? this.borderColor,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBadgeStyle merge(VBadgeStyle? other) {
    if (other == null) return this;
    return VBadgeStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      textStyle: other.textStyle ?? textStyle,
      borderColor: other.borderColor ?? borderColor,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBadgeStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.textStyle == textStyle &&
        other.borderColor == borderColor &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    textStyle,
    borderColor,
    padding,
  );
}
