import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VApp].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAppStyle implements VComponentStyle {
  const VAppStyle({this.backgroundColor, this.foregroundColor});

  /// Background fill color for the app.
  final Color? backgroundColor;

  /// Default text/foreground color.
  final Color? foregroundColor;

  /// Creates a copy with only the specified properties changed.
  VAppStyle copyWith({Color? backgroundColor, Color? foregroundColor}) =>
      VAppStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
      );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAppStyle merge(VAppStyle? other) {
    if (other == null) return this;
    return VAppStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAppStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => Object.hash(backgroundColor, foregroundColor);
}
