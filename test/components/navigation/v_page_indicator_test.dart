import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VPageIndicator.dots', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VPageIndicator.dots(total: 5, current: 0)),
      );

      expect(find.byType(VPageIndicator), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(5));
    });

    testWidgets('displays current page', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VPageIndicator.dots(total: 5, current: 2)),
      );

      expect(find.byType(VPageIndicator), findsOneWidget);
    });

    testWidgets('calls onPageChanged callback', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VPageIndicator.dots(
            total: 5,
            current: 0,
            onPageChanged: (index) => tappedIndex = index,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).at(2));
      await tester.pump();

      expect(tappedIndex, equals(2));
    });
  });

  group('VPageIndicator.number', () {
    testWidgets('default rendering (slash)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VPageIndicator.number(total: 5, current: 1)),
      );

      expect(find.text('2'), findsOneWidget);
      expect(find.text(' / '), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('separator: of', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VPageIndicator.number(
            total: 5,
            current: 1,
            separator: VPageIndicatorSeparator.of,
          ),
        ),
      );

      expect(find.text(' of '), findsOneWidget);
    });

    testWidgets('separator: dash', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VPageIndicator.number(
            total: 5,
            current: 1,
            separator: VPageIndicatorSeparator.dash,
          ),
        ),
      );

      expect(find.text(' - '), findsOneWidget);
    });

    testWidgets('separator: pipe', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VPageIndicator.number(
            total: 5,
            current: 1,
            separator: VPageIndicatorSeparator.pipe,
          ),
        ),
      );

      expect(find.text(' | '), findsOneWidget);
    });

    testWidgets('onPageChanged callback (next page)', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VPageIndicator.number(
            total: 5,
            current: 1,
            onPageChanged: (index) => changedIndex = index,
          ),
        ),
      );

      // Tap next button
      await tester.tap(find.byType(GestureDetector).last);
      await tester.pump();

      expect(changedIndex, equals(2));
    });

    testWidgets('onPageChanged callback (previous page)', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VPageIndicator.number(
            total: 5,
            current: 2,
            onPageChanged: (index) => changedIndex = index,
          ),
        ),
      );

      // Tap previous button
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      expect(changedIndex, equals(1));
    });
  });

  group('VPageIndicator.line', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 300,
            child: VPageIndicator.line(total: 5, current: 2),
          ),
        ),
      );

      expect(find.byType(VPageIndicator), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(5));
    });

    testWidgets('calls onPageChanged callback', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 300,
            child: VPageIndicator.line(
              total: 5,
              current: 0,
              onPageChanged: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).at(3));
      await tester.pump();

      expect(tappedIndex, equals(3));
    });
  });
}
