import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VBackdrop].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VBackdropStyle implements VComponentStyle {
  const VBackdropStyle({this.color});

  /// Backdrop overlay color.
  final Color? color;

  /// Creates a copy with only the specified properties changed.
  VBackdropStyle copyWith({Color? color}) =>
      VBackdropStyle(color: color ?? this.color);

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBackdropStyle merge(VBackdropStyle? other) {
    if (other == null) return this;
    return VBackdropStyle(color: other.color ?? color);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBackdropStyle && other.color == color;
  }

  @override
  int get hashCode => color.hashCode;
}
