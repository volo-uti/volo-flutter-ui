import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget({required Widget child}) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(data: const MediaQueryData(), child: child),
    ),
  );

  group('VSettingTile', () {
    group('simple variant', () {
      testWidgets('renders with title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VSettingTile.simple(title: Text('Settings')),
          ),
        );

        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('renders with subtitle', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VSettingTile.simple(
              title: Text('Settings'),
              subtitle: Text('Description'),
            ),
          ),
        );

        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('renders trailing widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VSettingTile.simple(
              title: Text('Settings'),
              trailing: Text('Trailing'),
            ),
          ),
        );

        expect(find.text('Trailing'), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.simple(
              title: const Text('Settings'),
              onTap: () => tapped = true,
            ),
          ),
        );

        await tester.tap(find.byType(VSettingTile));
        await tester.pump();

        expect(tapped, true);
      });
    });

    group('navigation variant', () {
      testWidgets('shows chevron icon', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.navigation(
              title: const Text('Language'),
              onTap: () {},
            ),
          ),
        );

        expect(find.text('Language'), findsOneWidget);
        // VIcons.chevronRight renders as SizedBox > CustomPaint
        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('shows value when provided', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.navigation(
              title: const Text('Language'),
              value: 'English',
              onTap: () {},
            ),
          ),
        );

        expect(find.text('English'), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.navigation(
              title: const Text('Language'),
              onTap: () => tapped = true,
            ),
          ),
        );

        await tester.tap(find.byType(VSettingTile));
        await tester.pump();

        expect(tapped, true);
      });
    });

    group('switchTile variant', () {
      testWidgets('renders switch', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VSettingTile.switchTile(
              title: Text('Notifications'),
              value: false,
            ),
          ),
        );

        expect(find.text('Notifications'), findsOneWidget);
        expect(find.byType(VSwitch), findsOneWidget);
      });

      testWidgets('calls onChanged when toggled', (tester) async {
        bool? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.switchTile(
              title: const Text('Notifications'),
              value: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(VSettingTile));
        await tester.pump();

        expect(changedValue, true);
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.switchTile(
              title: const Text('Notifications'),
              value: false,
              onChanged: (v) => changedValue = v,
              enabled: false,
            ),
          ),
        );

        await tester.tap(find.byType(VSettingTile));
        await tester.pump();

        expect(changedValue, isNull);
      });
    });

    group('checkbox variant', () {
      testWidgets('renders checkbox', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VSettingTile.checkbox(
              title: Text('Accept Terms'),
              value: false,
            ),
          ),
        );

        expect(find.text('Accept Terms'), findsOneWidget);
        expect(find.byType(VCheckbox), findsOneWidget);
      });

      testWidgets('calls onChanged when toggled', (tester) async {
        bool? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            child: VSettingTile.checkbox(
              title: const Text('Accept Terms'),
              value: false,
              onChanged: (v) => changedValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(VSettingTile));
        await tester.pump();

        expect(changedValue, true);
      });
    });

    testWidgets('leading icon is rendered', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const VSettingTile.simple(
            title: Text('Settings'),
            leading: SizedBox(key: Key('leading-icon'), width: 24, height: 24),
          ),
        ),
      );

      expect(find.byKey(const Key('leading-icon')), findsOneWidget);
    });

    testWidgets('Widget title is rendered', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const VSettingTile.simple(title: Text('Widget Title')),
        ),
      );

      expect(find.text('Widget Title'), findsOneWidget);
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
              child: VSettingTile.simple(
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
      expect(subtitle.fontSize, theme.typography.bodySmall.fontSize);
    });
  });

  group('keyboard activation', () {
    testWidgets('Enter and Space press a focused setting tile', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VSettingTile.navigation(
                title: const Text('Title'),
                onTap: () => taps++,
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

  group('VSettingTile switch semantics and layout', () {
    testWidgets('the row is one node, not a row plus an inner control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        looseHost(
          VSettingTile.switchTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(VSettingTile));
      expect(node.label, 'Alerts');
      expect(node.childrenCount, 0);
      handle.dispose();
    });

    testWidgets('hugs its content in a loose parent', (tester) async {
      await tester.pumpWidget(
        looseHost(
          VSettingTile.switchTile(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.getSize(find.byType(VSettingTile)).height, lessThan(120));
    });
  });

  group('VSettingTile checkbox semantics', () {
    testWidgets('the row is one node, not a row plus an inner control', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        looseHost(
          VSettingTile.checkbox(
            title: const Text('Alerts'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(VSettingTile));
      expect(node.label, 'Alerts');
      expect(node.childrenCount, 0);
      handle.dispose();
    });
  });

  group('VSettingTile radio', () {
    Widget host(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

    testWidgets('tapping the row calls onChanged with its value', (
      tester,
    ) async {
      String? got;
      await tester.pumpWidget(
        host(
          VSettingTile.radio(
            title: const Text('A'),
            value: 'a',
            groupValue: 'b',
            onChanged: (v) => got = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(got, 'a');
      expect(find.byType(VRadio<bool>), findsOneWidget);
    });

    testWidgets('Enter and Space on focus call onChanged', (tester) async {
      final calls = <String?>[];
      await tester.pumpWidget(
        host(
          VSettingTile.radio<String>(
            title: const Text('A'),
            value: 'a',
            groupValue: null,
            onChanged: calls.add,
          ),
        ),
      );
      Focus.of(tester.element(find.text('A'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(calls, ['a', 'a']);
    });

    testWidgets('disabled or null onChanged ignores taps', (tester) async {
      var n = 0;
      await tester.pumpWidget(
        host(
          VSettingTile.radio(
            title: const Text('A'),
            value: 'a',
            groupValue: null,
            enabled: false,
            onChanged: (_) => n++,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pumpWidget(
        host(
          VSettingTile.radio(
            title: const Text('A'),
            value: 'a',
            groupValue: null,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(n, 0);
    });

    testWidgets('radio mark is not dimmed and the row is one node', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          VSettingTile.radio(
            title: const Text('A'),
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
          ),
        ),
      );
      final dim = tester.widgetList<Opacity>(
        find.descendant(
          of: find.byType(VRadio<bool>),
          matching: find.byType(Opacity),
        ),
      );
      expect(dim.every((o) => o.opacity == 1), isTrue);
      final node = tester.getSemantics(find.byType(VSettingTile));
      expect(node.childrenCount, 0);
      expect(
        // ignore: deprecated_member_use
        node.hasFlag(SemanticsFlag.isChecked),
        isTrue,
      );
      handle.dispose();
    });
  });
}
