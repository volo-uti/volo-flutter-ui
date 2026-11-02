import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VIconButton', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VIconButton', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VIconButton(icon: const Text('🔍'), onPressed: () {})),
      );

      expect(find.text('🔍'), findsOneWidget);
    });

    testWidgets('VIconButton.filled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton.filled(icon: const Text('➕'), onPressed: () {}),
        ),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VIconButton.outlined', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton.outlined(icon: const Text('⚙'), onPressed: () {}),
        ),
      );

      expect(find.text('⚙'), findsOneWidget);
    });

    testWidgets('invokes onPressed callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(icon: const Text('🔍'), onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.text('🔍'));
      expect(tapped, true);
    });

    testWidgets('ignores tap when enabled=false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(
            icon: const Text('🔍'),
            onPressed: () => tapped = true,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.text('🔍'));
      expect(tapped, false);
    });

    testWidgets('selected toggle', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(
            icon: const Text('♡'),
            selectedIcon: const Text('❤'),
            isSelected: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('❤'), findsOneWidget);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to icon button', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VIconButtonStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VIconButton(icon: const Text('X'), onPressed: () {}),
            ),
          ),
        );

        expect(find.byType(VIconButton), findsOneWidget);
      });
    });

    group('style fields', () {
      final theme = VThemeData.light();

      // Applies [style] through the theme or as the instance style.
      Widget styled(
        VIconButtonStyle style, {
        required bool viaTheme,
        required Widget Function(VIconButtonStyle? instanceStyle) build,
      }) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: build(viaTheme ? null : style)),
        ),
      );

      Color? backgroundOf(WidgetTester tester) =>
          (tester
                      .widget<AnimatedContainer>(
                        find.descendant(
                          of: find.byType(VIconButton),
                          matching: find.byType(AnimatedContainer),
                        ),
                      )
                      .decoration!
                  as BoxDecoration)
              .color;

      Widget icon() => VIcons.search(
        color: theme.colors.primary,
        size: theme.sizes.md.iconSize,
      );

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('padding moves the icon inside a fixed button ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              const VIconButtonStyle(padding: EdgeInsets.only(left: 12)),
              viaTheme: viaTheme,
              build: (s) =>
                  VIconButton(style: s, onPressed: () {}, icon: icon()),
            ),
          );

          final button = find.byType(VIconButton);
          final glyph = find.descendant(
            of: button,
            matching: find.byType(CustomPaint),
          );
          expect(
            tester.getSize(button),
            Size(theme.sizes.md.height, theme.sizes.md.height),
          );
          expect(
            tester.getCenter(glyph.last).dx - tester.getCenter(button).dx,
            6,
          );
        });

        testWidgets('overlayColor covers the background on hover and press '
            '($via)', (tester) async {
          const overlay = Color(0x40000000);
          await tester.pumpWidget(
            styled(
              const VIconButtonStyle(overlayColor: overlay),
              viaTheme: viaTheme,
              build: (s) =>
                  VIconButton.filled(style: s, onPressed: () {}, icon: icon()),
            ),
          );
          final blended = Color.alphaBlend(overlay, theme.colors.primary);
          expect(backgroundOf(tester), theme.colors.primary);

          final center = tester.getCenter(find.byType(VIconButton));
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          addTearDown(mouse.removePointer);
          await mouse.moveTo(center);
          await tester.pump();
          expect(backgroundOf(tester), blended);

          await mouse.moveTo(Offset.zero);
          await tester.pump();
          expect(backgroundOf(tester), theme.colors.primary);

          final press = await tester.startGesture(center);
          await tester.pump();
          expect(backgroundOf(tester), blended);
          await press.up();
          await tester.pumpAndSettle();
          expect(backgroundOf(tester), theme.colors.primary);
        });
      }
    });
  });
}
