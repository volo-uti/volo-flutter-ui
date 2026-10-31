import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VScrollArea].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VScrollAreaStyle implements VComponentStyle {
  const VScrollAreaStyle({
    this.scrollbarColor,
    this.scrollbarRadius,
    this.scrollbarThickness,
  });

  /// Scrollbar thumb color.
  final Color? scrollbarColor;

  /// Scrollbar corner radius.
  final BorderRadius? scrollbarRadius;

  /// Scrollbar thickness.
  final double? scrollbarThickness;

  /// Creates a copy with only the specified properties changed.
  VScrollAreaStyle copyWith({
    Color? scrollbarColor,
    BorderRadius? scrollbarRadius,
    double? scrollbarThickness,
  }) => VScrollAreaStyle(
    scrollbarColor: scrollbarColor ?? this.scrollbarColor,
    scrollbarRadius: scrollbarRadius ?? this.scrollbarRadius,
    scrollbarThickness: scrollbarThickness ?? this.scrollbarThickness,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VScrollAreaStyle merge(VScrollAreaStyle? other) {
    if (other == null) return this;
    return VScrollAreaStyle(
      scrollbarColor: other.scrollbarColor ?? scrollbarColor,
      scrollbarRadius: other.scrollbarRadius ?? scrollbarRadius,
      scrollbarThickness: other.scrollbarThickness ?? scrollbarThickness,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VScrollAreaStyle &&
        other.scrollbarColor == scrollbarColor &&
        other.scrollbarRadius == scrollbarRadius &&
        other.scrollbarThickness == scrollbarThickness;
  }

  @override
  int get hashCode =>
      Object.hash(scrollbarColor, scrollbarRadius, scrollbarThickness);
}
