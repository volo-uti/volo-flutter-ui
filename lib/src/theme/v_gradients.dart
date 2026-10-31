import 'package:flutter/widgets.dart';

import 'v_gradients.generated.dart';

/// Brand and surface gradients.
///
/// Defines consistent gradient styles used throughout the app.
@immutable
class VGradients {
  /// Creates gradient tokens.
  const VGradients({required this.brand, required this.surface});

  /// Interpolates between two gradient systems (for animations).
  VGradients.lerp(VGradients a, VGradients b, double t)
    : brand = LinearGradient.lerp(a.brand, b.brand, t)!,
      surface = LinearGradient.lerp(a.surface, b.surface, t)!;

  /// Brand gradient (indigo to cyan, for hero sections).
  final LinearGradient brand;

  /// Surface gradient (subtle background variation).
  final LinearGradient surface;

  /// Default gradients.
  ///
  /// Values sourced from DTCG tokens via [VGradientsDefaults].
  static final VGradients defaults = VGradients(
    brand: VGradientsDefaults.defaults.brand,
    surface: VGradientsDefaults.defaults.surface,
  );

  /// Creates a copy with only the specified properties changed.
  VGradients copyWith({LinearGradient? brand, LinearGradient? surface}) =>
      VGradients(brand: brand ?? this.brand, surface: surface ?? this.surface);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VGradients &&
        other.brand == brand &&
        other.surface == surface;
  }

  @override
  int get hashCode => Object.hash(brand, surface);
}
