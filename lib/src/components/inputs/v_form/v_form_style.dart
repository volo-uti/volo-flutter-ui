import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VForm].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormStyle implements VComponentStyle {
  const VFormStyle({this.spacing});

  /// Spacing between form fields.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VFormStyle copyWith({double? spacing}) =>
      VFormStyle(spacing: spacing ?? this.spacing);

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormStyle merge(VFormStyle? other) {
    if (other == null) return this;
    return VFormStyle(spacing: other.spacing ?? spacing);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormStyle && other.spacing == spacing;
  }

  @override
  int get hashCode => spacing.hashCode;
}
