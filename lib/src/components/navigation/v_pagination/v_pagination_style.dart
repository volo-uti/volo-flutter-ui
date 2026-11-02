import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VPagination].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VPaginationStyle implements VComponentStyle {
  const VPaginationStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.borderColor,
    this.borderRadius,
  });

  /// Fill of the page and arrow buttons other than the current page; none when null.
  ///
  /// The current page takes [activeBackgroundColor]. The text buttons of the
  /// simple and minimal variants have no fill. An instance style wins over the
  /// theme override.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Active page background color.
  final Color? activeBackgroundColor;

  /// Active page foreground color.
  final Color? activeForegroundColor;

  /// Border around each page and arrow button; no border when null.
  ///
  /// The focus ring replaces it on the focused button. The text buttons of the
  /// simple and minimal variants have no border. An instance style wins over
  /// the theme override.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VPaginationStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? activeBackgroundColor,
    Color? activeForegroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
  }) => VPaginationStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    activeBackgroundColor: activeBackgroundColor ?? this.activeBackgroundColor,
    activeForegroundColor: activeForegroundColor ?? this.activeForegroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VPaginationStyle merge(VPaginationStyle? other) {
    if (other == null) return this;
    return VPaginationStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      activeBackgroundColor:
          other.activeBackgroundColor ?? activeBackgroundColor,
      activeForegroundColor:
          other.activeForegroundColor ?? activeForegroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPaginationStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.activeBackgroundColor == activeBackgroundColor &&
        other.activeForegroundColor == activeForegroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    activeBackgroundColor,
    activeForegroundColor,
    borderColor,
    borderRadius,
  );
}
