import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VBackdrop', () {
    testWidgets('renders with theme scrim color by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      expect(find.byType(VBackdrop), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('onTap callback fires when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(VBackdrop(onTap: () => tapped = true)),
      );

      await tester.tap(find.byType(VBackdrop));
      expect(tapped, isTrue);
    });

    testWidgets('custom color is applied', (tester) async {
      const customColor = Color(0xFFFF0000);

      await tester.pumpWidget(
        buildTestWidget(const VBackdrop(color: customColor)),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.color!;
      // Custom color with default 0.5 opacity
      expect(decoration, customColor.withValues(alpha: 0.5));
    });

    testWidgets('custom opacity is applied', (tester) async {
      const customOpacity = 0.8;

      await tester.pumpWidget(
        buildTestWidget(const VBackdrop(opacity: customOpacity)),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final appliedColor = container.color!;
      // Scrim color from light theme with custom opacity
      final expectedColor = VThemeData.light().colors.scrim.withValues(
        alpha: customOpacity,
      );
      expect(appliedColor, expectedColor);
    });

    testWidgets('default opacity is 0.5', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      final container = tester.widget<Container>(find.byType(Container));
      final appliedColor = container.color!;
      final expectedColor = VThemeData.light().colors.scrim.withValues(
        alpha: 0.5,
      );
      expect(appliedColor, expectedColor);
    });

    testWidgets('has Backdrop semantics label', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      final semantics = tester.widget<Semantics>(find.byType(Semantics));
      expect(semantics.properties.label, 'Backdrop');
    });

    testWidgets('excludeSemantics is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      final semantics = tester.widget<Semantics>(find.byType(Semantics));
      expect(semantics.excludeSemantics, isTrue);
    });

    testWidgets('uses HitTestBehavior.opaque', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      final detector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(detector.behavior, HitTestBehavior.opaque);
    });

    testWidgets('renders without crash when onTap is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBackdrop()));

      // Tap should not throw
      await tester.tap(find.byType(VBackdrop));
      await tester.pump();

      expect(find.byType(VBackdrop), findsOneWidget);
    });

    testWidgets('taps on transparent area are still handled', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 400,
            height: 400,
            child: VBackdrop(onTap: () => tapped = true),
          ),
        ),
      );

      // Tap at center - opaque behavior ensures hit even on transparent areas
      await tester.tapAt(const Offset(200, 200));
      expect(tapped, isTrue);
    });
  });
}
