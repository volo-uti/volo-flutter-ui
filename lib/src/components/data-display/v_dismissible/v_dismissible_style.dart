import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VDismissible].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VDismissibleStyle implements VComponentStyle {
  const VDismissibleStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  /// Fill of the default background; defaults to the destructive color.
  final Color? backgroundColor;

  /// Text color of the default background; defaults to destructiveForeground.
  final Color? foregroundColor;

  /// Space between the edge and the label of the default background.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VDismissibleStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsets? padding,
  }) => VDismissibleStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VDismissibleStyle merge(VDismissibleStyle? other) {
    if (other == null) return this;
    return VDismissibleStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VDismissibleStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(backgroundColor, foregroundColor, padding);
}
