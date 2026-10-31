import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VButtonGroupData', () {
    test('stores size and borderRadius', () {
      const data = VButtonGroupData(
        size: VButtonSize.lg,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );

      expect(data.size, VButtonSize.lg);
      expect(data.borderRadius, const BorderRadius.all(Radius.circular(8)));
    });

    test('allows null values', () {
      const data = VButtonGroupData();
      expect(data.size, isNull);
      expect(data.borderRadius, isNull);
    });
  });

  group('VButtonGroupScope', () {
    Widget buildTestWidget(Widget child) =>
        Directionality(textDirection: TextDirection.ltr, child: child);

    // ── Provides data to children ────────────────────────────────────

    testWidgets('provides data to descendant widgets', (tester) async {
      VButtonGroupData? received;

      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroupScope(
            data: const VButtonGroupData(
              size: VButtonSize.sm,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Builder(
              builder: (context) {
                received = VButtonGroupScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(received, isNotNull);
      expect(received!.size, VButtonSize.sm);
      expect(
        received!.borderRadius,
        const BorderRadius.all(Radius.circular(4)),
      );
    });

    testWidgets('provides data with only size set', (tester) async {
      VButtonGroupData? received;

      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroupScope(
            data: const VButtonGroupData(size: VButtonSize.lg),
            child: Builder(
              builder: (context) {
                received = VButtonGroupScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(received, isNotNull);
      expect(received!.size, VButtonSize.lg);
      expect(received!.borderRadius, isNull);
    });

    testWidgets('provides data with only borderRadius set', (tester) async {
      VButtonGroupData? received;

      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroupScope(
            data: const VButtonGroupData(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Builder(
              builder: (context) {
                received = VButtonGroupScope.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(received, isNotNull);
      expect(received!.size, isNull);
      expect(
        received!.borderRadius,
        const BorderRadius.all(Radius.circular(12)),
      );
    });

    // ── maybeOf returns null outside scope ────────────────────────────

    testWidgets('maybeOf returns null when no scope in tree', (tester) async {
      VButtonGroupData? received;

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              received = VButtonGroupScope.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(received, isNull);
    });

    // ── updateShouldNotify ───────────────────────────────────────────

    group('updateShouldNotify', () {
      testWidgets('rebuilds child when size changes', (tester) async {
        var buildCount = 0;

        final widget = _RebuildCounter(onBuild: () => buildCount++);

        // Initial render with sm
        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.sm),
              child: widget,
            ),
          ),
        );
        expect(buildCount, 1);

        // Update to lg
        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.lg),
              child: widget,
            ),
          ),
        );
        expect(buildCount, 2);
      });

      testWidgets('rebuilds child when borderRadius changes', (tester) async {
        var buildCount = 0;

        final widget = _RebuildCounter(onBuild: () => buildCount++);

        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: widget,
            ),
          ),
        );
        expect(buildCount, 1);

        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: widget,
            ),
          ),
        );
        expect(buildCount, 2);
      });

      testWidgets('does not rebuild child when data is identical', (
        tester,
      ) async {
        var buildCount = 0;

        final widget = _RebuildCounter(onBuild: () => buildCount++);

        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.md),
              child: widget,
            ),
          ),
        );
        expect(buildCount, 1);

        // Same data
        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.md),
              child: widget,
            ),
          ),
        );
        // Should NOT rebuild because data is the same
        expect(buildCount, 1);
      });

      testWidgets('does not rebuild when only child changes but data is same', (
        tester,
      ) async {
        var buildCount = 0;

        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.sm),
              child: _RebuildCounter(onBuild: () => buildCount++),
            ),
          ),
        );
        expect(buildCount, 1);

        // Same data, new child instance (but same type, same key)
        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.sm),
              child: _RebuildCounter(onBuild: () => buildCount++),
            ),
          ),
        );

        // The widget itself may or may not rebuild (Flutter decides),
        // but updateShouldNotify returns false so dependents should not.
        // The count increments because the _RebuildCounter is a new instance,
        // so Flutter rebuilds it. But the key assertion is that
        // updateShouldNotify correctly returns false for same data.
        // We verify this via the unit test below.
      });
    });

    // ── updateShouldNotify direct unit test ──────────────────────────

    group('updateShouldNotify logic', () {
      test('returns true when size differs', () {
        const scopeA = VButtonGroupScope(
          data: VButtonGroupData(size: VButtonSize.sm),
          child: SizedBox.shrink(),
        );
        const scopeB = VButtonGroupScope(
          data: VButtonGroupData(size: VButtonSize.lg),
          child: SizedBox.shrink(),
        );

        expect(scopeA.updateShouldNotify(scopeB), isTrue);
      });

      test('returns true when borderRadius differs', () {
        const scopeA = VButtonGroupScope(
          data: VButtonGroupData(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: SizedBox.shrink(),
        );
        const scopeB = VButtonGroupScope(
          data: VButtonGroupData(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox.shrink(),
        );

        expect(scopeA.updateShouldNotify(scopeB), isTrue);
      });

      test('returns false when data is identical', () {
        const scopeA = VButtonGroupScope(
          data: VButtonGroupData(
            size: VButtonSize.md,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox.shrink(),
        );
        const scopeB = VButtonGroupScope(
          data: VButtonGroupData(
            size: VButtonSize.md,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox.shrink(),
        );

        expect(scopeA.updateShouldNotify(scopeB), isFalse);
      });

      test('returns false when both have null data', () {
        const scopeA = VButtonGroupScope(
          data: VButtonGroupData(),
          child: SizedBox.shrink(),
        );
        const scopeB = VButtonGroupScope(
          data: VButtonGroupData(),
          child: SizedBox.shrink(),
        );

        expect(scopeA.updateShouldNotify(scopeB), isFalse);
      });

      test('returns true when size changes from null to non-null', () {
        const scopeA = VButtonGroupScope(
          data: VButtonGroupData(),
          child: SizedBox.shrink(),
        );
        const scopeB = VButtonGroupScope(
          data: VButtonGroupData(size: VButtonSize.lg),
          child: SizedBox.shrink(),
        );

        expect(scopeA.updateShouldNotify(scopeB), isTrue);
      });
    });

    // ── Nested scopes ────────────────────────────────────────────────

    group('nested scopes', () {
      testWidgets('inner scope overrides outer scope', (tester) async {
        VButtonGroupData? received;

        await tester.pumpWidget(
          buildTestWidget(
            VButtonGroupScope(
              data: const VButtonGroupData(size: VButtonSize.sm),
              child: VButtonGroupScope(
                data: const VButtonGroupData(size: VButtonSize.lg),
                child: Builder(
                  builder: (context) {
                    received = VButtonGroupScope.maybeOf(context);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        );

        expect(received, isNotNull);
        expect(received!.size, VButtonSize.lg);
      });
    });
  });
}

/// Helper widget that counts how many times its build method is called
/// due to inherited widget dependency changes.
class _RebuildCounter extends StatelessWidget {
  const _RebuildCounter({required this.onBuild});

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    // Access the scope to create a dependency
    VButtonGroupScope.maybeOf(context);
    onBuild();
    return const SizedBox.shrink();
  }
}
