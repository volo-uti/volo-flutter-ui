import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VListTile].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VListTileStyle implements VComponentStyle {
  const VListTileStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedColor,
    this.borderRadius,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Selected state color.
  final Color? selectedColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Creates a copy with only the specified properties changed.
  VListTileStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) => VListTileStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedColor: selectedColor ?? this.selectedColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VListTileStyle merge(VListTileStyle? other) {
    if (other == null) return this;
    return VListTileStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      selectedColor: other.selectedColor ?? selectedColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      titleStyle: other.titleStyle ?? titleStyle,
      subtitleStyle: other.subtitleStyle ?? subtitleStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VListTileStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedColor == selectedColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    selectedColor,
    borderRadius,
    padding,
    titleStyle,
    subtitleStyle,
  );
}
