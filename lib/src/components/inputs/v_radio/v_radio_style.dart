import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VRadio].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VRadioStyle implements VComponentStyle {
  const VRadioStyle({this.activeColor, this.dotColor, this.borderColor});

  /// Fill color when selected.
  final Color? activeColor;

  /// Inner dot color.
  final Color? dotColor;

  /// Border color.
  final Color? borderColor;

  /// Creates a copy with only the specified properties changed.
  VRadioStyle copyWith({
    Color? activeColor,
    Color? dotColor,
    Color? borderColor,
  }) => VRadioStyle(
    activeColor: activeColor ?? this.activeColor,
    dotColor: dotColor ?? this.dotColor,
    borderColor: borderColor ?? this.borderColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VRadioStyle merge(VRadioStyle? other) {
    if (other == null) return this;
    return VRadioStyle(
      activeColor: other.activeColor ?? activeColor,
      dotColor: other.dotColor ?? dotColor,
      borderColor: other.borderColor ?? borderColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VRadioStyle &&
        other.activeColor == activeColor &&
        other.dotColor == dotColor &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(activeColor, dotColor, borderColor);
}
