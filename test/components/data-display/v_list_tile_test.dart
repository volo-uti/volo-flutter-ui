import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VListTile', () {
    testWidgets('creates default list tile', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(title: Text('Title')),
          ),
        ),
      );

      expect(find.byType(VListTile), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('displays subtitle', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(title: Text('Title'), subtitle: Text('Subtitle')),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('leading widget', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(title: Text('Title'), leading: Icon(Icons.person)),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('trailing widget', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(
              title: Text('Title'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(
              title: const Text('Title'),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VListTile));
      expect(tapped, isTrue);
    });

    testWidgets('onLongPress callback', (tester) async {
      var longPressed = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(
              title: const Text('Title'),
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(VListTile));
      expect(longPressed, isTrue);
    });

    testWidgets('disabled state', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(
              title: const Text('Title'),
              enabled: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VListTile));
      expect(tapped, isFalse);
    });

    testWidgets('dense variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile.dense(title: Text('Compact')),
          ),
        ),
      );

      expect(find.byType(VListTile), findsOneWidget);
    });

    testWidgets('threeLine variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile.threeLine(
              title: Text('Title'),
              subtitle: Text('First line\nSecond line'),
            ),
          ),
        ),
      );

      expect(find.byType(VListTile), findsOneWidget);
    });

    testWidgets('selected state', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VListTile(title: Text('Title'), selected: true),
          ),
        ),
      );

      expect(find.byType(VListTile), findsOneWidget);
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
              child: VListTile(
                title: Text('Styled Title'),
                subtitle: Text('Styled Subtitle'),
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
    testWidgets('Enter and Space press a focused list tile', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VListTile(title: const Text('Title'), onTap: () => taps++),
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

  group('semantics', () {
    Semantics semanticsOf(WidgetTester tester) => tester.widget<Semantics>(
      find
          .descendant(
            of: find.byType(VListTile),
            matching: find.byWidgetPredicate(
              (w) => w is Semantics && w.properties.enabled != null,
            ),
          )
          .first,
    );

    Future<void> pump(WidgetTester tester, VListTile tile) => tester.pumpWidget(
      VTheme(
        data: VThemeData.light(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: tile),
        ),
      ),
    );

    testWidgets('an unselected tile announces no selected state', (
      tester,
    ) async {
      await pump(tester, const VListTile(title: Text('Title')));
      expect(semanticsOf(tester).properties.selected, isNull);

      await pump(tester, const VListTile(title: Text('Title'), selected: true));
      expect(semanticsOf(tester).properties.selected, isTrue);
    });

    testWidgets('a tile with only onLongPress is a button', (tester) async {
      await pump(
        tester,
        VListTile(title: const Text('Title'), onLongPress: () {}),
      );
      expect(semanticsOf(tester).properties.button, isTrue);
    });
  });
}
