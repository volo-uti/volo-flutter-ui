import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

Widget buildTestWidget(Widget child) => VTheme(
  data: VThemeData.light(),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(data: const MediaQueryData(), child: child),
  ),
);

void main() {
  group('VImage', () {
    testWidgets('creates network image', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.network(
            'https://example.com/image.jpg',
            width: 100,
            height: 100,
          ),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    testWidgets('applies width and height', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.network(
            'https://example.com/image.jpg',
            width: 200,
            height: 150,
          ),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    testWidgets('applies borderRadius', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VImage.network(
            'https://example.com/image.jpg',
            width: 100,
            height: 100,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.network(
            'https://example.com/image.jpg',
            width: 100,
            height: 100,
            placeholder: Text('Loading...'),
          ),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    testWidgets('applies semanticLabel', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.network(
            'https://example.com/image.jpg',
            width: 100,
            height: 100,
            semanticLabel: 'Profile Image',
          ),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    testWidgets('BoxFit options', (tester) async {
      for (final fit in [BoxFit.cover, BoxFit.contain, BoxFit.fill]) {
        await tester.pumpWidget(
          buildTestWidget(
            VImage.network(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              fit: fit,
            ),
          ),
        );

        expect(find.byType(VImage), findsOneWidget);
      }
    });

    testWidgets('creates asset variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.asset('assets/test.png', width: 100, height: 100),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    testWidgets('custom fadeInDuration', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VImage.network(
            'https://example.com/image.jpg',
            width: 100,
            height: 100,
            fadeInDuration: Duration(milliseconds: 500),
          ),
        ),
      );

      expect(find.byType(VImage), findsOneWidget);
    });

    group('style fields', () {
      // Applies [style] through the theme or as the instance style.
      Widget styled(VImageStyle style, {required bool viaTheme}) => VTheme(
        data: VThemeData.light().copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VImage.network(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              style: viaTheme ? null : style,
            ),
          ),
        ),
      );

      Finder fill() => find.descendant(
        of: find.byType(VImage),
        matching: find.byType(ColoredBox),
      );

      testWidgets('draws no fill by default', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VImage.network('x')));
        expect(fill(), findsNothing);
      });

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('backgroundColor fills the image box ($via)', (
          tester,
        ) async {
          const color = Color(0xFF123456);
          await tester.pumpWidget(
            styled(
              const VImageStyle(
                backgroundColor: color,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              viaTheme: viaTheme,
            ),
          );

          expect(tester.widget<ColoredBox>(fill()).color, color);
          // The fill sits inside the corner clip.
          expect(
            find.ancestor(of: fill(), matching: find.byType(ClipRRect)),
            findsOneWidget,
          );
        });
      }
    });
  });
}
