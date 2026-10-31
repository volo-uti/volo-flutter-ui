import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VBorderStyle', () {
    test('lerp() interpolates between two styles', () {
      const a = VBorderStyle(color: Color(0xFF000000), width: 1);
      const b = VBorderStyle(color: Color(0xFFFFFFFF), width: 3);
      final mid = VBorderStyle.lerp(a, b, 0.5);

      expect(mid.width, 2);
    });

    test('identical styles are equal', () {
      const a = VBorderStyle(color: Color(0xFF000000), width: 1);
      const b = VBorderStyle(color: Color(0xFF000000), width: 1);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('VBorders', () {
    test('light has all 3 border styles', () {
      final borders = VBorders.light;

      expect(borders.defaultBorder.width, 1);
      expect(borders.strong.width, 1);
      expect(borders.subtle.width, 1);
    });

    test('dark has all 3 border styles', () {
      final borders = VBorders.dark;

      expect(borders.defaultBorder.width, 1);
      expect(borders.strong.width, 1);
      expect(borders.subtle.width, 1);
    });

    test('light and dark have different colors', () {
      final light = VBorders.light;
      final dark = VBorders.dark;

      expect(light.defaultBorder.color, isNot(dark.defaultBorder.color));
    });

    test('copyWith() changes only some properties', () {
      final original = VBorders.light;
      const newBorder = VBorderStyle(color: Color(0xFFFF0000), width: 2);
      final modified = original.copyWith(strong: newBorder);

      expect(modified.strong, newBorder);
      expect(modified.defaultBorder, original.defaultBorder);
      expect(modified.subtle, original.subtle);
    });

    test('lerp() interpolates between two borders', () {
      final mid = VBorders.lerp(VBorders.light, VBorders.dark, 0.5);

      expect(mid.defaultBorder, isNotNull);
      expect(mid.strong, isNotNull);
      expect(mid.subtle, isNotNull);
    });

    test('identical borders are equal', () {
      final a = VBorders.light;
      final b = VBorders.light;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different borders are not equal', () {
      final light = VBorders.light;
      final dark = VBorders.dark;

      expect(light, isNot(dark));
    });
  });
}
