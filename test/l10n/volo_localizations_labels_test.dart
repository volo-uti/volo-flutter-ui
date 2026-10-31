import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

/// Test-only localizations whose strings are distinctive markers, to prove a
/// widget reads its text from [VoloLocalizations] instead of hard-coding it.
class _MarkedLocalizations extends VoloLocalizationsEn {
  const _MarkedLocalizations();

  @override
  String get loading => '[loading]';
  @override
  String get fabLabel => '[fab]';
  @override
  String get backdropLabel => '[backdrop]';
  @override
  String get requiredFieldLabel => '[required]';
  @override
  String get popoverTriggerLabel => '[popover trigger]';
  @override
  String get popoverLabel => '[popover]';
  @override
  String pageOf(int current, int total) => '[page $current/$total]';
  @override
  String get dialogDismissLabel => '[dialog dismiss]';
  @override
  String get alertDialogDismissLabel => '[alert dismiss]';
  @override
  String get dialogConfirm => '[confirm]';
  @override
  String get dialogOk => '[ok]';
  @override
  String get sheetDismissLabel => '[sheet dismiss]';
}

void main() {
  Widget app(
    Widget child, {
    VoloLocalizations localizations = const VoloLocalizationsEn(),
  }) => VTheme(
    data: VThemeData.light(),
    localizations: localizations,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  Widget navigatorApp(
    Widget Function(BuildContext) home, {
    VoloLocalizations localizations = const VoloLocalizationsEn(),
  }) => app(
    Navigator(
      onGenerateRoute: (_) =>
          PageRouteBuilder<void>(pageBuilder: (context, _, _) => home(context)),
    ),
    localizations: localizations,
  );

  List<String?> barrierLabels(WidgetTester tester) => tester
      .widgetList<ModalBarrier>(find.byType(ModalBarrier))
      .map((b) => b.semanticsLabel)
      .toList();

  void semTest(String name, Future<void> Function(WidgetTester) body) =>
      testWidgets(name, (tester) async {
        final handle = tester.ensureSemantics();
        await body(tester);
        handle.dispose();
      });

  group('semantic labels follow VoloLocalizations', () {
    semTest('VSkeleton announces loading', (tester) async {
      await tester.pumpWidget(app(const VSkeleton.rectangular()));
      expect(find.bySemanticsLabel('Loading...'), findsOneWidget);
    });

    semTest('VSkeleton announces the injected loading text', (tester) async {
      await tester.pumpWidget(
        app(
          const VSkeleton.rectangular(),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(find.bySemanticsLabel('[loading]'), findsOneWidget);
      expect(find.bySemanticsLabel('Loading...'), findsNothing);
    });

    semTest('VFab falls back to its localized label', (tester) async {
      await tester.pumpWidget(
        app(const VFab(icon: SizedBox(width: 24, height: 24))),
      );
      expect(find.bySemanticsLabel('Floating action button'), findsOneWidget);
    });

    semTest('VFab falls back to the injected label', (tester) async {
      await tester.pumpWidget(
        app(
          const VFab(icon: SizedBox(width: 24, height: 24)),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(find.bySemanticsLabel('[fab]'), findsOneWidget);
    });

    semTest('VBackdrop label follows the injected text', (tester) async {
      await tester.pumpWidget(
        app(const VBackdrop(), localizations: const _MarkedLocalizations()),
      );
      expect(find.bySemanticsLabel('[backdrop]'), findsOneWidget);
    });

    semTest('VFormHeader required mark follows the injected text', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const VFormHeader(
            label: 'Email',
            required: true,
            child: SizedBox.shrink(),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(find.bySemanticsLabel(RegExp(r'\[required\]')), findsOneWidget);
    });

    semTest('VPopover labels follow the injected text', (tester) async {
      final controller = VPopoverController();
      await tester.pumpWidget(
        navigatorApp(
          (_) => VPopover(
            controller: controller,
            content: const Text('Body'),
            child: const SizedBox(width: 40, height: 40),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(find.bySemanticsLabel('[popover trigger]'), findsOneWidget);
      controller.show();
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(RegExp(r'\[popover\]')), findsOneWidget);
    });

    semTest('VBackdrop label is localized', (tester) async {
      await tester.pumpWidget(app(const VBackdrop()));
      expect(find.bySemanticsLabel('Backdrop'), findsOneWidget);
    });

    semTest('VFormHeader required mark label is localized', (tester) async {
      await tester.pumpWidget(
        app(
          const VFormHeader(
            label: 'Email',
            required: true,
            child: SizedBox.shrink(),
          ),
        ),
      );
      expect(find.bySemanticsLabel(RegExp('Required field')), findsOneWidget);
    });

    semTest('VPopover trigger and panel labels are localized', (tester) async {
      final controller = VPopoverController();
      await tester.pumpWidget(
        navigatorApp(
          (_) => VPopover(
            controller: controller,
            content: const Text('Body'),
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Open popover'), findsOneWidget);
      controller.show();
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(RegExp('Popover')), findsOneWidget);
    });

    semTest('VPageIndicator label uses pageOf', (tester) async {
      await tester.pumpWidget(
        app(const VPageIndicator.dots(current: 1, total: 4)),
      );
      expect(find.bySemanticsLabel(RegExp('Page 2 of 4')), findsOneWidget);
    });

    semTest('VPageIndicator label uses the injected pageOf', (tester) async {
      await tester.pumpWidget(
        app(
          const VPageIndicator.dots(current: 1, total: 4),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(
        find.bySemanticsLabel(RegExp(RegExp.escape('[page 2/4]'))),
        findsOneWidget,
      );
    });

    semTest('VDialog barrier label is localized', (tester) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => VDialog.show<void>(
              context,
              const VDialog.alert(content: Text('Hi')),
            ),
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(barrierLabels(tester), contains('Dismiss dialog'));
    });

    semTest('VDialog barrier label follows the injected text', (tester) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => VDialog.show<void>(
              context,
              const VDialog.alert(content: Text('Hi')),
            ),
            child: const SizedBox(width: 50, height: 50),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(barrierLabels(tester), contains('[dialog dismiss]'));
    });

    semTest('VAlertDialog default confirm text is localized', (tester) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => VAlertDialog.show<void>(
              context,
              description: const Text('Sure?'),
            ),
            child: const SizedBox(width: 50, height: 50),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('[ok]'), findsOneWidget);
      expect(barrierLabels(tester), contains('[alert dismiss]'));
    });

    semTest('VBottomSheet barrier label is localized', (tester) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                VBottomSheet.show<void>(context, child: const Text('Sheet')),
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(barrierLabels(tester), contains('Dismiss'));
    });

    semTest('VBottomSheet barrier label follows the injected text', (
      tester,
    ) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                VBottomSheet.show<void>(context, child: const Text('Sheet')),
            child: const SizedBox(width: 50, height: 50),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(barrierLabels(tester), contains('[sheet dismiss]'));
    });
  });

  group('localizations survive theme re-wrapping', () {
    testWidgets('VTheme.merge keeps the parent localizations', (tester) async {
      late VoloLocalizations seen;
      await tester.pumpWidget(
        app(
          VTheme.merge(
            overrides: (parent) => parent,
            child: Builder(
              builder: (context) {
                seen = VoloLocalizations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(seen, isA<_MarkedLocalizations>());
    });

    testWidgets('AnimatedVTheme keeps the parent localizations', (
      tester,
    ) async {
      late VoloLocalizations seen;
      await tester.pumpWidget(
        app(
          AnimatedVTheme(
            data: VThemeData.dark(),
            child: Builder(
              builder: (context) {
                seen = VoloLocalizations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      expect(seen, isA<_MarkedLocalizations>());
    });

    testWidgets('AnimatedVTheme.localizations overrides the parent', (
      tester,
    ) async {
      late VoloLocalizations seen;
      await tester.pumpWidget(
        app(
          AnimatedVTheme(
            data: VThemeData.dark(),
            localizations: const _MarkedLocalizations(),
            child: Builder(
              builder: (context) {
                seen = VoloLocalizations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(seen, isA<_MarkedLocalizations>());
    });

    semTest('VToast overlay receives the injected localizations', (
      tester,
    ) async {
      await tester.pumpWidget(
        navigatorApp(
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                VToast.show(context, const VToast(message: Text('Saved'))),
            child: const SizedBox(width: 50, height: 50),
          ),
          localizations: const _MarkedLocalizations(),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(VToast), findsOneWidget);
      expect(
        VoloLocalizations.of(tester.element(find.byType(VToast))),
        isA<_MarkedLocalizations>(),
      );
      VToast.dismiss(tester.element(find.byType(GestureDetector).first));
      await tester.pumpAndSettle();
    });
  });

  test('English semantic label keys', () {
    const en = VoloLocalizationsEn();
    expect(en.backTooltip, 'Back');
    expect(en.drawerLabel, 'Navigation drawer');
    expect(en.dialogLabel, 'Dialog');
    expect(en.notificationLabel, 'Notification');
    expect(en.hoverCardLabel, 'Hover card content');
    expect(en.chipDelete, 'Delete');
    expect(en.tableRowLabel(3), 'Row 3');
    expect(en.dialogOk, 'OK');
  });

  test('barrel does not export tooling', () {
    final barrel = File('lib/volo_flutter_ui.dart').readAsStringSync();
    expect(barrel, isNot(contains('tooling')));
  });
}
