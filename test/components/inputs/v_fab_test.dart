import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFab', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFab', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.small', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab.small(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.large', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab.large(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.extended', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFab.extended(
            icon: const Text('➕'),
            label: const Text('Add'),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('➕'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('invokes onPressed callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VFab(icon: const Text('➕'), onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.text('➕'));
      expect(tapped, true);
    });

    testWidgets('disabled when onPressed=null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VFab(icon: Text('➕'))));

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('ignores tap when enabled=false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VFab(
            icon: const Text('➕'),
            onPressed: () => tapped = true,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.text('➕'));
      expect(tapped, false);
    });
  });

  group('VFab style fields', () {
    final theme = VThemeData.light();
    const shadow = BoxShadow(blurRadius: 3);

    // Builds an extended FAB styled through the theme or as the instance
    // style.
    Widget styled(
      VFabStyle? style, {
      bool viaTheme = false,
      double? elevation,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: VFab.extended(
            icon: const Text('+'),
            label: const Text('New'),
            elevation: elevation,
            onPressed: () {},
            style: viaTheme ? null : style,
          ),
        ),
      ),
    );

    BoxDecoration decorationOf(WidgetTester tester) =>
        tester
                .widget<Container>(
                  find
                      .descendant(
                        of: find.byType(VFab),
                        matching: find.byType(Container),
                      )
                      .first,
                )
                .decoration!
            as BoxDecoration;

    Color? textColor(WidgetTester tester, String text) => tester
        .widget<RichText>(
          find.descendant(of: find.text(text), matching: find.byType(RichText)),
        )
        .text
        .style
        ?.color;

    testWidgets('defaults to the medium shadow, large while pressed', (
      tester,
    ) async {
      await tester.pumpWidget(styled(null));
      expect(decorationOf(tester).boxShadow, theme.shadows.md);

      final press = await tester.startGesture(
        tester.getCenter(find.byType(VFab)),
      );
      await tester.pump();
      expect(decorationOf(tester).boxShadow, theme.shadows.lg);
      await press.up();
      await tester.pumpAndSettle();
    });

    testWidgets('the icon takes the foreground color by default', (
      tester,
    ) async {
      await tester.pumpWidget(styled(null));
      expect(textColor(tester, '+'), theme.colors.primaryForeground);
      expect(textColor(tester, 'New'), theme.colors.primaryForeground);
    });

    testWidgets('the instance elevation wins over shadows', (tester) async {
      await tester.pumpWidget(
        styled(const VFabStyle(shadows: [shadow]), elevation: 4),
      );
      expect(decorationOf(tester).boxShadow, isNot([shadow]));
      expect(decorationOf(tester).boxShadow, hasLength(1));
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('shadows replace the resting and pressed shadow ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(const VFabStyle(shadows: [shadow]), viaTheme: viaTheme),
        );
        expect(decorationOf(tester).boxShadow, [shadow]);

        final press = await tester.startGesture(
          tester.getCenter(find.byType(VFab)),
        );
        await tester.pump();
        expect(decorationOf(tester).boxShadow, [shadow]);
        await press.up();
        await tester.pumpAndSettle();
      });

      testWidgets('overlayColor covers the fill on hover and press ($via)', (
        tester,
      ) async {
        const overlay = Color(0x40000000);
        await tester.pumpWidget(
          styled(const VFabStyle(overlayColor: overlay), viaTheme: viaTheme),
        );
        final blended = Color.alphaBlend(overlay, theme.colors.primary);
        expect(decorationOf(tester).color, theme.colors.primary);

        final center = tester.getCenter(find.byType(VFab));
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(center);
        await tester.pump();
        expect(decorationOf(tester).color, blended);

        await mouse.moveTo(Offset.zero);
        await tester.pump();
        expect(decorationOf(tester).color, theme.colors.primary);

        final press = await tester.startGesture(center);
        await tester.pump();
        expect(decorationOf(tester).color, blended);
        await press.up();
        await tester.pumpAndSettle();
        expect(decorationOf(tester).color, theme.colors.primary);
      });

      testWidgets('iconColor tints the icon, not the label ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(const VFabStyle(iconColor: color), viaTheme: viaTheme),
        );
        expect(textColor(tester, '+'), color);
        expect(textColor(tester, 'New'), theme.colors.primaryForeground);
      });
    }

    testWidgets('a disabled FAB shows no overlay on hover', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: theme,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VFab(
                icon: Text('+'),
                style: VFabStyle(overlayColor: Color(0x40000000)),
              ),
            ),
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(VFab)));
      await tester.pump();
      expect(decorationOf(tester).color, theme.colors.primary);
    });
  });
}
