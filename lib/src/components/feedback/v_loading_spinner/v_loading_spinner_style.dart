import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VLoadingSpinner].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VLoadingSpinnerStyle implements VComponentStyle {
  const VLoadingSpinnerStyle({this.color, this.strokeWidth});

  /// Spinner color.
  final Color? color;

  /// Stroke width.
  final double? strokeWidth;

  /// Creates a copy with only the specified properties changed.
  VLoadingSpinnerStyle copyWith({Color? color, double? strokeWidth}) =>
      VLoadingSpinnerStyle(
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VLoadingSpinnerStyle merge(VLoadingSpinnerStyle? other) {
    if (other == null) return this;
    return VLoadingSpinnerStyle(
      color: other.color ?? color,
      strokeWidth: other.strokeWidth ?? strokeWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VLoadingSpinnerStyle &&
        other.color == color &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode => Object.hash(color, strokeWidth);
}
