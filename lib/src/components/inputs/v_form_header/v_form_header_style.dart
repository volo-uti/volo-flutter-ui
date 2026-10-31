import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormHeader].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormHeaderStyle implements VComponentStyle {
  const VFormHeaderStyle({this.titleStyle, this.subtitleStyle, this.padding});

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VFormHeaderStyle copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsets? padding,
  }) => VFormHeaderStyle(
    titleStyle: titleStyle ?? this.titleStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormHeaderStyle merge(VFormHeaderStyle? other) {
    if (other == null) return this;
    return VFormHeaderStyle(
      titleStyle: other.titleStyle ?? titleStyle,
      subtitleStyle: other.subtitleStyle ?? subtitleStyle,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormHeaderStyle &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(titleStyle, subtitleStyle, padding);
}
