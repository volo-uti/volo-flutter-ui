import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VLink', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VLink(child: const Text('Learn more'), onTap: () {})),
      );

      expect(find.text('Learn more'), findsOneWidget);
    });

    testWidgets('onTap callback works', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          VLink(child: const Text('Click me'), onTap: () => pressed = true),
        ),
      );

      await tester.tap(find.text('Click me'));
      expect(pressed, isTrue);
    });

    testWidgets('no callback when onTap is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VLink(child: Text('Read-only'))),
      );

      expect(find.text('Read-only'), findsOneWidget);
      // Should not throw when tapped without callback
      await tester.tap(find.text('Read-only'));
    });

    testWidgets('renders with child widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VLink(
            onTap: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Go'), Text(' →')],
            ),
          ),
        ),
      );

      expect(find.text('Go'), findsOneWidget);
      expect(find.text(' →'), findsOneWidget);
    });

    testWidgets('underline variants render', (tester) async {
      for (final underline in VLinkUnderline.values) {
        await tester.pumpWidget(
          buildTestWidget(
            VLink(
              onTap: () {},
              underline: underline,
              child: const Text('Link'),
            ),
          ),
        );

        expect(find.text('Link'), findsOneWidget);
      }
    });

    testWidgets('color variants render', (tester) async {
      for (final color in VLinkColor.values) {
        await tester.pumpWidget(
          buildTestWidget(
            VLink(onTap: () {}, color: color, child: const Text('Link')),
          ),
        );

        expect(find.text('Link'), findsOneWidget);
      }
    });
  });
}
