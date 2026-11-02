import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VImage].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VImageStyle implements VComponentStyle {
  const VImageStyle({this.borderRadius, this.backgroundColor});

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Fill behind the image box; none when null.
  ///
  /// It shows while the image loads, after an error and through transparent
  /// pixels, clipped to the corner radius. An instance style wins over the
  /// theme override.
  final Color? backgroundColor;

  /// Creates a copy with only the specified properties changed.
  VImageStyle copyWith({BorderRadius? borderRadius, Color? backgroundColor}) =>
      VImageStyle(
        borderRadius: borderRadius ?? this.borderRadius,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VImageStyle merge(VImageStyle? other) {
    if (other == null) return this;
    return VImageStyle(
      borderRadius: other.borderRadius ?? borderRadius,
      backgroundColor: other.backgroundColor ?? backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VImageStyle &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => Object.hash(borderRadius, backgroundColor);
}
