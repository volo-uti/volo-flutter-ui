import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VToggleButton].
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
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  final Color? foregroundColor;

  /// Background color when selected.
  final Color? selectedBackgroundColor;

  /// Foreground color when selected.
  final Color? selectedForegroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VToggleButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
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
        other.padding == padding;
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
  );
}
