import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VSpacing', () {
    test('defaults returns default spacing values', () {
      final spacing = VSpacing.defaults;

      expect(spacing.xxs, 2);
      expect(spacing.xs, 4);
      expect(spacing.sm, 8);
      expect(spacing.md, 12);
      expect(spacing.lg, 16);
      expect(spacing.xl, 20);
      expect(spacing.xxl, 24);
      expect(spacing.xxxl, 32);
    });

    test('copyWith() changes only specified properties', () {
      final original = VSpacing.defaults;
      final modified = original.copyWith(md: 20);

      expect(modified.md, 20);
      expect(modified.lg, original.lg);
    });

    test('lerp() interpolates between two spacing values', () {
      final a = VSpacing.defaults;
      final b = a.copyWith(md: 20);
      final mid = VSpacing.lerp(a, b, 0.5);

      expect(mid.md, 16);
    });

    test('identical spacing values are equal', () {
      final a = VSpacing.defaults;
      final b = VSpacing.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
