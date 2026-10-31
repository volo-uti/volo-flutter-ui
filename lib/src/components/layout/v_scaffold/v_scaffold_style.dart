import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VScaffold].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VScaffoldStyle implements VComponentStyle {
  const VScaffoldStyle({
    this.backgroundColor,
    this.drawerBackgroundColor,
    this.bottomNavBackgroundColor,
  });

  /// Background fill color for the scaffold body.
  final Color? backgroundColor;

  /// Background color for the drawer.
  final Color? drawerBackgroundColor;

  /// Background color for the bottom navigation bar.
  final Color? bottomNavBackgroundColor;

  /// Creates a copy with only the specified properties changed.
  VScaffoldStyle copyWith({
    Color? backgroundColor,
    Color? drawerBackgroundColor,
    Color? bottomNavBackgroundColor,
  }) => VScaffoldStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    drawerBackgroundColor: drawerBackgroundColor ?? this.drawerBackgroundColor,
    bottomNavBackgroundColor:
        bottomNavBackgroundColor ?? this.bottomNavBackgroundColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VScaffoldStyle merge(VScaffoldStyle? other) {
    if (other == null) return this;
    return VScaffoldStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      drawerBackgroundColor:
          other.drawerBackgroundColor ?? drawerBackgroundColor,
      bottomNavBackgroundColor:
          other.bottomNavBackgroundColor ?? bottomNavBackgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VScaffoldStyle &&
        other.backgroundColor == backgroundColor &&
        other.drawerBackgroundColor == drawerBackgroundColor &&
        other.bottomNavBackgroundColor == bottomNavBackgroundColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    drawerBackgroundColor,
    bottomNavBackgroundColor,
  );
}
