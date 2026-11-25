import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/components/inputs/v_icon_button/v_icon_button_style.dart';
import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VNumberStepper].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VNumberStepperStyle implements VComponentStyle {
  /// Creates a number stepper style.
  const VNumberStepperStyle({
    this.textStyle,
    this.foregroundColor,
    this.spacing,
    this.valueMinWidth,
    this.buttonStyle,
  });

  /// Text style of the value.
  final TextStyle? textStyle;

  /// Color of the value text.
  final Color? foregroundColor;

  /// Gap between each button and the value.
  final double? spacing;

  /// Minimum width of the value, so the buttons stay put as the digits change.
  final double? valueMinWidth;

  /// Style passed to both buttons.
  final VIconButtonStyle? buttonStyle;

  /// Creates a copy with only the specified properties changed.
  VNumberStepperStyle copyWith({
    TextStyle? textStyle,
    Color? foregroundColor,
    double? spacing,
    double? valueMinWidth,
    VIconButtonStyle? buttonStyle,
  }) => VNumberStepperStyle(
    textStyle: textStyle ?? this.textStyle,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    spacing: spacing ?? this.spacing,
    valueMinWidth: valueMinWidth ?? this.valueMinWidth,
    buttonStyle: buttonStyle ?? this.buttonStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VNumberStepperStyle merge(VNumberStepperStyle? other) {
    if (other == null) return this;
    return VNumberStepperStyle(
      textStyle: other.textStyle ?? textStyle,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      spacing: other.spacing ?? spacing,
      valueMinWidth: other.valueMinWidth ?? valueMinWidth,
      buttonStyle: buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VNumberStepperStyle &&
        other.textStyle == textStyle &&
        other.foregroundColor == foregroundColor &&
        other.spacing == spacing &&
        other.valueMinWidth == valueMinWidth &&
        other.buttonStyle == buttonStyle;
  }

  @override
  int get hashCode => Object.hash(
    textStyle,
    foregroundColor,
    spacing,
    valueMinWidth,
    buttonStyle,
  );
}
