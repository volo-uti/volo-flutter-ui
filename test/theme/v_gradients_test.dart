import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VGradients', () {
    test('defaults has brand and surface gradients', () {
      final gradients = VGradients.defaults;

      expect(gradients.brand.colors.length, 2);
      expect(gradients.surface.colors.length, 2);
    });

    test('brand gradient is indigo to cyan', () {
      final gradients = VGradients.defaults;

      expect(gradients.brand.begin, Alignment.topLeft);
      expect(gradients.brand.end, Alignment.bottomRight);
    });

    test('surface gradient is vertical', () {
      final gradients = VGradients.defaults;

      expect(gradients.surface.begin, Alignment.topCenter);
      expect(gradients.surface.end, Alignment.bottomCenter);
    });

    test('copyWith() changes only some properties', () {
      final original = VGradients.defaults;
      const newGradient = LinearGradient(
        colors: [Color(0xFFFF0000), Color(0xFF0000FF)],
      );
      final modified = original.copyWith(brand: newGradient);

      expect(modified.brand, newGradient);
      expect(modified.surface, original.surface);
    });

    test('lerp() interpolates between two gradients', () {
      final a = VGradients.defaults;
      final b = a.copyWith(
        brand: const LinearGradient(
          colors: [Color(0xFFFF0000), Color(0xFF0000FF)],
        ),
      );
      final mid = VGradients.lerp(a, b, 0.5);

      expect(mid.brand, isNotNull);
      expect(mid.surface, isNotNull);
    });

    test('identical gradients are equal', () {
      final a = VGradients.defaults;
      final b = VGradients.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
