import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VComponentSize', () {
    test('padding returns EdgeInsets', () {
      const size = VComponentSize(
        height: 40,
        paddingHorizontal: 16,
        paddingVertical: 10,
        fontSize: 14,
        iconSize: 18,
        spacing: 8,
        borderRadius: 8,
      );

      expect(
        size.padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      );
    });

    test('copyWith() changes only some properties', () {
      const original = VComponentSize(
        height: 40,
        paddingHorizontal: 16,
        paddingVertical: 10,
        fontSize: 14,
        iconSize: 18,
        spacing: 8,
        borderRadius: 8,
      );
      final modified = original.copyWith(height: 48);

      expect(modified.height, 48);
      expect(modified.fontSize, original.fontSize);
    });

    test('lerp() interpolates between two sizes', () {
      const a = VComponentSize(
        height: 32,
        paddingHorizontal: 12,
        paddingVertical: 6,
        fontSize: 13,
        iconSize: 16,
        spacing: 6,
        borderRadius: 4,
      );
      const b = VComponentSize(
        height: 48,
        paddingHorizontal: 24,
        paddingVertical: 14,
        fontSize: 16,
        iconSize: 20,
        spacing: 10,
        borderRadius: 8,
      );
      final mid = VComponentSize.lerp(a, b, 0.5);

      expect(mid.height, 40);
    });

    test('identical sizes are equal', () {
      const a = VComponentSize(
        height: 40,
        paddingHorizontal: 16,
        paddingVertical: 10,
        fontSize: 14,
        iconSize: 18,
        spacing: 8,
        borderRadius: 8,
      );
      const b = VComponentSize(
        height: 40,
        paddingHorizontal: 16,
        paddingVertical: 10,
        fontSize: 14,
        iconSize: 18,
        spacing: 8,
        borderRadius: 8,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('VSizes', () {
    test('defaults returns default sizes', () {
      final sizes = VSizes.defaults;

      expect(sizes.sm.height, 32);
      expect(sizes.md.height, 40);
      expect(sizes.lg.height, 48);
    });

    test('copyWith() changes only specified properties', () {
      final original = VSizes.defaults;
      final modified = original.copyWith(sm: original.sm.copyWith(height: 28));

      expect(modified.sm.height, 28);
      expect(modified.md, original.md);
    });

    test('lerp() interpolates between two size systems', () {
      final a = VSizes.defaults;
      final b = VSizes.defaults;
      final mid = VSizes.lerp(a, b, 0.5);

      expect(mid.md.height, 40);
    });

    test('identical size systems are equal', () {
      final a = VSizes.defaults;
      final b = VSizes.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
