import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
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

  group('VListTile layout', () {
    testWidgets('hugs its content in a loose parent', (tester) async {
      await tester.pumpWidget(
        looseHost(const VListTile(title: Text('Alerts'))),
      );

      expect(tester.getSize(find.byType(VListTile)).height, lessThan(120));
    });
  });

  group('VListTileStyle layout fields', () {
    Widget host(Widget child, {VThemeData? theme}) => VTheme(
      data: theme ?? VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 320, child: child),
          ),
        ),
      ),
    );

    // The text column fills the space between the leading and trailing gaps.
    Rect textColumn(WidgetTester tester) => tester.getRect(
      find.descendant(
        of: find.byType(VListTile),
        matching: find.byType(Column),
      ),
    );

    const leadingKey = Key('leading');
    const trailingKey = Key('trailing');
    const leading = SizedBox(key: leadingKey, width: 24, height: 24);
    const trailing = SizedBox(key: trailingKey, width: 24, height: 24);

    testWidgets('defaults keep the 40px slot, 16px gaps and 56px height', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        host(
          const VListTile(
            leading: leading,
            title: Text('Title'),
            trailing: trailing,
          ),
        ),
      );

      final padding = theme.spacing.lg;
      final slot = theme.sizes.md.height;
      final title = tester.getRect(find.text('Title'));
      expect(title.left, padding + slot + theme.spacing.lg);
      expect(
        tester.getRect(find.byKey(trailingKey)).left,
        textColumn(tester).right + theme.spacing.lg,
      );
      expect(tester.getSize(find.byType(VListTile)).height, 56);
    });

    testWidgets('style sets the leading width, both gaps and min height', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const VListTile(
            leading: leading,
            title: Text('Title'),
            trailing: trailing,
            style: VListTileStyle(
              leadingWidth: 24,
              leadingGap: 8,
              trailingGap: 4,
              minHeight: 64,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      );

      final title = tester.getRect(find.text('Title'));
      expect(title.left, 24 + 8);
      expect(
        tester.getRect(find.byKey(trailingKey)).left,
        textColumn(tester).right + 4,
      );
      expect(tester.getSize(find.byType(VListTile)).height, 64);
    });

    testWidgets('minHeight replaces the dense and three-line minimums', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              VListTile.dense(
                key: Key('dense'),
                title: Text('Dense'),
                style: VListTileStyle(minHeight: 40),
              ),
              VListTile.threeLine(
                key: Key('three'),
                title: Text('Three'),
                style: VListTileStyle(minHeight: 60),
              ),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byKey(const Key('dense'))).height, 40);
      expect(tester.getSize(find.byKey(const Key('three'))).height, 60);
    });

    testWidgets('a theme override applies and an instance style wins', (
      tester,
    ) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VListTileStyle(leadingWidth: 24, leadingGap: 8, minHeight: 64),
        ]),
      );
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              VListTile(
                key: Key('theme'),
                leading: leading,
                title: Text('Theme'),
                style: VListTileStyle(padding: EdgeInsets.zero),
              ),
              VListTile(
                key: Key('instance'),
                leading: leading,
                title: Text('Instance'),
                style: VListTileStyle(
                  padding: EdgeInsets.zero,
                  leadingGap: 2,
                  minHeight: 50,
                ),
              ),
            ],
          ),
          theme: theme,
        ),
      );

      expect(tester.getRect(find.text('Theme')).left, 24 + 8);
      expect(tester.getSize(find.byKey(const Key('theme'))).height, 64);
      expect(tester.getRect(find.text('Instance')).left, 24 + 2);
      expect(tester.getSize(find.byKey(const Key('instance'))).height, 50);
    });

    testWidgets('a leading widget taller than the slot is not squeezed', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const VListTile(
            leading: SizedBox(key: leadingKey, width: 56, height: 56),
            title: Text('Title'),
            style: VListTileStyle(leadingWidth: 56),
          ),
        ),
      );

      expect(tester.getSize(find.byKey(leadingKey)), const Size(56, 56));
      expect(tester.takeException(), isNull);
    });
  });

  group('VListTile text lines', () {
    Widget host(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 200, child: child),
          ),
        ),
      ),
    );

    const long = 'A title long enough to wrap onto several lines here';

    testWidgets('a plain Text stops at one line with an ellipsis', (
      tester,
    ) async {
      await tester.pumpWidget(host(const VListTile(title: Text(long))));

      final paragraph = tester.renderObject<RenderParagraph>(find.text(long));
      expect(paragraph.didExceedMaxLines, isTrue);
      expect(paragraph.maxLines, 1);
    });

    testWidgets('a Text with its own maxLines keeps it', (tester) async {
      await tester.pumpWidget(
        host(const VListTile(title: Text(long, maxLines: 3))),
      );

      final paragraph = tester.renderObject<RenderParagraph>(find.text(long));
      expect(paragraph.maxLines, 3);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a long trailing in a ConstrainedBox leaves the title room', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          VListTile(
            title: const Text('Title'),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 60),
              child: const Text('A long trailing value'),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.text('A long trailing value')).width,
        lessThanOrEqualTo(60),
      );
    });
  });
}
