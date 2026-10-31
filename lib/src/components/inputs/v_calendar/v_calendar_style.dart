import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VCalendar].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VCalendarStyle implements VComponentStyle {
  const VCalendarStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedColor,
    this.selectedForegroundColor,
    this.todayColor,
    this.borderRadius,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Selected date background color.
  final Color? selectedColor;

  /// Selected date foreground color.
  final Color? selectedForegroundColor;

  /// Today indicator color.
  final Color? todayColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VCalendarStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedColor,
    Color? selectedForegroundColor,
    Color? todayColor,
    BorderRadius? borderRadius,
  }) => VCalendarStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedColor: selectedColor ?? this.selectedColor,
    selectedForegroundColor:
        selectedForegroundColor ?? this.selectedForegroundColor,
    todayColor: todayColor ?? this.todayColor,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VCalendarStyle merge(VCalendarStyle? other) {
    if (other == null) return this;
    return VCalendarStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      selectedColor: other.selectedColor ?? selectedColor,
      selectedForegroundColor:
          other.selectedForegroundColor ?? selectedForegroundColor,
      todayColor: other.todayColor ?? todayColor,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCalendarStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedColor == selectedColor &&
        other.selectedForegroundColor == selectedForegroundColor &&
        other.todayColor == todayColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    selectedColor,
    selectedForegroundColor,
    todayColor,
    borderRadius,
  );
}
