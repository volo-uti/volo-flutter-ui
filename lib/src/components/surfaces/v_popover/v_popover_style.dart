import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VPopover].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VPopoverStyle implements VComponentStyle {
  const VPopoverStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.shadows,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Shadows under the popover panel; the theme's medium shadow when null.
  ///
  /// An empty list draws no shadow. An instance style wins over the theme
  /// override.
  final List<BoxShadow>? shadows;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VPopoverStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    EdgeInsets? padding,
  }) => VPopoverStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VPopoverStyle merge(VPopoverStyle? other) {
    if (other == null) return this;
    return VPopoverStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPopoverStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        listEquals(other.shadows, shadows) &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    shadows == null ? null : Object.hashAll(shadows!),
    padding,
  );
}
