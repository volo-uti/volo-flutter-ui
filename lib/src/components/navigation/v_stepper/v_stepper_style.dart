import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VStepper].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VStepperStyle implements VComponentStyle {
  const VStepperStyle({
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.errorColor,
    this.connectorColor,
  });

  /// Active step color.
  final Color? activeColor;

  /// Inactive step color.
  final Color? inactiveColor;

  /// Completed step color.
  final Color? completedColor;

  /// Error step color.
  final Color? errorColor;

  /// Connector line color.
  final Color? connectorColor;

  /// Creates a copy with only the specified properties changed.
  VStepperStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? completedColor,
    Color? errorColor,
    Color? connectorColor,
  }) => VStepperStyle(
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    completedColor: completedColor ?? this.completedColor,
    errorColor: errorColor ?? this.errorColor,
    connectorColor: connectorColor ?? this.connectorColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VStepperStyle merge(VStepperStyle? other) {
    if (other == null) return this;
    return VStepperStyle(
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      completedColor: other.completedColor ?? completedColor,
      errorColor: other.errorColor ?? errorColor,
      connectorColor: other.connectorColor ?? connectorColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VStepperStyle &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.completedColor == completedColor &&
        other.errorColor == errorColor &&
        other.connectorColor == connectorColor;
  }

  @override
  int get hashCode => Object.hash(
    activeColor,
    inactiveColor,
    completedColor,
    errorColor,
    connectorColor,
  );
}
