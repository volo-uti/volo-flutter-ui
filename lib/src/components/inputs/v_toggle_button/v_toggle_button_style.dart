import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VToggleButton] and [VToggleButtonGroup].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VToggleButtonStyle implements VComponentStyle {
  const VToggleButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.trackColor,
    this.trackPadding,
    this.textStyle,
    this.selectedTextStyle,
  });

  /// Background of an unselected button or group option, hovered or not.
  final Color? backgroundColor;

  /// Text and icon color of an unselected button or group option.
  final Color? foregroundColor;

  /// Background of a selected button or group option.
  final Color? selectedBackgroundColor;

  /// Text and icon color of a selected button or group option.
  final Color? selectedForegroundColor;

  /// Border color of a single button, or of the outline around a group.
  final Color? borderColor;

  /// Corner radius of a single button, or of the outer corners of a group.
  final BorderRadius? borderRadius;

  /// Padding inside a single button or a group option.
  final EdgeInsets? padding;

  /// Fill of the strip behind a group's options; none when null.
  ///
  /// Set it to draw a track that the selected option sits on.
  final Color? trackColor;

  /// Gap between a group's edge and its options, so the selected pill floats.
  ///
  /// Null keeps the options filling the group edge to edge.
  final EdgeInsets? trackPadding;

  /// Text style merged over the default of an unselected button or option.
  final TextStyle? textStyle;

  /// Text style merged over the default of a selected button or option.
  final TextStyle? selectedTextStyle;

  /// Creates a copy with only the specified properties changed.
  VToggleButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? trackColor,
    EdgeInsets? trackPadding,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
  }) => VToggleButtonStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedBackgroundColor:
        selectedBackgroundColor ?? this.selectedBackgroundColor,
    selectedForegroundColor:
        selectedForegroundColor ?? this.selectedForegroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    trackColor: trackColor ?? this.trackColor,
    trackPadding: trackPadding ?? this.trackPadding,
    textStyle: textStyle ?? this.textStyle,
    selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VToggleButtonStyle merge(VToggleButtonStyle? other) {
    if (other == null) return this;
    return VToggleButtonStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      selectedBackgroundColor:
          other.selectedBackgroundColor ?? selectedBackgroundColor,
      selectedForegroundColor:
          other.selectedForegroundColor ?? selectedForegroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      trackColor: other.trackColor ?? trackColor,
      trackPadding: other.trackPadding ?? trackPadding,
      textStyle: other.textStyle ?? textStyle,
      selectedTextStyle: other.selectedTextStyle ?? selectedTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VToggleButtonStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedForegroundColor == selectedForegroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.trackColor == trackColor &&
        other.trackPadding == trackPadding &&
        other.textStyle == textStyle &&
        other.selectedTextStyle == selectedTextStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    selectedBackgroundColor,
    selectedForegroundColor,
    borderColor,
    borderRadius,
    padding,
    trackColor,
    trackPadding,
    textStyle,
    selectedTextStyle,
  );
}
