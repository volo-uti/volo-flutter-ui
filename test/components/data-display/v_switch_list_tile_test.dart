import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VSwitchListTile', () {
    testWidgets('creates default switch list tile', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(title: Text('Notifications'), value: false),
          ),
        ),
      );

      expect(find.byType(VSwitchListTile), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('displays subtitle', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(
              title: Text('Notifications'),
              subtitle: Text('Receive push notifications'),
              value: false,
            ),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Receive push notifications'), findsOneWidget);
    });

    testWidgets('onChanged callback', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(
              title: const Text('Notifications'),
              value: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSwitchListTile));
      expect(changedValue, isTrue);
    });

    testWidgets('disabled state', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(
              title: const Text('Notifications'),
              value: false,
              enabled: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSwitchListTile));
      expect(changedValue, isNull);
    });

    testWidgets('leading variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile.leading(
              title: Text('Notifications'),
              value: true,
            ),
          ),
        ),
      );

      expect(find.byType(VSwitchListTile), findsOneWidget);
      expect(find.byType(VSwitch), findsOneWidget);
    });

    testWidgets('card variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile.card(
              title: Text('Notifications'),
              value: false,
            ),
          ),
        ),
      );

      expect(find.byType(VSwitchListTile), findsOneWidget);
    });

    testWidgets('secondary widget', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(
              title: Text('Notifications'),
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
            child: VSwitchListTile(
              title: Text('Notifications'),
              value: true,
              selected: true,
            ),
          ),
        ),
      );

      expect(find.byType(VSwitchListTile), findsOneWidget);
    });

    testWidgets('value true state', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(title: Text('Notifications'), value: true),
          ),
        ),
      );

      expect(find.byType(VSwitchListTile), findsOneWidget);
      expect(find.byType(VSwitch), findsOneWidget);
    });

    testWidgets('supports Widget title', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSwitchListTile(title: Text('Custom Title'), value: false),
          ),
        ),
      );

      expect(find.text('Custom Title'), findsOneWidget);
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
              child: VSwitchListTile(
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
    testWidgets('Enter and Space press a focused switch tile', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VSwitchListTile(
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

  group('VSwitchListTile semantics and layout', () {
    testWidgets('the row is one node, not a row plus an inner control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        looseHost(
          VSwitchListTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(VSwitchListTile));
      expect(node.label, 'Alerts');
      expect(node.childrenCount, 0);
      handle.dispose();
    });

    testWidgets('hugs its content in a loose parent', (tester) async {
      await tester.pumpWidget(
        looseHost(
          VSwitchListTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(VSwitchListTile)).height,
        lessThan(120),
      );
    });
  });
}
