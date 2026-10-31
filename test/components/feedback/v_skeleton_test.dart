import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VSkeleton', () {
    group('box', () {
      testWidgets('renders with default size', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VSkeleton.rectangular()));

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with custom size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VSkeleton.rectangular(width: 200, height: 100)),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with wave animation', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSkeleton.rectangular(animation: VSkeletonAnimation.wave),
          ),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with pulse animation', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VSkeleton.rectangular()));

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with no animation', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSkeleton.rectangular(animation: VSkeletonAnimation.none),
          ),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });
    });

    group('text', () {
      testWidgets('renders single line', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VSkeleton.text()));

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders multiple lines', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VSkeleton.text(lines: 3)),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with custom width', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VSkeleton.text(width: 150)),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });
    });

    group('circle', () {
      testWidgets('renders with default size', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VSkeleton.circular()));

        expect(find.byType(VSkeleton), findsOneWidget);
      });

      testWidgets('renders with custom size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VSkeleton.circular(size: 80)),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to skeleton', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VSkeletonStyle(baseColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VSkeleton.rectangular(),
            ),
          ),
        );

        expect(find.byType(VSkeleton), findsOneWidget);
      });
    });
  });

  group('VSkeleton regressions', () {
    testWidgets('the last text line is shorter when width is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 400, child: VSkeleton.text(lines: 3)),
          ),
        ),
      );

      final lines = find.descendant(
        of: find.byType(VSkeleton),
        matching: find.byType(Container),
      );
      expect(lines, findsNWidgets(3));
      expect(tester.getSize(lines.at(0)).width, 400);
      expect(tester.getSize(lines.at(1)).width, 400);
      expect(tester.getSize(lines.at(2)).width, 300);
    });

    testWidgets('starts animating when the animation changes from none', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSkeleton.rectangular(animation: VSkeletonAnimation.none),
        ),
      );
      expect(tester.hasRunningAnimations, isFalse);

      await tester.pumpWidget(buildTestWidget(const VSkeleton.rectangular()));
      await tester.pump();

      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('stops animating when the animation changes to none', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSkeleton.rectangular(animation: VSkeletonAnimation.wave),
        ),
      );
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(
        buildTestWidget(
          const VSkeleton.rectangular(animation: VSkeletonAnimation.none),
        ),
      );
      await tester.pump();

      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
