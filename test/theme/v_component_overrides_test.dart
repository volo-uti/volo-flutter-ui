import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VComponentOverrides', () {
    test('empty is const and get returns null', () {
      const overrides = VComponentOverrides.empty;
      expect(overrides.get<VButtonStyle>(), isNull);
      expect(overrides.get<VTextFieldStyle>(), isNull);
      expect(overrides.get<VCardStyle>(), isNull);
      expect(overrides.get<VTabsStyle>(), isNull);
    });

    test('get retrieves style by type', () {
      const style = VButtonStyle(gap: 8);
      const overrides = VComponentOverrides([style]);

      expect(overrides.get<VButtonStyle>(), style);
      expect(overrides.get<VTextFieldStyle>(), isNull);
    });

    test('merge with null returns this', () {
      const style = VButtonStyle(gap: 8);
      const overrides = VComponentOverrides([style]);

      expect(overrides.merge(null), same(overrides));
    });

    test('merge deep-merges individual style properties', () {
      const parent = VComponentOverrides([
        VButtonStyle(backgroundColor: Color(0xFFFF0000), gap: 8),
      ]);
      const child = VComponentOverrides([
        VButtonStyle(foregroundColor: Color(0xFF0000FF)),
      ]);

      final merged = parent.merge(child);

      // Deep merge: parent backgroundColor preserved, child foregroundColor added
      expect(
        merged.get<VButtonStyle>()?.backgroundColor,
        const Color(0xFFFF0000),
      );
      expect(
        merged.get<VButtonStyle>()?.foregroundColor,
        const Color(0xFF0000FF),
      );
      expect(merged.get<VButtonStyle>()?.gap, 8);
    });

    test('merge child overrides parent for same property', () {
      const parent = VComponentOverrides([
        VButtonStyle(backgroundColor: Color(0xFFFF0000)),
      ]);
      const child = VComponentOverrides([
        VButtonStyle(backgroundColor: Color(0xFF00FF00)),
      ]);

      final merged = parent.merge(child);
      expect(
        merged.get<VButtonStyle>()?.backgroundColor,
        const Color(0xFF00FF00),
      );
    });

    test('merge preserves unrelated component overrides', () {
      const parent = VComponentOverrides([
        VButtonStyle(gap: 8),
        VCardStyle(elevation: 4),
      ]);
      const child = VComponentOverrides([
        VTextFieldStyle(cursorColor: Color(0xFF000000)),
      ]);

      final merged = parent.merge(child);
      expect(merged.get<VButtonStyle>()?.gap, 8);
      expect(merged.get<VCardStyle>()?.elevation, 4);
      expect(
        merged.get<VTextFieldStyle>()?.cursorColor,
        const Color(0xFF000000),
      );
    });

    test('equality works', () {
      const a = VComponentOverrides([VButtonStyle(gap: 8)]);
      const b = VComponentOverrides([VButtonStyle(gap: 8)]);
      const c = VComponentOverrides([VButtonStyle(gap: 16)]);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('VThemeData + VComponentOverrides integration', () {
    test('VThemeData.light() componentOverrides defaults to empty', () {
      final theme = VThemeData.light();
      expect(theme.componentOverrides, VComponentOverrides.empty);
    });

    test('VThemeData.dark() componentOverrides defaults to empty', () {
      final theme = VThemeData.dark();
      expect(theme.componentOverrides, VComponentOverrides.empty);
    });

    test('VThemeData constructor accepts componentOverrides', () {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 8)]),
      );
      expect(theme.componentOverrides.get<VButtonStyle>()?.gap, 8);
    });

    test('VThemeData.copyWith preserves componentOverrides', () {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VButtonStyle(gap: 8),
          VCardStyle(elevation: 4),
        ]),
      );
      final copy = theme.copyWith();
      expect(copy.componentOverrides.get<VButtonStyle>()?.gap, 8);
      expect(copy.componentOverrides.get<VCardStyle>()?.elevation, 4);
    });

    test('VThemeData.copyWith replaces componentOverrides', () {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 8)]),
      );
      final replaced = theme.copyWith(
        componentOverrides: const VComponentOverrides([
          VCardStyle(elevation: 12),
        ]),
      );
      expect(replaced.componentOverrides.get<VButtonStyle>(), isNull);
      expect(replaced.componentOverrides.get<VCardStyle>()?.elevation, 12);
    });

    test('VThemeData equality considers componentOverrides', () {
      final a = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 8)]),
      );
      final b = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 8)]),
      );
      final c = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 16)]),
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });

    test('equal overrides in a different order share one hashCode', () {
      const a = VComponentOverrides([VBoxStyle(), VStackStyle()]);
      const b = VComponentOverrides([VStackStyle(), VBoxStyle()]);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('overrides with different type sets are not equal', () {
      const a = VComponentOverrides([VBoxStyle(), VBoxStyle()]);
      const b = VComponentOverrides([VBoxStyle(), VStackStyle()]);
      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(a)));
    });

    test('VThemeData.lerp snaps componentOverrides at midpoint', () {
      final light = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 8)]),
      );
      final dark = VThemeData.dark().copyWith(
        componentOverrides: const VComponentOverrides([VButtonStyle(gap: 16)]),
      );

      // t < 0.5 -> uses first theme's overrides
      final early = VThemeData.lerp(light, dark, 0.3);
      expect(early.componentOverrides.get<VButtonStyle>()?.gap, 8);

      // t >= 0.5 -> uses second theme's overrides
      final late = VThemeData.lerp(light, dark, 0.7);
      expect(late.componentOverrides.get<VButtonStyle>()?.gap, 16);
    });
  });
}
