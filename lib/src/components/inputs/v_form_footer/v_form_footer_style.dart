import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormFooter].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormFooterStyle implements VComponentStyle {
  const VFormFooterStyle({this.padding, this.spacing});

  /// Internal padding.
  final EdgeInsets? padding;

  /// Spacing between footer actions.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VFormFooterStyle copyWith({EdgeInsets? padding, double? spacing}) =>
      VFormFooterStyle(
        padding: padding ?? this.padding,
        spacing: spacing ?? this.spacing,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormFooterStyle merge(VFormFooterStyle? other) {
    if (other == null) return this;
    return VFormFooterStyle(
      padding: other.padding ?? padding,
      spacing: other.spacing ?? spacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormFooterStyle &&
        other.padding == padding &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(padding, spacing);
}
