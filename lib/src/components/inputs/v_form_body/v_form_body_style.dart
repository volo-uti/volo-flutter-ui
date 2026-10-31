import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormBody].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormBodyStyle implements VComponentStyle {
  const VFormBodyStyle({this.spacing, this.padding});

  /// Spacing between fields.
  final double? spacing;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VFormBodyStyle copyWith({double? spacing, EdgeInsets? padding}) =>
      VFormBodyStyle(
        spacing: spacing ?? this.spacing,
        padding: padding ?? this.padding,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormBodyStyle merge(VFormBodyStyle? other) {
    if (other == null) return this;
    return VFormBodyStyle(
      spacing: other.spacing ?? spacing,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormBodyStyle &&
        other.spacing == spacing &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(spacing, padding);
}
