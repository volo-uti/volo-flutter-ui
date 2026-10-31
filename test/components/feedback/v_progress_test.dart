import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VProgress', () {
    group('linear', () {
      testWidgets('renders with value', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VProgress.linear(value: 0.5)),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('renders indeterminate', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VProgress.linear()));

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('respects size sm', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VProgress.linear(value: 0.5, size: VProgressSize.sm),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('respects size lg', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VProgress.linear(value: 0.5, size: VProgressSize.lg),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('respects custom color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VProgress.linear(value: 0.5, color: Color(0xFF00FF00)),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });
    });

    group('circular', () {
      testWidgets('renders with value', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VProgress.circular(value: 0.75)),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('renders indeterminate', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VProgress.circular()));

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('respects custom color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VProgress.circular(value: 0.5, color: Color(0xFF00FF00)),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });

      testWidgets('respects background color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VProgress.circular(
              value: 0.5,
              backgroundColor: Color(0xFFCCCCCC),
            ),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to progress', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VProgressStyle(activeColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VProgress.linear(value: 0.5),
            ),
          ),
        );

        expect(find.byType(VProgress), findsOneWidget);
      });
    });
  });

  group('VProgress regressions', () {
    testWidgets('the indeterminate bar sweeps its whole width', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 600, child: VProgress.linear()),
          ),
        ),
      );

      final block = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).gradient != null,
      );
      var furthest = double.negativeInfinity;
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        final left = tester.getTopLeft(block).dx;
        if (left > furthest) furthest = left;
      }

      expect(furthest, greaterThan(300));
    });
  });
}
