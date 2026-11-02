import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VChip].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VChipStyle implements VComponentStyle {
  const VChipStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.deleteIconColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  ///
  /// Wins over the color of [textStyle].
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Label text style merged over the chip default, so only the fields it sets change.
  ///
  /// The default is the size preset's font size and line height 1.15 in the
  /// variant's foreground color. An instance style's text style replaces the
  /// theme override's.
  final TextStyle? textStyle;

  /// Delete icon color.
  final Color? deleteIconColor;

  /// Creates a copy with only the specified properties changed.
  VChipStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? deleteIconColor,
  }) => VChipStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    deleteIconColor: deleteIconColor ?? this.deleteIconColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VChipStyle merge(VChipStyle? other) {
    if (other == null) return this;
    return VChipStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      deleteIconColor: other.deleteIconColor ?? deleteIconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VChipStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.deleteIconColor == deleteIconColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    textStyle,
    deleteIconColor,
  );
}
