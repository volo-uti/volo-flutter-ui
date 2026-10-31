import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VStack', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('VStack.horizontal', () {
      testWidgets('Row-based layout', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(
              children: [Text('A'), Text('B'), Text('C')],
            ),
          ),
        );

        expect(find.byType(Row), findsOneWidget);
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      });

      testWidgets('applies spacing', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(
              spacing: 16,
              children: [Text('A'), Text('B')],
            ),
          ),
        );

        // SizedBox is added when spacing is applied
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacer = sizedBoxes.where((box) => box.width == 16).toList();
        expect(spacer, isNotEmpty);
      });

      testWidgets('no gap when spacing is 0', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(children: [Text('A'), Text('B')]),
          ),
        );

        // Row should have 2 direct children (no SizedBox gap)
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, 2);
      });

      testWidgets('applies mainAxisAlignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('A')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('applies crossAxisAlignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('A')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('applies mainAxisSize', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(
              mainAxisSize: MainAxisSize.min,
              children: [Text('A')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
      });
    });

    group('VStack.vertical', () {
      testWidgets('Column-based layout', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.vertical(children: [Text('A'), Text('B'), Text('C')]),
          ),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      });

      testWidgets('applies spacing', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.vertical(spacing: 8, children: [Text('A'), Text('B')]),
          ),
        );

        // SizedBox is added when spacing is applied
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacer = sizedBoxes.where((box) => box.height == 8).toList();
        expect(spacer, isNotEmpty);
      });

      testWidgets('applies mainAxisAlignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.vertical(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text('A')],
            ),
          ),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
      });

      testWidgets('applies textDirection', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.vertical(
              textDirection: TextDirection.rtl,
              children: [Text('A')],
            ),
          ),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.textDirection, TextDirection.rtl);
      });

      testWidgets('applies verticalDirection', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.vertical(
              verticalDirection: VerticalDirection.up,
              children: [Text('A')],
            ),
          ),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.verticalDirection, VerticalDirection.up);
      });
    });

    group('empty children', () {
      testWidgets('horizontal - renders SizedBox.shrink for empty children', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VStack.horizontal(children: [])),
        );

        expect(find.byType(VStack), findsOneWidget);
        // Row should not exist
        expect(find.byType(Row), findsNothing);
      });

      testWidgets('vertical - renders SizedBox.shrink for empty children', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VStack.vertical(children: [])),
        );

        expect(find.byType(VStack), findsOneWidget);
        // Column should not exist
        expect(find.byType(Column), findsNothing);
      });
    });

    group('single child', () {
      testWidgets('no spacing for single child', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VStack.horizontal(spacing: 16, children: [Text('Alone')]),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        // Single child should have no SizedBox spacing
        expect(row.children.length, 1);
      });
    });

    group('defaults', () {
      testWidgets('default crossAxisAlignment is center', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VStack.horizontal(children: [Text('A')])),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.crossAxisAlignment, CrossAxisAlignment.center);
      });

      testWidgets('default mainAxisAlignment is start', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VStack.vertical(children: [Text('A')])),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisAlignment, MainAxisAlignment.start);
      });

      testWidgets('default mainAxisSize is max', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VStack.vertical(children: [Text('A')])),
        );

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisSize, MainAxisSize.max);
      });
    });
  });

  group('VStack precedence', () {
    Widget themed(Widget child, VComponentStyle style) => VTheme(
      data: VThemeData.light().copyWith(
        componentOverrides: VComponentOverrides([style]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    double gapOf(WidgetTester tester) =>
        tester.getTopLeft(find.byKey(const Key('b'))).dy.abs();

    Widget stack({double? spacing, VStackStyle? style}) => VStack.vertical(
      spacing: spacing,
      style: style,
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(key: Key('a'), height: 10, width: 10),
        SizedBox(key: Key('b'), height: 10, width: 10),
      ],
    );

    testWidgets('explicit spacing beats the theme override', (tester) async {
      await tester.pumpWidget(
        themed(stack(spacing: 5), const VStackStyle(spacing: 20)),
      );
      expect(gapOf(tester), 15);
    });

    testWidgets('the theme override applies without explicit spacing', (
      tester,
    ) async {
      await tester.pumpWidget(themed(stack(), const VStackStyle(spacing: 20)));
      expect(gapOf(tester), 30);
    });

    testWidgets('the instance style beats explicit spacing', (tester) async {
      await tester.pumpWidget(
        themed(
          stack(spacing: 5, style: const VStackStyle(spacing: 7)),
          const VStackStyle(spacing: 20),
        ),
      );
      expect(gapOf(tester), 17);
    });
  });
}
