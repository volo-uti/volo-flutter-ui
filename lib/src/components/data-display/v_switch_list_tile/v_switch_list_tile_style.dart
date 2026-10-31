import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSwitchListTile].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSwitchListTileStyle implements VComponentStyle {
  const VSwitchListTileStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.activeColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Switch active color.
  final Color? activeColor;

  /// Creates a copy with only the specified properties changed.
  VSwitchListTileStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? activeColor,
  }) => VSwitchListTileStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    activeColor: activeColor ?? this.activeColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSwitchListTileStyle merge(VSwitchListTileStyle? other) {
    if (other == null) return this;
    return VSwitchListTileStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      activeColor: other.activeColor ?? activeColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSwitchListTileStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.activeColor == activeColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    padding,
    activeColor,
  );
}
