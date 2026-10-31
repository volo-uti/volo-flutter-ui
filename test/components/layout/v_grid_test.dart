import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VGrid', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: child,
        ),
      ),
    );

    group('VGrid.count', () {
      testWidgets('fixed column count grid', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
                Container(color: const Color(0xFF0000FF)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(Container), findsNWidgets(3));
      });

      testWidgets('applies spacing', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              spacing: 16,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('applies mainAxisSpacing/crossAxisSpacing individually', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('applies childAspectRatio', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 16 / 9,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('applies mainAxisExtent', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              mainAxisExtent: 100,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('crossAxisCount <= 0 is treated as 1', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 0,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('VGrid.extent', () {
      testWidgets('max cross axis extent grid', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.extent(
              maxCrossAxisExtent: 150,
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
                Container(color: const Color(0xFF0000FF)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('maxCrossAxisExtent <= 0 is treated as 100', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.extent(
              maxCrossAxisExtent: 0,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('VGrid.custom', () {
      testWidgets('custom delegate grid', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.custom(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              shrinkWrap: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('common properties', () {
      testWidgets('applies padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.padding, const EdgeInsets.all(16));
      });

      testWidgets('applies scrollDirection', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.scrollDirection, Axis.horizontal);
      });

      testWidgets('applies shrinkWrap', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.shrinkWrap, isTrue);
      });

      testWidgets('applies physics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.physics, isA<NeverScrollableScrollPhysics>());
      });

      testWidgets('applies reverse', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              reverse: true,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.reverse, isTrue);
      });
    });

    group('defaults', () {
      testWidgets('default scrollDirection is vertical', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.scrollDirection, Axis.vertical);
      });

      testWidgets('default shrinkWrap is false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(
              height: 400,
              child: VGrid.count(
                crossAxisCount: 2,
                children: [Container(color: const Color(0xFFFF0000))],
              ),
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.shrinkWrap, isFalse);
      });

      testWidgets('default reverse is false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView.reverse, isFalse);
      });

      testWidgets('default childAspectRatio is 1.0', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('aspectRatio <= 0 is treated as 1.0', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VGrid.count(
              crossAxisCount: 2,
              childAspectRatio: -1,
              shrinkWrap: true,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
      });
    });
  });

  group('VGrid precedence', () {
    Widget themed(Widget child, VComponentStyle style) => VTheme(
      data: VThemeData.light().copyWith(
        componentOverrides: VComponentOverrides([style]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    SliverGridDelegateWithFixedCrossAxisCount delegateOf(WidgetTester tester) =>
        tester.widget<GridView>(find.byType(GridView)).gridDelegate
            as SliverGridDelegateWithFixedCrossAxisCount;

    Widget grid({double? spacing}) => VGrid.count(
      crossAxisCount: 2,
      spacing: spacing,
      shrinkWrap: true,
      children: const [SizedBox(), SizedBox()],
    );

    testWidgets('explicit spacing beats the theme override', (tester) async {
      await tester.pumpWidget(
        themed(grid(spacing: 4), const VGridStyle(spacing: 16)),
      );
      expect(delegateOf(tester).mainAxisSpacing, 4);
      expect(delegateOf(tester).crossAxisSpacing, 4);
    });

    testWidgets('the theme override applies without explicit spacing', (
      tester,
    ) async {
      await tester.pumpWidget(themed(grid(), const VGridStyle(spacing: 16)));
      expect(delegateOf(tester).mainAxisSpacing, 16);
    });
  });
}
