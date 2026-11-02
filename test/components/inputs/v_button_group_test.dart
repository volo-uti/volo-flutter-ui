import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VButtonGroup', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('renders children horizontally by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            children: [
              VButton(onPressed: () {}, child: const Text('Left')),
              VButton(onPressed: () {}, child: const Text('Center')),
              VButton(onPressed: () {}, child: const Text('Right')),
            ],
          ),
        ),
      );

      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('renders children vertically', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            orientation: VButtonGroupOrientation.vertical,
            children: [
              VButton(onPressed: () {}, child: const Text('Top')),
              VButton(onPressed: () {}, child: const Text('Bottom')),
            ],
          ),
        ),
      );

      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);

      // Verify Column exists inside VButtonGroup
      final columnFinder = find.descendant(
        of: find.byType(VButtonGroup),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsOneWidget);
    });

    testWidgets('applies size to children via scope', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            size: VButtonSize.sm,
            children: [
              VButton(onPressed: () {}, child: const Text('A')),
              VButton(onPressed: () {}, child: const Text('B')),
            ],
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byType(VButtonGroup), findsOneWidget);
    });

    group('style fields', () {
      final theme = VThemeData.light();
      const radius = BorderRadius.only(
        topLeft: Radius.circular(1),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(3),
        bottomRight: Radius.circular(4),
      );
      const keys = [Key('first'), Key('middle'), Key('last')];

      // Applies [style] through the theme or as the instance style.
      Widget styled(
        VButtonGroupStyle style, {
        required bool viaTheme,
        List<VComponentStyle> themeStyles = const [],
        VButtonGroupOrientation orientation =
            VButtonGroupOrientation.horizontal,
        List<VButtonStyle?> buttonStyles = const [null, null, null],
      }) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides([
            ...themeStyles,
            if (viaTheme) style,
          ]),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: VButtonGroup(
              orientation: orientation,
              style: viaTheme ? null : style,
              children: [
                for (var i = 0; i < keys.length; i++)
                  VButton.outlined(
                    key: keys[i],
                    style: buttonStyles[i],
                    onPressed: () {},
                    child: const Text('A'),
                  ),
              ],
            ),
          ),
        ),
      );

      BoxDecoration decorationOf(WidgetTester tester, Key key) =>
          tester
                  .widget<AnimatedContainer>(
                    find.descendant(
                      of: find.byKey(key),
                      matching: find.byType(AnimatedContainer),
                    ),
                  )
                  .decoration!
              as BoxDecoration;

      Color borderColorOf(WidgetTester tester, Key key) =>
          (decorationOf(tester, key).border! as Border).top.color;

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('borderRadius rounds the outer corners ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              const VButtonGroupStyle(borderRadius: radius),
              viaTheme: viaTheme,
            ),
          );

          expect(
            decorationOf(tester, keys.first).borderRadius,
            const BorderRadius.only(
              topLeft: Radius.circular(1),
              bottomLeft: Radius.circular(3),
            ),
          );
          expect(decorationOf(tester, keys[1]).borderRadius, BorderRadius.zero);
          expect(
            decorationOf(tester, keys.last).borderRadius,
            const BorderRadius.only(
              topRight: Radius.circular(2),
              bottomRight: Radius.circular(4),
            ),
          );

          await tester.pumpWidget(
            styled(
              const VButtonGroupStyle(borderRadius: radius),
              viaTheme: viaTheme,
              orientation: VButtonGroupOrientation.vertical,
            ),
          );

          expect(
            decorationOf(tester, keys.first).borderRadius,
            const BorderRadius.only(
              topLeft: Radius.circular(1),
              topRight: Radius.circular(2),
            ),
          );
          expect(
            decorationOf(tester, keys.last).borderRadius,
            const BorderRadius.only(
              bottomLeft: Radius.circular(3),
              bottomRight: Radius.circular(4),
            ),
          );
        });

        testWidgets('borderColor reaches every button ($via)', (tester) async {
          const groupColor = Color(0xFF00AA00);
          await tester.pumpWidget(
            styled(
              const VButtonGroupStyle(borderColor: groupColor),
              viaTheme: viaTheme,
              // The group wins over the theme's button border color.
              themeStyles: const [VButtonStyle(borderColor: Color(0xFFAA0000))],
            ),
          );

          for (final key in keys) {
            expect(borderColorOf(tester, key), groupColor, reason: '$key');
          }
        });

        testWidgets('a button instance style wins over the group borderColor '
            '($via)', (tester) async {
          const own = Color(0xFF0000AA);
          await tester.pumpWidget(
            styled(
              const VButtonGroupStyle(borderColor: Color(0xFF00AA00)),
              viaTheme: viaTheme,
              buttonStyles: const [
                VButtonStyle(borderColor: own),
                null,
                null,
              ],
            ),
          );

          expect(borderColorOf(tester, keys.first), own);
          expect(borderColorOf(tester, keys[1]), const Color(0xFF00AA00));
        });
      }

      testWidgets('without a style, the size radius and the variant border '
          'draw the group', (tester) async {
        await tester.pumpWidget(
          styled(const VButtonGroupStyle(), viaTheme: false),
        );

        final r = Radius.circular(theme.sizes.md.borderRadius);
        expect(
          decorationOf(tester, keys.first).borderRadius,
          BorderRadius.only(topLeft: r, bottomLeft: r),
        );
        expect(borderColorOf(tester, keys.first), theme.colors.primary);
      });
    });

    testWidgets('size reaches buttons without a size of their own', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        buildTestWidget(
          Column(
            children: [
              VButtonGroup(
                size: VButtonSize.sm,
                children: [
                  VButton(
                    key: const Key('inherits'),
                    onPressed: () {},
                    child: const Text('A'),
                  ),
                  VButton(
                    key: const Key('own'),
                    size: VButtonSize.lg,
                    onPressed: () {},
                    child: const Text('B'),
                  ),
                ],
              ),
              VButton(
                key: const Key('outside'),
                onPressed: () {},
                child: const Text('C'),
              ),
            ],
          ),
        ),
      );

      double heightOf(String key) =>
          tester.getSize(find.byKey(Key(key))).height;
      double fontSizeOf(String text) => tester
          .widget<RichText>(
            find.descendant(
              of: find.text(text),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!
          .fontSize!;

      expect(heightOf('inherits'), theme.sizes.sm.height);
      expect(fontSizeOf('A'), theme.sizes.sm.fontSize);
      // The button's own size wins over the group's.
      expect(heightOf('own'), theme.sizes.lg.height);
      // Outside a group the default is medium.
      expect(heightOf('outside'), theme.sizes.md.height);
    });
  });
}
