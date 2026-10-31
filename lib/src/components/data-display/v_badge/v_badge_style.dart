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
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Text style.
  final TextStyle? textStyle;

  /// Creates a copy with only the specified properties changed.
  VBadgeStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
  }) => VBadgeStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    textStyle: textStyle ?? this.textStyle,
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBadgeStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode =>
      Object.hash(backgroundColor, foregroundColor, borderRadius, textStyle);
}
