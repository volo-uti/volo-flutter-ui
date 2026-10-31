import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VDivider].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VDividerStyle implements VComponentStyle {
  const VDividerStyle({this.color, this.thickness, this.indent});

  /// Divider color.
  final Color? color;

  /// Divider thickness.
  final double? thickness;

  /// Indent from the edges.
  final double? indent;

  /// Creates a copy with only the specified properties changed.
  VDividerStyle copyWith({Color? color, double? thickness, double? indent}) =>
      VDividerStyle(
        color: color ?? this.color,
        thickness: thickness ?? this.thickness,
        indent: indent ?? this.indent,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VDividerStyle merge(VDividerStyle? other) {
    if (other == null) return this;
    return VDividerStyle(
      color: other.color ?? color,
      thickness: other.thickness ?? thickness,
      indent: other.indent ?? indent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VDividerStyle &&
        other.color == color &&
        other.thickness == thickness &&
        other.indent == indent;
  }

  @override
  int get hashCode => Object.hash(color, thickness, indent);
}
