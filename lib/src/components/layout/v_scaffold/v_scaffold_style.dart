import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VScaffold].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VScaffoldStyle implements VComponentStyle {
  const VScaffoldStyle({this.backgroundColor});

  /// Screen background behind the bars and body; the theme background when null.
  ///
  /// [VScaffold.backgroundColor] wins over it, and an instance style wins over
  /// the theme override. The drawers and the bottom navigation paint their own
  /// backgrounds through their own styles.
  final Color? backgroundColor;

  /// Creates a copy with only the specified properties changed.
  VScaffoldStyle copyWith({Color? backgroundColor}) =>
      VScaffoldStyle(backgroundColor: backgroundColor ?? this.backgroundColor);

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VScaffoldStyle merge(VScaffoldStyle? other) {
    if (other == null) return this;
    return VScaffoldStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VScaffoldStyle && other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode;
}
