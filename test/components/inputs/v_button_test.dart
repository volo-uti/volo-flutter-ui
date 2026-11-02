import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VButton', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('child styling', () {
      testWidgets('plain Text child takes the button text style', (
        tester,
      ) async {
        final theme = VThemeData.light();
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              size: VButtonSize.lg,
              onPressed: () {},
              child: const Text('Styled'),
            ),
          ),
        );

        final style = tester
            .widget<RichText>(
              find.descendant(
                of: find.byType(VButton),
                matching: find.byType(RichText),
              ),
            )
            .text
            .style!;
        expect(style.color, theme.colors.primaryForeground);
        expect(style.fontSize, theme.sizes.lg.fontSize);
      });

      testWidgets('child sees the button icon theme', (tester) async {
        final theme = VThemeData.light();
        late IconThemeData iconTheme;
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              child: Builder(
                builder: (context) {
                  iconTheme = IconTheme.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(iconTheme.color, theme.colors.primaryForeground);
        expect(iconTheme.size, theme.sizes.md.iconSize);
      });
    });

    group('default constructor', () {
      testWidgets('creates VButton', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () {}, child: const Text('Button')),
          ),
        );

        expect(find.text('Button'), findsOneWidget);
      });

      testWidgets('renders a Text child', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () {}, child: const Text('Text Button')),
          ),
        );

        expect(find.text('Text Button'), findsOneWidget);
      });

      testWidgets('uses Widget child as-is', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Widget')],
              ),
            ),
          ),
        );

        expect(find.text('Widget'), findsOneWidget);
      });
    });

    group('variants', () {
      testWidgets('VButton.outlined', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton.outlined(onPressed: () {}, child: const Text('Outlined')),
          ),
        );

        expect(find.text('Outlined'), findsOneWidget);
      });

      testWidgets('VButton.text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton.text(onPressed: () {}, child: const Text('Text')),
          ),
        );

        expect(find.text('Text'), findsOneWidget);
      });

      testWidgets('VButton.icon', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton.icon(onPressed: () {}, child: const Text('🔍')),
          ),
        );

        expect(find.text('🔍'), findsOneWidget);
      });

      testWidgets('VButton.link', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton.link(onPressed: () {}, child: const Text('Link')),
          ),
        );

        expect(find.text('Link'), findsOneWidget);
      });
    });

    group('state', () {
      testWidgets('ignores tap when enabled=false', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () => tapped = true,
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        expect(tapped, false);
      });

      testWidgets('ignores tap when loading=true', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () => tapped = true,
              loading: true,
              loadingPosition: VButtonLoadingPosition.end,
              child: const Text('Loading'),
            ),
          ),
        );

        await tester.tap(find.text('Loading'));
        expect(tapped, false);
      });

      testWidgets('invokes onPressed callback', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () => tapped = true, child: const Text('Tap')),
          ),
        );

        await tester.tap(find.text('Tap'));
        expect(tapped, true);
      });
    });

    group('properties', () {
      testWidgets('displays leading', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              leading: const Text('→'),
              child: const Text('Button'),
            ),
          ),
        );

        expect(find.text('→'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
      });

      testWidgets('displays trailing', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              trailing: const Text('←'),
              child: const Text('Button'),
            ),
          ),
        );

        expect(find.text('←'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
      });

      testWidgets('takes full width when fullWidth=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Center(
              child: SizedBox(
                width: 300,
                child: VButton(
                  onPressed: () {},
                  fullWidth: true,
                  child: const Text('Full Width'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Full Width'), findsOneWidget);
      });
    });

    group('size', () {
      testWidgets('size=sm', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              size: VButtonSize.sm,
              child: const Text('Small'),
            ),
          ),
        );

        expect(find.text('Small'), findsOneWidget);
      });

      testWidgets('size=lg', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              size: VButtonSize.lg,
              child: const Text('Large'),
            ),
          ),
        );

        expect(find.text('Large'), findsOneWidget);
      });
    });

    group('color', () {
      testWidgets('color=destructive', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              color: VButtonColor.destructive,
              child: const Text('Delete'),
            ),
          ),
        );

        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('corner', () {
      testWidgets('corner=pill', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              corner: VButtonCorner.pill,
              child: const Text('Pill'),
            ),
          ),
        );

        expect(find.text('Pill'), findsOneWidget);
      });

      testWidgets('corner=square', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              corner: VButtonCorner.square,
              child: const Text('Square'),
            ),
          ),
        );

        expect(find.text('Square'), findsOneWidget);
      });

      testWidgets('corner=circle', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton.icon(
              onPressed: () {},
              corner: VButtonCorner.circle,
              child: const Text('★'),
            ),
          ),
        );

        expect(find.text('★'), findsOneWidget);
      });

      testWidgets('corner=rounded (default)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () {}, child: const Text('Rounded')),
          ),
        );

        expect(find.text('Rounded'), findsOneWidget);
      });
    });

    group('loading position', () {
      testWidgets('loadingPosition=center hides child', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              loading: true,
              child: const Text('Loading'),
            ),
          ),
        );

        // Child is not hidden during center loading (included in Row).
        expect(find.byType(VButton), findsOneWidget);
      });

      testWidgets('loadingPosition=start places loader at leading position', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              loading: true,
              loadingPosition: VButtonLoadingPosition.start,
              child: const Text('Loading'),
            ),
          ),
        );

        expect(find.text('Loading'), findsOneWidget);
      });

      testWidgets('loadingPosition=end places loader at trailing position', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              loading: true,
              loadingPosition: VButtonLoadingPosition.end,
              child: const Text('Loading'),
            ),
          ),
        );

        expect(find.text('Loading'), findsOneWidget);
      });
    });

    group('alignment', () {
      testWidgets('align=left', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              fullWidth: true,
              align: VButtonAlign.left,
              child: const Text('Left'),
            ),
          ),
        );

        expect(find.text('Left'), findsOneWidget);
      });

      testWidgets('align=center (default)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Center'),
            ),
          ),
        );

        expect(find.text('Center'), findsOneWidget);
      });

      testWidgets('align=right', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              fullWidth: true,
              align: VButtonAlign.right,
              child: const Text('Right'),
            ),
          ),
        );

        expect(find.text('Right'), findsOneWidget);
      });
    });

    group('color combinations', () {
      testWidgets('color=primary', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () {}, child: const Text('Primary')),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('color=secondary', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              color: VButtonColor.secondary,
              child: const Text('Secondary'),
            ),
          ),
        );

        expect(find.text('Secondary'), findsOneWidget);
      });

      testWidgets('color=tertiary', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              color: VButtonColor.tertiary,
              child: const Text('Tertiary'),
            ),
          ),
        );

        expect(find.text('Tertiary'), findsOneWidget);
      });
    });

    group('onLongPress', () {
      testWidgets('invokes onLongPress callback', (tester) async {
        var longPressed = false;

        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              onLongPress: () => longPressed = true,
              child: const Text('Long Press'),
            ),
          ),
        );

        await tester.longPress(find.text('Long Press'));
        expect(longPressed, true);
      });
    });

    group('disabled + loading combination', () {
      testWidgets('enabled=false + loading=true', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () => tapped = true,
              enabled: false,
              loading: true,
              child: const Text('Disabled + Loading'),
            ),
          ),
        );

        await tester.tap(find.byType(VButton));
        expect(tapped, false);
      });
    });

    group('accessibility', () {
      testWidgets('Semantics button=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(onPressed: () {}, child: const Text('Button')),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VButton));
        expect(semantics.getSemanticsData().flagsCollection.isButton, true);
      });

      testWidgets('Semantics enabled=false when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VButton));
        expect(
          semantics.getSemanticsData().flagsCollection.isEnabled,
          Tristate.isFalse,
        );
      });

      testWidgets('applies semanticLabel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              semanticLabel: 'Save Button',
              child: const Text('★'),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VButton));
        // Verify that semanticLabel is included (child widget text is also included).
        expect(semantics.label, contains('Save Button'));
      });
    });

    group('spacing', () {
      testWidgets('applies leadingGap', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              leading: const Text('→'),
              leadingGap: 16,
              child: const Text('Button'),
            ),
          ),
        );

        expect(find.text('→'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
      });

      testWidgets('applies trailingGap', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              trailing: const Text('←'),
              trailingGap: 16,
              child: const Text('Button'),
            ),
          ),
        );

        expect(find.text('←'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
      });
    });

    group('large text and narrow screens', () {
      final theme = VThemeData.light();

      // A 320 x 640 screen with text at twice the size.
      Future<void> pumpLargeText(WidgetTester tester, Widget child) async {
        tester.view
          ..physicalSize = const Size(320, 640)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: buildTestWidget(child),
          ),
        );
      }

      VComponentSize sizeToken(VButtonSize size) => switch (size) {
        VButtonSize.xs => theme.sizes.xs,
        VButtonSize.sm => theme.sizes.sm,
        VButtonSize.md => theme.sizes.md,
        VButtonSize.lg => theme.sizes.lg,
        VButtonSize.xl => theme.sizes.xl,
      };

      BoxDecoration decorationOf(WidgetTester tester, Finder button) =>
          tester
                  .widget<AnimatedContainer>(
                    find.descendant(
                      of: button,
                      matching: find.byType(AnimatedContainer),
                    ),
                  )
                  .decoration!
              as BoxDecoration;

      const longLabel = 'Save the changes to this document and close it';

      testWidgets('a long label wraps and the button grows at 320 wide, 2x', (
        tester,
      ) async {
        await pumpLargeText(
          tester,
          Center(
            child: VButton(
              onPressed: () {},
              leading: VIcons.check(
                color: theme.colors.primaryForeground,
                size: theme.sizes.md.iconSize,
              ),
              child: const Text(longLabel),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        final size = tester.getSize(find.byType(VButton));
        expect(size.width, lessThanOrEqualTo(320));
        expect(size.height, greaterThan(theme.sizes.md.height));
        // Two or more lines of the scaled font.
        expect(
          tester.getSize(find.text(longLabel)).height,
          greaterThanOrEqualTo(2 * 2 * theme.sizes.md.fontSize),
        );
      });

      testWidgets('a full-width long label wraps at 320 wide, 2x', (
        tester,
      ) async {
        await pumpLargeText(
          tester,
          VButton(
            onPressed: () {},
            fullWidth: true,
            child: const Text(longLabel),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(VButton)).height,
          greaterThan(theme.sizes.md.height),
        );
      });

      testWidgets('keeps the size token height at 1x text', (tester) async {
        for (final size in VButtonSize.values) {
          await tester.pumpWidget(
            buildTestWidget(
              Center(
                child: VButton(
                  // A new key per size, so the height does not animate.
                  key: ValueKey(size),
                  size: size,
                  onPressed: () {},
                  leading: VIcons.check(
                    color: theme.colors.primaryForeground,
                    size: sizeToken(size).iconSize,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ),
          );

          expect(
            tester.getSize(find.byType(VButton)).height,
            sizeToken(size).height,
            reason: '$size',
          );
        }
      });

      testWidgets('the icon variant stays square at 1x and 2x', (tester) async {
        final md = theme.sizes.md.height;
        Widget iconButton() => Center(
          child: VButton.icon(
            onPressed: () {},
            child: VIcons.search(
              color: theme.colors.primary,
              size: theme.sizes.md.iconSize,
            ),
          ),
        );

        await tester.pumpWidget(buildTestWidget(iconButton()));
        expect(tester.getSize(find.byType(VButton)), Size(md, md));

        await pumpLargeText(tester, iconButton());
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(VButton)), Size(md, md));
      });

      testWidgets('a button group keeps its height and joined corners', (
        tester,
      ) async {
        const keys = [Key('first'), Key('middle'), Key('last')];
        Widget group() => Center(
          child: VButtonGroup(
            children: [
              for (final key in keys)
                VButton(key: key, onPressed: () {}, child: const Text('A')),
            ],
          ),
        );
        final r = Radius.circular(theme.sizes.md.borderRadius);

        await tester.pumpWidget(buildTestWidget(group()));
        for (final key in keys) {
          expect(tester.getSize(find.byKey(key)).height, theme.sizes.md.height);
        }
        expect(
          decorationOf(tester, find.byKey(keys.first)).borderRadius,
          BorderRadius.only(topLeft: r, bottomLeft: r),
        );
        expect(
          decorationOf(tester, find.byKey(keys[1])).borderRadius,
          BorderRadius.zero,
        );
        expect(
          decorationOf(tester, find.byKey(keys.last)).borderRadius,
          BorderRadius.only(topRight: r, bottomRight: r),
        );

        await pumpLargeText(tester, group());
        expect(tester.takeException(), isNull);
        final heights = {
          for (final key in keys) tester.getSize(find.byKey(key)).height,
        };
        expect(heights, hasLength(1));
        expect(heights.single, greaterThanOrEqualTo(theme.sizes.md.height));
      });
    });

    group('style override', () {
      testWidgets('instance style overrides default colors', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VButton(
              onPressed: () {},
              style: const VButtonStyle(
                backgroundColor: Color(0xFF00FF00),
                foregroundColor: Color(0xFF0000FF),
              ),
              child: const Text('Styled'),
            ),
          ),
        );

        expect(find.text('Styled'), findsOneWidget);
      });

      testWidgets('theme componentOverrides applies to button', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VButtonStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VButton(
                onPressed: () {},
                child: const Text('Theme Override'),
              ),
            ),
          ),
        );

        expect(find.text('Theme Override'), findsOneWidget);
      });

      testWidgets('instance style merges with theme override', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VButtonStyle(backgroundColor: Color(0xFFFF0000), gap: 16),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VButton(
                onPressed: () {},
                style: const VButtonStyle(foregroundColor: Color(0xFF0000FF)),
                child: const Text('Merged'),
              ),
            ),
          ),
        );

        expect(find.text('Merged'), findsOneWidget);
      });
    });
  });
}
