import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VLabel].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VLabelStyle implements VComponentStyle {
  const VLabelStyle({this.foregroundColor, this.textStyle, this.requiredColor});

  /// Text foreground color.
  final Color? foregroundColor;

  /// Text style.
  final TextStyle? textStyle;

  /// Required indicator color.
  final Color? requiredColor;

  /// Creates a copy with only the specified properties changed.
  VLabelStyle copyWith({
    Color? foregroundColor,
    TextStyle? textStyle,
    Color? requiredColor,
  }) => VLabelStyle(
    foregroundColor: foregroundColor ?? this.foregroundColor,
    textStyle: textStyle ?? this.textStyle,
    requiredColor: requiredColor ?? this.requiredColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VLabelStyle merge(VLabelStyle? other) {
    if (other == null) return this;
    return VLabelStyle(
      foregroundColor: other.foregroundColor ?? foregroundColor,
      textStyle: other.textStyle ?? textStyle,
      requiredColor: other.requiredColor ?? requiredColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VLabelStyle &&
        other.foregroundColor == foregroundColor &&
        other.textStyle == textStyle &&
        other.requiredColor == requiredColor;
  }

  @override
  int get hashCode => Object.hash(foregroundColor, textStyle, requiredColor);
}
