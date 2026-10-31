import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

// WHY: Dedicated style class per component (not shared) — each component
// has its own visual vocabulary (e.g. VCommand has inputTextStyle that
// VMenu does not). Sharing would require unused fields and lose type safety
// in the VComponentOverrides.get<T>() lookup.
/// Style override for [VCommand].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VCommandStyle implements VComponentStyle {
  const VCommandStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.inputTextStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Search input text style.
  final TextStyle? inputTextStyle;

  /// Creates a copy with only the specified properties changed.
  VCommandStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? inputTextStyle,
  }) => VCommandStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    inputTextStyle: inputTextStyle ?? this.inputTextStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VCommandStyle merge(VCommandStyle? other) {
    if (other == null) return this;
    return VCommandStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
      inputTextStyle: other.inputTextStyle ?? inputTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCommandStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.inputTextStyle == inputTextStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    elevation,
    padding,
    inputTextStyle,
  );
}
