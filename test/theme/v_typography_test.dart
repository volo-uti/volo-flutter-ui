import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VTypography', () {
    test('defaults returns default typography', () {
      const typography = VTypography.defaults;

      expect(typography.displayLarge.fontSize, 57);
      expect(typography.bodyMedium.fontSize, 14);
      expect(typography.labelSmall.fontSize, 11);
    });

    test('font family defaults to null (system font fallback)', () {
      const typography = VTypography.defaults;

      expect(typography.fontFamily, isNull);
      expect(typography.fontFamilyMono, isNull);
    });

    test('copyWith() changes only some properties', () {
      const original = VTypography.defaults;
      final modified = original.copyWith(fontFamily: 'Roboto');

      expect(modified.fontFamily, 'Roboto');
      expect(modified.displayLarge, original.displayLarge);
    });

    test('lerp() interpolates between two typographies', () {
      const a = VTypography.defaults;
      const b = VTypography.defaults;
      final mid = VTypography.lerp(a, b, 0.5);

      expect(mid.bodyMedium.fontSize, 14);
    });

    test('identical typographies are equal', () {
      const a = VTypography.defaults;
      const b = VTypography.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
