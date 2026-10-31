import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VStack].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VStackStyle implements VComponentStyle {
  const VStackStyle({this.spacing});

  /// Spacing between children.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VStackStyle copyWith({double? spacing}) =>
      VStackStyle(spacing: spacing ?? this.spacing);

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VStackStyle merge(VStackStyle? other) {
    if (other == null) return this;
    return VStackStyle(spacing: other.spacing ?? spacing);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VStackStyle && other.spacing == spacing;
  }

  @override
  int get hashCode => spacing.hashCode;
}
