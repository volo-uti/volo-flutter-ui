import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VBox', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('default constructor', () {
      testWidgets('creates VBox', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox(child: Text('Test'))),
        );

        expect(find.text('Test'), findsOneWidget);
        expect(find.byType(VBox), findsOneWidget);
      });

      testWidgets('applies padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox(padding: EdgeInsets.all(16), child: Text('Test')),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.padding, const EdgeInsets.all(16));
      });

      testWidgets('applies margin', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox(margin: EdgeInsets.all(8), child: Text('Test')),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.margin, const EdgeInsets.all(8));
      });

      testWidgets('applies width/height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox(width: 100, height: 50, child: Text('Test')),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, 100);
        expect(container.constraints?.maxHeight, 50);
      });

      testWidgets('default clipBehavior is Clip.none', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox(child: Text('Test'))),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.clipBehavior, Clip.none);
      });
    });

    group('VBox.card', () {
      testWidgets('applies card style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox.card(child: Text('Card'))),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Card background color applied
        expect(decoration.color, isNotNull);
        // Border applied
        expect(decoration.border, isNotNull);
        // Border radius applied
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets('default clipBehavior is Clip.antiAlias', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox.card(child: Text('Card'))),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.clipBehavior, Clip.antiAlias);
      });
    });

    group('VBox.outlined', () {
      testWidgets('applies border only', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox.outlined(child: Text('Outlined'))),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Transparent background
        expect(decoration.color, isNull);
        // Border applied
        expect(decoration.border, isNotNull);
        // Border radius applied
        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('VBox.elevated', () {
      testWidgets('applies shadow', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VBox.elevated(child: Text('Elevated'))),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Card background color applied
        expect(decoration.color, isNotNull);
        // Shadow applied
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow, isNotEmpty);
        // Border radius applied
        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('custom properties', () {
      testWidgets('custom color override', (tester) async {
        const customColor = Color(0xFFFF0000);

        await tester.pumpWidget(
          buildTestWidget(
            const VBox.card(color: customColor, child: Text('Custom')),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, customColor);
      });

      testWidgets('custom borderRadius override', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox.card(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Text('Custom'),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(
          decoration.borderRadius,
          const BorderRadius.all(Radius.circular(20)),
        );
      });

      testWidgets('applies constraints', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox(
              constraints: BoxConstraints(minWidth: 50, maxWidth: 200),
              child: Text('Test'),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.minWidth, 50);
        expect(container.constraints?.maxWidth, 200);
      });

      testWidgets('applies alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VBox(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              child: Text('Test'),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.alignment, Alignment.center);
      });
    });

    testWidgets('renders empty container when child is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBox()));

      expect(find.byType(VBox), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('VBox precedence', () {
    Widget themed(Widget child, VComponentStyle style) => VTheme(
      data: VThemeData.light().copyWith(
        componentOverrides: VComponentOverrides([style]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );
    const themeColor = Color(0xFF00FF00);
    const argColor = Color(0xFFFF0000);
    const styleColor = Color(0xFF0000FF);

    Color? paintedColor(WidgetTester tester) {
      final container = tester.widget<Container>(find.byType(Container).first);
      return (container.decoration as BoxDecoration?)?.color;
    }

    testWidgets('explicit constructor values beat the theme override', (
      tester,
    ) async {
      await tester.pumpWidget(
        themed(
          const VBox(
            color: argColor,
            padding: EdgeInsets.all(3),
            borderRadius: BorderRadius.all(Radius.circular(2)),
            child: SizedBox(),
          ),
          const VBoxStyle(
            backgroundColor: themeColor,
            padding: EdgeInsets.all(9),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(paintedColor(tester), argColor);
      expect(container.padding, const EdgeInsets.all(3));
      expect(
        (container.decoration! as BoxDecoration).borderRadius,
        const BorderRadius.all(Radius.circular(2)),
      );
    });

    testWidgets('the theme override still beats variant defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        themed(
          const VBox.card(child: SizedBox()),
          const VBoxStyle(backgroundColor: themeColor),
        ),
      );

      expect(paintedColor(tester), themeColor);
    });

    testWidgets('the instance style beats the explicit value', (tester) async {
      await tester.pumpWidget(
        themed(
          const VBox(
            color: argColor,
            style: VBoxStyle(backgroundColor: styleColor),
            child: SizedBox(),
          ),
          const VBoxStyle(backgroundColor: themeColor),
        ),
      );

      expect(paintedColor(tester), styleColor);
    });
  });
}
