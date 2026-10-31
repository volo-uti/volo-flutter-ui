import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VLoadingSpinner', () {
    testWidgets('renders with required color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 48,
            height: 48,
            child: VLoadingSpinner(color: Color(0xFF0000FF)),
          ),
        ),
      );

      expect(find.byType(VLoadingSpinner), findsOneWidget);
    });

    testWidgets('renders with explicit size', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 32),
        ),
      );

      expect(find.byType(VLoadingSpinner), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(VLoadingSpinner),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 32);
      expect(sizedBox.height, 32);
    });

    testWidgets('wraps in SizedBox when size is provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 24),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(VLoadingSpinner),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets('does not wrap in SizedBox when size is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 48,
            height: 48,
            child: VLoadingSpinner(color: Color(0xFF0000FF)),
          ),
        ),
      );

      // SizedBox should be the parent, not a child of VLoadingSpinner.
      final sizedBoxInsideSpinner = find.descendant(
        of: find.byType(VLoadingSpinner),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxInsideSpinner, findsNothing);
    });

    testWidgets('renders CustomPaint for spinner arc', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 48,
            height: 48,
            child: VLoadingSpinner(color: Color(0xFF0000FF)),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(VLoadingSpinner),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('animation rotates via Transform.rotate', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 48),
        ),
      );

      // Pump a frame to let the animation controller advance.
      await tester.pump(const Duration(milliseconds: 500));

      final transformFinder = find.descendant(
        of: find.byType(VLoadingSpinner),
        matching: find.byWidgetPredicate(
          (widget) => widget is Transform && widget.transform.storage[0] != 1.0,
        ),
      );
      expect(transformFinder, findsOneWidget);
    });

    testWidgets('animation starts at angle 0', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 48),
        ),
      );

      // At frame 0, controller value is 0 => angle = 0 * 2 * pi = 0.
      final transformFinder = find.descendant(
        of: find.byType(VLoadingSpinner),
        matching: find.byWidgetPredicate((widget) {
          if (widget is! Transform) return false;
          // Identity rotation (angle = 0) => cos(0) = 1, sin(0) = 0.
          final storage = widget.transform.storage;
          return (storage[0] - 1.0).abs() < 0.001 && storage[1].abs() < 0.001;
        }),
      );
      expect(transformFinder, findsOneWidget);
    });

    testWidgets('accepts custom strokeWidth', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 48,
            height: 48,
            child: VLoadingSpinner(color: Color(0xFF0000FF), strokeWidth: 4),
          ),
        ),
      );

      expect(find.byType(VLoadingSpinner), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('uses theme animation duration', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 48),
        ),
      );

      // After one full theme verySlow duration, animation should loop.
      final theme = VThemeData.light();
      await tester.pump(theme.animations.verySlow);

      // Should still render after full animation cycle.
      expect(find.byType(VLoadingSpinner), findsOneWidget);
    });

    testWidgets('survives pump and settle', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 48),
        ),
      );

      // The spinner repeats infinitely, so pumpAndSettle should time out.
      // Instead, pump a few frames to verify it keeps rendering.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(VLoadingSpinner), findsOneWidget);
    });

    testWidgets('disposes animation controller on removal', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF0000FF), size: 48),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Replace with different widget to trigger dispose.
      await tester.pumpWidget(buildTestWidget(const SizedBox.shrink()));

      // No errors means dispose succeeded.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with different colors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFFFF0000), size: 24),
        ),
      );

      expect(find.byType(VLoadingSpinner), findsOneWidget);

      // Rebuild with a different color.
      await tester.pumpWidget(
        buildTestWidget(
          const VLoadingSpinner(color: Color(0xFF00FF00), size: 24),
        ),
      );

      expect(find.byType(VLoadingSpinner), findsOneWidget);
    });
  });

  group('VLoadingSpinner regressions', () {
    testWidgets('announces itself as loading', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 48,
            height: 48,
            child: VLoadingSpinner(color: Color(0xFF0000FF)),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Loading...'), findsOneWidget);
      handle.dispose();
    });
  });
}
