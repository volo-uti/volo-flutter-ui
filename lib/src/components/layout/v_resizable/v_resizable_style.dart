import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VResizable].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VResizableStyle implements VComponentStyle {
  const VResizableStyle({this.handleColor, this.handleSize, this.borderColor});

  /// Resize handle color.
  final Color? handleColor;

  /// Resize handle size.
  final double? handleSize;

  /// Border color.
  final Color? borderColor;

  /// Creates a copy with only the specified properties changed.
  VResizableStyle copyWith({
    Color? handleColor,
    double? handleSize,
    Color? borderColor,
  }) => VResizableStyle(
    handleColor: handleColor ?? this.handleColor,
    handleSize: handleSize ?? this.handleSize,
    borderColor: borderColor ?? this.borderColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VResizableStyle merge(VResizableStyle? other) {
    if (other == null) return this;
    return VResizableStyle(
      handleColor: other.handleColor ?? handleColor,
      handleSize: other.handleSize ?? handleSize,
      borderColor: other.borderColor ?? borderColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VResizableStyle &&
        other.handleColor == handleColor &&
        other.handleSize == handleSize &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(handleColor, handleSize, borderColor);
}
