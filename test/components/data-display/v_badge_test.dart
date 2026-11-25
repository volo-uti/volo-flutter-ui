// ignore: deprecated_member_use
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VBadge', () {
    testWidgets('creates default badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('New')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('primary badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.primary(label: Text('Important')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('destructive badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.destructive(label: Text('Error')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('outline badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.outline(label: Text('Outlined')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('semanticLabel replaces the text for screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('5'), semanticLabel: '5 unread'),
          ),
        ),
      );

      expect(find.bySemanticsLabel('5 unread'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('invisible badge renders nothing', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('5'), invisible: true),
          ),
        ),
      );

      expect(find.text('5'), findsNothing);
    });

    testWidgets('count shows the number, capped at max', (tester) async {
      Future<void> pump(VBadge badge) => tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: badge),
        ),
      );

      await pump(VBadge.count(count: 5));
      expect(find.text('5'), findsOneWidget);

      await pump(VBadge.count(count: 120));
      expect(find.text('99+'), findsOneWidget);

      await pump(VBadge.count(count: 12, max: 9));
      expect(find.text('9+'), findsOneWidget);

      await pump(VBadge.count(count: 99));
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('count clamps negative counts and a max below 1', (
      tester,
    ) async {
      Future<void> pump(VBadge badge) => tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: badge),
        ),
      );

      await pump(VBadge.count(count: -5));
      expect(find.text('0'), findsOneWidget);

      await pump(VBadge.count(count: 5, max: -1));
      expect(find.text('1+'), findsOneWidget);
      expect(find.text('-1+'), findsNothing);
    });

    testWidgets('renders with each size', (tester) async {
      for (final size in VBadgeSize.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VBadge(label: const Text('Test'), size: size),
            ),
          ),
        );

        expect(find.byType(VBadge), findsOneWidget);
      }
    });

    testWidgets('supports Widget child', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.check, size: 12), Text('Done')],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to badge', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VBadgeStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VBadge(label: Text('New')),
            ),
          ),
        );

        expect(find.byType(VBadge), findsOneWidget);
      });
    });
  });

  group('VBadgeStyle.textStyle', () {
    TextStyle labelStyle(WidgetTester tester, String text) =>
        tester.renderObject<RenderParagraph>(find.text(text)).text.style!;

    Widget frame(Widget child, {VThemeData? theme}) => VTheme(
      data: theme ?? VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('sets size, weight and line height over the defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        frame(
          const VBadge.primary(
            label: Text('New'),
            style: VBadgeStyle(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ),
      );

      final style = labelStyle(tester, 'New');
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.height, 1.5);
      expect(style.color, VThemeData.light().colors.primaryForeground);
    });

    testWidgets('keeps the defaults it does not set', (tester) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        frame(
          const VBadge(
            label: Text('New'),
            style: VBadgeStyle(textStyle: TextStyle(letterSpacing: 2)),
          ),
        ),
      );

      final style = labelStyle(tester, 'New');
      expect(style.letterSpacing, 2);
      expect(style.fontSize, theme.sizes.sm.fontSize);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.height, 1.15);
      expect(style.color, theme.colors.mutedForeground);
    });

    testWidgets('foregroundColor wins over the text style color', (
      tester,
    ) async {
      await tester.pumpWidget(
        frame(
          const VBadge(
            label: Text('New'),
            style: VBadgeStyle(
              foregroundColor: Color(0xFF00FF00),
              textStyle: TextStyle(color: Color(0xFFFF0000)),
            ),
          ),
        ),
      );

      expect(labelStyle(tester, 'New').color, const Color(0xFF00FF00));
    });

    testWidgets('the text style color applies without foregroundColor', (
      tester,
    ) async {
      await tester.pumpWidget(
        frame(
          const VBadge(
            label: Text('New'),
            style: VBadgeStyle(textStyle: TextStyle(color: Color(0xFFFF0000))),
          ),
        ),
      );

      expect(labelStyle(tester, 'New').color, const Color(0xFFFF0000));
    });

    testWidgets('a theme override sets it and an instance style replaces it', (
      tester,
    ) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VBadgeStyle(textStyle: TextStyle(fontWeight: FontWeight.w700)),
        ]),
      );
      await tester.pumpWidget(
        frame(
          const Row(
            children: [
              VBadge(label: Text('Theme')),
              VBadge(
                label: Text('Instance'),
                style: VBadgeStyle(textStyle: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          theme: theme,
        ),
      );

      expect(labelStyle(tester, 'Theme').fontWeight, FontWeight.w700);
      final instance = labelStyle(tester, 'Instance');
      expect(instance.fontSize, 20);
      expect(instance.fontWeight, FontWeight.w500);
    });
  });

  group('VBadge borderColor and padding', () {
    Widget host(Widget child, {VThemeData? data}) => VTheme(
      data: data ?? VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    Container containerOf(WidgetTester tester) => tester.widget<Container>(
      find.descendant(
        of: find.byType(VBadge),
        matching: find.byType(Container),
      ),
    );

    testWidgets('outline border defaults to the theme border color', (
      tester,
    ) async {
      final data = VThemeData.light();
      await tester.pumpWidget(
        host(const VBadge.outline(label: Text('x')), data: data),
      );
      final box = containerOf(tester).decoration! as BoxDecoration;
      expect((box.border! as Border).top.color, data.colors.border);
    });

    testWidgets('style borderColor and padding apply', (tester) async {
      const color = Color(0xFF00AA00);
      await tester.pumpWidget(
        host(
          const VBadge.outline(
            label: Text('x'),
            style: VBadgeStyle(borderColor: color, padding: EdgeInsets.all(11)),
          ),
        ),
      );
      final c = containerOf(tester);
      expect(
        ((c.decoration! as BoxDecoration).border! as Border).top.color,
        color,
      );
      expect(c.padding, const EdgeInsets.all(11));
    });

    testWidgets('theme override applies', (tester) async {
      const color = Color(0xFF00AA00);
      await tester.pumpWidget(
        host(
          const VBadge.outline(label: Text('x')),
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VBadgeStyle(borderColor: color, padding: EdgeInsets.all(9)),
            ]),
          ),
        ),
      );
      final c = containerOf(tester);
      expect(
        ((c.decoration! as BoxDecoration).border! as Border).top.color,
        color,
      );
      expect(c.padding, const EdgeInsets.all(9));
    });

    test('style copyWith, merge and equality cover the new fields', () {
      const a = VBadgeStyle(borderColor: Color(0xFF000000));
      const b = VBadgeStyle(padding: EdgeInsets.all(2));
      final m = a.merge(b);
      expect(m.borderColor, const Color(0xFF000000));
      expect(m.padding, const EdgeInsets.all(2));
      expect(m, a.copyWith(padding: const EdgeInsets.all(2)));
      expect(m == a, isFalse);
    });
  });
}
