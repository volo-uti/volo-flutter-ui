import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VCheckListTile', () {
    testWidgets('creates default check list tile', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: Text('Receive Notifications'),
              value: false,
            ),
          ),
        ),
      );

      expect(find.byType(VCheckListTile), findsOneWidget);
      expect(find.text('Receive Notifications'), findsOneWidget);
    });

    testWidgets('displays subtitle', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: Text('Receive Notifications'),
              subtitle: Text('Receive latest news'),
              value: false,
            ),
          ),
        ),
      );

      expect(find.text('Receive Notifications'), findsOneWidget);
      expect(find.text('Receive latest news'), findsOneWidget);
    });

    testWidgets('onChanged callback', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: const Text('Receive Notifications'),
              value: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VCheckListTile));
      expect(changedValue, isTrue);
    });

    testWidgets('disabled state', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: const Text('Receive Notifications'),
              value: false,
              enabled: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VCheckListTile));
      expect(changedValue, isNull);
    });

    testWidgets('leading variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile.leading(
              title: Text('Receive Notifications'),
              value: true,
            ),
          ),
        ),
      );

      expect(find.byType(VCheckListTile), findsOneWidget);
      expect(find.byType(VCheckbox), findsOneWidget);
    });

    testWidgets('card variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile.card(
              title: Text('Receive Notifications'),
              value: false,
            ),
          ),
        ),
      );

      expect(find.byType(VCheckListTile), findsOneWidget);
    });

    testWidgets('tristate support', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: const Text('Select All'),
              value: true,
              tristate: true,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VCheckListTile));
      expect(changedValue, isNull);
    });

    testWidgets('secondary widget', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: Text('Receive Notifications'),
              value: false,
              secondary: Text('icon'),
            ),
          ),
        ),
      );

      expect(find.text('icon'), findsOneWidget);
    });

    testWidgets('selected state', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCheckListTile(
              title: Text('Receive Notifications'),
              value: true,
              selected: true,
            ),
          ),
        ),
      );

      expect(find.byType(VCheckListTile), findsOneWidget);
    });

    testWidgets('Text title and subtitle receive the tile text styles', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        VTheme(
          data: theme,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(),
              child: VCheckListTile(
                title: Text('Styled Title'),
                subtitle: Text('Styled Subtitle'),
                value: false,
              ),
            ),
          ),
        ),
      );

      TextStyle styleOf(String text) => tester
          .widget<RichText>(
            find.descendant(
              of: find.text(text),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;

      final title = styleOf('Styled Title');
      expect(title.color, theme.colors.foreground);
      expect(title.fontSize, theme.typography.bodyLarge.fontSize);
      final subtitle = styleOf('Styled Subtitle');
      expect(subtitle.color, theme.colors.mutedForeground);
      expect(subtitle.fontSize, theme.typography.bodyMedium.fontSize);
    });
  });

  group('keyboard activation', () {
    testWidgets('Enter and Space press a focused check tile', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VCheckListTile(
                title: const Text('Title'),
                value: false,
                onChanged: (_) => taps++,
              ),
            ),
          ),
        ),
      );
      Focus.of(tester.element(find.text('Title'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);

      expect(taps, 2);
    });
  });

  Widget looseHost(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Align(alignment: Alignment.topCenter, child: child),
      ),
    ),
  );

  group('VCheckListTile semantics and layout', () {
    testWidgets('the row is one node, not a row plus an inner control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        looseHost(
          VCheckListTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(VCheckListTile));
      expect(node.label, 'Alerts');
      expect(node.childrenCount, 0);
      handle.dispose();
    });

    testWidgets('hugs its content in a loose parent', (tester) async {
      await tester.pumpWidget(
        looseHost(
          VCheckListTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.getSize(find.byType(VCheckListTile)).height, lessThan(120));
    });
  });

  group('VCheckListTile style fields', () {
    final theme = VThemeData.light();

    // Applies [style] through the theme or as the instance style, on top of
    // an optional theme checkbox style.
    Widget styled(
      VCheckListTileStyle? style, {
      bool viaTheme = false,
      VCheckboxStyle? checkboxTheme,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
          ?checkboxTheme,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: VCheckListTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
            style: viaTheme ? null : style,
          ),
        ),
      ),
    );

    Color? boxColorOf(WidgetTester tester) =>
        (tester
                    .widget<AnimatedContainer>(
                      find.descendant(
                        of: find.byType(VCheckbox),
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .decoration!
                as BoxDecoration)
            .color;

    testWidgets('the checkbox keeps its own color by default', (tester) async {
      await tester.pumpWidget(styled(null));
      expect(boxColorOf(tester), theme.colors.primary);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('activeColor fills the checked box ($via)', (tester) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(
            const VCheckListTileStyle(activeColor: color),
            viaTheme: viaTheme,
            checkboxTheme: const VCheckboxStyle(activeColor: Color(0xFFFF0000)),
          ),
        );
        expect(boxColorOf(tester), color);
      });
    }
  });
}
