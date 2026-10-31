import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VHoverCard', () {
    testWidgets('creates default hover card', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VHoverCard(content: Text('Content'), child: Text('Trigger')),
          ),
        ),
      );

      expect(find.byType(VHoverCard), findsOneWidget);
      expect(find.text('Trigger'), findsOneWidget);
    });

    testWidgets('opens on tap', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VHoverCard(
                      content: Text('Content'),
                      child: Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VHoverCard(
                      content: Text('Content'),
                      enabled: false,
                      child: Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsNothing);
    });

    testWidgets('various positions', (tester) async {
      for (final position in VHoverCardPosition.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VHoverCard(
                position: position,
                content: const Text('Content'),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );

        expect(find.byType(VHoverCard), findsOneWidget);
      }
    });

    testWidgets('custom offset', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VHoverCard(
              offset: Offset(10, 20),
              content: Text('Content'),
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      expect(find.byType(VHoverCard), findsOneWidget);
    });

    testWidgets('custom delay', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VHoverCard(
              openDelay: Duration(milliseconds: 100),
              closeDelay: Duration(milliseconds: 50),
              content: Text('Content'),
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      expect(find.byType(VHoverCard), findsOneWidget);
    });
  });

  group('VHoverCard lifecycle', () {
    final show = ValueNotifier<bool>(true);
    final enabled = ValueNotifier<bool>(true);

    Widget host({
      Widget content = const Text('HCC'),
      TextDirection direction = TextDirection.ltr,
      VHoverCardPosition position = VHoverCardPosition.bottom,
      VoloLocalizations? localizations,
    }) => VTheme(
      data: VThemeData.light(),
      localizations: localizations ?? const VoloLocalizationsEn(),
      child: Directionality(
        textDirection: direction,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: show,
                  builder: (context, visible, _) =>
                      ValueListenableBuilder<bool>(
                        valueListenable: enabled,
                        builder: (context, isEnabled, _) => visible
                            ? VHoverCard(
                                enabled: isEnabled,
                                position: position,
                                offset: Offset.zero,
                                content: content,
                                child: const SizedBox(
                                  key: Key('trigger'),
                                  width: 40,
                                  height: 20,
                                  child: ColoredBox(color: Color(0xFF00FF00)),
                                ),
                              )
                            : const SizedBox(),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    setUp(() {
      show.value = true;
      enabled.value = true;
    });

    Finder trigger() => find.byKey(const Key('trigger'));

    testWidgets('removes its overlay entry when disposed while open', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      await tester.tap(trigger());
      await tester.pumpAndSettle();
      expect(find.text('HCC'), findsOneWidget);

      show.value = false;
      await tester.pumpAndSettle();

      expect(find.text('HCC'), findsNothing);
    });

    testWidgets('reopening during the close animation keeps one entry', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      await tester.tap(trigger());
      await tester.pumpAndSettle();
      await tester.tap(trigger());
      await tester.pump(const Duration(milliseconds: 20));
      await tester.tap(trigger());
      await tester.pumpAndSettle();
      expect(find.text('HCC'), findsOneWidget);

      await tester.tap(trigger());
      await tester.pumpAndSettle();
      expect(find.text('HCC'), findsNothing);
    });

    testWidgets('closes an open card when it becomes disabled', (tester) async {
      await tester.pumpWidget(host());
      await tester.tap(trigger());
      await tester.pumpAndSettle();
      expect(find.text('HCC'), findsOneWidget);

      enabled.value = false;
      await tester.pumpAndSettle();

      expect(find.text('HCC'), findsNothing);
    });

    testWidgets('is as wide as its content, up to 320', (tester) async {
      await tester.pumpWidget(host(content: const Text('Hi')));
      await tester.tap(trigger());
      await tester.pumpAndSettle();

      final card = find.ancestor(
        of: find.text('Hi'),
        matching: find.byType(DecoratedBox),
      );
      expect(tester.getSize(card.first).width, lessThan(200));
    });

    testWidgets('bottomStart aligns with the right edge in RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          direction: TextDirection.rtl,
          position: VHoverCardPosition.bottomStart,
          content: const SizedBox(key: Key('card'), width: 100, height: 20),
        ),
      );
      await tester.tap(trigger());
      await tester.pumpAndSettle();

      final card = find.ancestor(
        of: find.byKey(const Key('card')),
        matching: find.byType(DecoratedBox),
      );
      expect(
        tester.getTopRight(card.first).dx,
        closeTo(tester.getTopRight(trigger()).dx, 0.5),
      );
    });

    testWidgets('semantics hint comes from the localizations', (tester) async {
      await tester.pumpWidget(host(localizations: const _HintLocalizations()));

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.hint == 'HOVER-HINT',
        ),
        findsOneWidget,
      );
    });
  });
}

class _HintLocalizations extends VoloLocalizationsEn {
  const _HintLocalizations();

  @override
  String get hoverCardHintHover => 'HOVER-HINT';
}
