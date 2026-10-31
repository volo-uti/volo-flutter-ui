import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSwitch].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSwitchStyle implements VComponentStyle {
  const VSwitchStyle({
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.activeThumbColor,
  });

  /// Track color when active.
  final Color? activeTrackColor;

  /// Track color when inactive.
  final Color? inactiveTrackColor;

  /// Thumb color (inactive state).
  final Color? thumbColor;

  /// Thumb color when active.
  final Color? activeThumbColor;

  /// Creates a copy with only the specified properties changed.
  VSwitchStyle copyWith({
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? thumbColor,
    Color? activeThumbColor,
  }) => VSwitchStyle(
    activeTrackColor: activeTrackColor ?? this.activeTrackColor,
    inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
    thumbColor: thumbColor ?? this.thumbColor,
    activeThumbColor: activeThumbColor ?? this.activeThumbColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSwitchStyle merge(VSwitchStyle? other) {
    if (other == null) return this;
    return VSwitchStyle(
      activeTrackColor: other.activeTrackColor ?? activeTrackColor,
      inactiveTrackColor: other.inactiveTrackColor ?? inactiveTrackColor,
      thumbColor: other.thumbColor ?? thumbColor,
      activeThumbColor: other.activeThumbColor ?? activeThumbColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSwitchStyle &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.thumbColor == thumbColor &&
        other.activeThumbColor == activeThumbColor;
  }

  @override
  int get hashCode => Object.hash(
    activeTrackColor,
    inactiveTrackColor,
    thumbColor,
    activeThumbColor,
  );
}
