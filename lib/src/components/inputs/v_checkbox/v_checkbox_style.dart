import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VCheckbox].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VCheckboxStyle implements VComponentStyle {
  const VCheckboxStyle({
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderRadius,
  });

  /// Fill color when checked.
  final Color? activeColor;

  /// Check mark color.
  final Color? checkColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VCheckboxStyle copyWith({
    Color? activeColor,
    Color? checkColor,
    Color? borderColor,
    BorderRadius? borderRadius,
  }) => VCheckboxStyle(
    activeColor: activeColor ?? this.activeColor,
    checkColor: checkColor ?? this.checkColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VCheckboxStyle merge(VCheckboxStyle? other) {
    if (other == null) return this;
    return VCheckboxStyle(
      activeColor: other.activeColor ?? activeColor,
      checkColor: other.checkColor ?? checkColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCheckboxStyle &&
        other.activeColor == activeColor &&
        other.checkColor == checkColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, checkColor, borderColor, borderRadius);
}
