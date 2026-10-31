import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VGrid].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VGridStyle implements VComponentStyle {
  const VGridStyle({this.spacing});

  /// Spacing between grid items.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VGridStyle copyWith({double? spacing}) =>
      VGridStyle(spacing: spacing ?? this.spacing);

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VGridStyle merge(VGridStyle? other) {
    if (other == null) return this;
    return VGridStyle(spacing: other.spacing ?? spacing);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VGridStyle && other.spacing == spacing;
  }

  @override
  int get hashCode => spacing.hashCode;
}
