import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VSection', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('text styles', () {
      TextStyle styleOf(WidgetTester tester, String text) =>
          DefaultTextStyle.of(tester.element(find.text(text))).style;

      testWidgets('plain header Text takes the title style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(header: Text('Header'), children: [Text('Item')]),
          ),
        );

        final theme = VThemeData.light();
        expect(
          styleOf(tester, 'Header').fontSize,
          theme.typography.titleSmall.fontSize,
        );
        expect(styleOf(tester, 'Header').color, theme.colors.foreground);
      });

      testWidgets('plain footer Text takes the muted caption style', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(footer: Text('Footer'), children: [Text('Item')]),
          ),
        );

        final theme = VThemeData.light();
        expect(
          styleOf(tester, 'Footer').fontSize,
          theme.typography.bodySmall.fontSize,
        );
        expect(styleOf(tester, 'Footer').color, theme.colors.mutedForeground);
      });

      testWidgets('header keeps the style a child sets itself', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              header: DefaultTextStyle(
                style: TextStyle(fontSize: 31),
                child: Text('Header'),
              ),
              children: [Text('Item')],
            ),
          ),
        );

        expect(styleOf(tester, 'Header').fontSize, 31);
      });

      testWidgets('VSectionHeader title and subtitle take their styles', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSectionHeader(
              title: Text('Title'),
              subtitle: Text('Subtitle'),
            ),
          ),
        );

        final theme = VThemeData.light();
        expect(styleOf(tester, 'Title').color, theme.colors.foreground);
        expect(styleOf(tester, 'Subtitle').color, theme.colors.mutedForeground);
      });

      testWidgets('VSectionHeader and VSectionFooter merge into the inherited '
          'text style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const DefaultTextStyle(
              style: TextStyle(decoration: TextDecoration.underline),
              child: Column(
                children: [
                  VSectionHeader(title: Text('Title')),
                  VSectionFooter(child: Text('Footer')),
                ],
              ),
            ),
          ),
        );

        expect(styleOf(tester, 'Title').decoration, TextDecoration.underline);
        expect(styleOf(tester, 'Footer').decoration, TextDecoration.underline);
      });

      testWidgets('VSectionFooter child takes the muted caption style', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VSectionFooter(child: Text('Footer'))),
        );

        expect(
          styleOf(tester, 'Footer').color,
          VThemeData.light().colors.mutedForeground,
        );
      });
    });

    group('default constructor', () {
      testWidgets('creates VSection', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(children: [Text('Item 1'), Text('Item 2')]),
          ),
        );

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('displays header Widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(header: Text('Header'), children: [Text('Item')]),
          ),
        );

        expect(find.text('Header'), findsOneWidget);
      });

      testWidgets('displays header plain Text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              header: Text('String Header'),
              children: [Text('Item')],
            ),
          ),
        );

        expect(find.text('String Header'), findsOneWidget);
      });

      testWidgets('displays footer Widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(footer: Text('Footer'), children: [Text('Item')]),
          ),
        );

        expect(find.text('Footer'), findsOneWidget);
      });

      testWidgets('displays footer plain Text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              footer: Text('String Footer'),
              children: [Text('Item')],
            ),
          ),
        );

        expect(find.text('String Footer'), findsOneWidget);
      });

      testWidgets('displays both header and footer', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              header: Text('Header'),
              footer: Text('Footer'),
              children: [Text('Item')],
            ),
          ),
        );

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Item'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);
      });

      testWidgets('displays divider', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              divider: true,
              children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
            ),
          ),
        );

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });
    });

    group('VSection.card', () {
      testWidgets('applies card style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection.card(children: [Text('Card Section')]),
          ),
        );

        expect(find.text('Card Section'), findsOneWidget);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final decoratedContainers = containers.where(
          (c) => c.decoration != null,
        );
        expect(decoratedContainers, isNotEmpty);
      });
    });

    group('VSection.inset', () {
      testWidgets('applies inset', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection.inset(children: [Text('Inset Section')]),
          ),
        );

        expect(find.text('Inset Section'), findsOneWidget);
      });
    });

    group('custom properties', () {
      testWidgets('applies padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              padding: EdgeInsets.all(24),
              children: [Text('Padded Section')],
            ),
          ),
        );

        expect(find.text('Padded Section'), findsOneWidget);
      });

      testWidgets('applies margin', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              margin: EdgeInsets.all(16),
              children: [Text('Margin Section')],
            ),
          ),
        );

        expect(find.text('Margin Section'), findsOneWidget);
      });

      testWidgets('applies backgroundColor', (tester) async {
        const customColor = Color(0xFFFF0000);

        await tester.pumpWidget(
          buildTestWidget(
            const VSection(
              backgroundColor: customColor,
              children: [Text('Background Section')],
            ),
          ),
        );

        expect(find.text('Background Section'), findsOneWidget);
      });

      testWidgets('applies borderRadius', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VSection.card(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              children: [Text('Rounded Section')],
            ),
          ),
        );

        expect(find.text('Rounded Section'), findsOneWidget);
      });
    });

    testWidgets('applies Semantics container', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSection(children: [Text('Semantic')])),
      );

      expect(find.byType(Semantics), findsOneWidget);
    });
  });

  group('VSectionHeader', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('displays title Widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSectionHeader(title: Text('Title'))),
      );

      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('displays title plain Text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSectionHeader(title: Text('String Title'))),
      );

      expect(find.text('String Title'), findsOneWidget);
    });

    testWidgets('displays subtitle Widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSectionHeader(
            title: Text('Title'),
            subtitle: Text('Subtitle'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('displays subtitle plain Text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSectionHeader(
            title: Text('Title'),
            subtitle: Text('String Subtitle'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('String Subtitle'), findsOneWidget);
    });

    testWidgets('displays trailing', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSectionHeader(
            title: Text('Title'),
            trailing: Text('See More'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('See More'), findsOneWidget);
    });

    testWidgets('applies padding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSectionHeader(
            title: Text('Title'),
            padding: EdgeInsets.all(16),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.all(16));
    });
  });

  group('VSectionFooter', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('displays child Widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSectionFooter(child: Text('Footer Content'))),
      );

      expect(find.text('Footer Content'), findsOneWidget);
    });

    testWidgets('displays child String', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSectionFooter(child: Text('String Footer'))),
      );

      expect(find.text('String Footer'), findsOneWidget);
    });

    testWidgets('applies padding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSectionFooter(
            padding: EdgeInsets.all(8),
            child: Text('Footer'),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, const EdgeInsets.all(8));
    });
  });

  group('VSection precedence', () {
    Widget themed(Widget child, VComponentStyle style) => VTheme(
      data: VThemeData.light().copyWith(
        componentOverrides: VComponentOverrides([style]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    Container containerOf(WidgetTester tester) => tester.widget<Container>(
      find
          .descendant(
            of: find.byType(VSection),
            matching: find.byType(Container),
          )
          .first,
    );

    testWidgets('explicit padding and color beat the theme override', (
      tester,
    ) async {
      await tester.pumpWidget(
        themed(
          const VSection(
            padding: EdgeInsets.all(2),
            backgroundColor: Color(0xFFFF0000),
            children: [Text('Item')],
          ),
          const VSectionStyle(
            padding: EdgeInsets.all(30),
            backgroundColor: Color(0xFF00FF00),
          ),
        ),
      );

      final container = containerOf(tester);
      expect(container.padding, const EdgeInsets.all(2));
      expect(
        (container.decoration! as BoxDecoration).color,
        const Color(0xFFFF0000),
      );
    });

    testWidgets('the theme override applies without explicit values', (
      tester,
    ) async {
      await tester.pumpWidget(
        themed(
          const VSection(children: [Text('Item')]),
          const VSectionStyle(padding: EdgeInsets.all(30)),
        ),
      );

      expect(containerOf(tester).padding, const EdgeInsets.all(30));
    });
  });
}
