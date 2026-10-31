import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VShadows', () {
    test('light has all 6 shadow levels', () {
      final shadows = VShadows.light;

      expect(shadows.xs.length, 1);
      expect(shadows.sm.length, 1);
      expect(shadows.md.length, 1);
      expect(shadows.lg.length, 1);
      expect(shadows.xl.length, 1);
      expect(shadows.glow.length, 1);
    });

    test('dark has all 6 shadow levels', () {
      final shadows = VShadows.dark;

      expect(shadows.xs.length, 1);
      expect(shadows.sm.length, 1);
      expect(shadows.md.length, 1);
      expect(shadows.lg.length, 1);
      expect(shadows.xl.length, 1);
      expect(shadows.glow.length, 1);
    });

    test('md shadow has correct values', () {
      final shadows = VShadows.light;
      final md = shadows.md.first;

      expect(md.blurRadius, 8);
      expect(md.offset, const Offset(0, 4));
    });

    test('shadow levels have increasing blur radius', () {
      final shadows = VShadows.light;

      expect(
        shadows.xs.first.blurRadius,
        lessThan(shadows.sm.first.blurRadius),
      );
      expect(
        shadows.sm.first.blurRadius,
        lessThan(shadows.md.first.blurRadius),
      );
      expect(
        shadows.md.first.blurRadius,
        lessThan(shadows.lg.first.blurRadius),
      );
      expect(
        shadows.lg.first.blurRadius,
        lessThan(shadows.xl.first.blurRadius),
      );
    });

    test('copyWith() changes only some properties', () {
      final original = VShadows.light;
      final modified = original.copyWith(md: [const BoxShadow(blurRadius: 10)]);

      expect(modified.md.first.blurRadius, 10);
      expect(modified.lg, original.lg);
      expect(modified.xs, original.xs);
    });

    test('lerp() interpolates between two shadows', () {
      final mid = VShadows.lerp(VShadows.light, VShadows.dark, 0.5);

      expect(mid.xs, isNotNull);
      expect(mid.sm, isNotNull);
      expect(mid.md, isNotNull);
      expect(mid.lg, isNotNull);
      expect(mid.xl, isNotNull);
      expect(mid.glow, isNotNull);
    });

    test('identical shadows are equal', () {
      final a = VShadows.light;
      final b = VShadows.light;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
