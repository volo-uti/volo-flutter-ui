// Regression tests for the inputs review: each test failed before its fix.
import 'dart:ui' show CheckedState;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

class _FakeL10n extends VoloLocalizationsEn {
  const _FakeL10n();

  @override
  String weekdayShort(int weekday) => 'D$weekday';

  @override
  String autocompleteMinChars(int count) => 'need $count chars';

  @override
  String time12Hour(int hour, int minute, {required bool isPm}) =>
      'T$hour:$minute${isPm ? 'p' : 'a'}';
}

Widget wrap(
  Widget child, {
  double width = 300,
  TextDirection direction = TextDirection.ltr,
  VoloLocalizations? l10n,
}) => VTheme(
  data: VThemeData.light(),
  localizations: l10n ?? const VoloLocalizationsEn(),
  child: Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 800)),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

/// Like [wrap] with an Overlay, for popovers. The child is built once, so
/// tests that change it use a notifier inside the child.
Widget wrapOv(Widget child, {VoloLocalizations? l10n}) => VTheme(
  data: VThemeData.light(),
  localizations: l10n ?? const VoloLocalizationsEn(),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 800)),
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) => Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(width: 300, child: child),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

FocusNode detectorNode(WidgetTester tester, Type host) => tester
    .widget<FocusableActionDetector>(
      find
          .descendant(
            of: find.byType(host),
            matching: find.byType(FocusableActionDetector),
          )
          .first,
    )
    .focusNode!;

void main() {
  group('form structure', () {
    testWidgets('a footer appearing keeps the same EditableText state', (
      tester,
    ) async {
      Widget build({required bool error}) => wrap(
        VTextField(name: 'a', error: error, errorText: error ? 'bad' : null),
      );
      await tester.pumpWidget(build(error: false));
      final before = tester.state(find.byType(EditableText));
      await tester.pumpWidget(build(error: true));
      expect(find.text('bad'), findsOneWidget);
      expect(tester.state(find.byType(EditableText)), same(before));
      await tester.pumpWidget(build(error: false));
      expect(tester.state(find.byType(EditableText)), same(before));
    });

    testWidgets('a label appearing keeps the same EditableText state', (
      tester,
    ) async {
      Widget build({String? label}) =>
          wrap(VTextField(name: 'a', label: label));
      await tester.pumpWidget(build());
      final before = tester.state(find.byType(EditableText));
      await tester.pumpWidget(build(label: 'Name'));
      expect(tester.state(find.byType(EditableText)), same(before));
    });

    testWidgets('floating label sits on the border, clear of the text', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const VTextField(
            name: 'a',
            label: 'Lbl',
            floatingLabel: true,
            value: 'typed text',
          ),
        ),
      );
      final label = tester.getRect(find.text('Lbl'));
      final editable = tester.getRect(find.byType(EditableText));
      expect(label.overlaps(editable), isFalse);
    });
  });

  group('VTextField controller', () {
    testWidgets('text set in code updates placeholder, counter and clear', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          VTextField(
            name: 'a',
            controller: controller,
            placeholder: 'PH',
            maxLength: 10,
            clearable: true,
          ),
        ),
      );
      expect(find.text('PH'), findsOneWidget);
      expect(find.text('0/10'), findsOneWidget);

      controller.text = 'hello';
      await tester.pump();

      expect(find.text('PH'), findsNothing);
      expect(find.text('5/10'), findsOneWidget);
      expect(find.bySemanticsLabel('Clear'), findsOneWidget);
    });

    testWidgets('VForm validate and save read the controller text', (
      tester,
    ) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();
      String? saved;
      String? validated;
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          VForm(
            formKey: formKey,
            children: [
              VTextField(
                name: 'a',
                controller: controller,
                validator: (v) {
                  validated = v;
                  return null;
                },
                onSaved: (v) => saved = v,
              ),
            ],
          ),
        ),
      );
      controller.text = 'abc';
      await tester.pump();

      expect(formKey.currentState!.validate(), isTrue);
      formKey.currentState!.save();

      expect(validated, 'abc');
      expect(saved, 'abc');
    });

    testWidgets('VForm reset puts the typed text back', (tester) async {
      final controller = TextEditingController(text: 'start');
      final formKey = GlobalKey<FormState>();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          VForm(
            formKey: formKey,
            children: [VTextField(name: 'a', controller: controller)],
          ),
        ),
      );
      controller.text = 'changed';
      await tester.pump();

      formKey.currentState!.reset();
      await tester.pump();

      expect(controller.text, 'start');
    });

    testWidgets('a swapped controller is what the form validates', (
      tester,
    ) async {
      final first = TextEditingController(text: 'one');
      final second = TextEditingController(text: 'two');
      final formKey = GlobalKey<FormState>();
      String? validated;
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Widget build(TextEditingController c) => wrap(
        VForm(
          formKey: formKey,
          children: [
            VTextField(
              name: 'a',
              controller: c,
              validator: (v) {
                validated = v;
                return null;
              },
            ),
          ],
        ),
      );
      await tester.pumpWidget(build(first));
      await tester.pumpWidget(build(second));
      await tester.pump();
      second.text = 'three';
      await tester.pump();

      formKey.currentState!.validate();
      expect(validated, 'three');
    });

    testWidgets('VTextArea follows text set in code', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          VTextArea(
            controller: controller,
            placeholder: 'PH',
            maxLength: 10,
            showCounter: true,
          ),
        ),
      );
      expect(find.text('PH'), findsOneWidget);

      controller.text = 'hello';
      await tester.pump();

      expect(find.text('PH'), findsNothing);
      expect(find.text('5/10'), findsOneWidget);
    });
  });

  group('disabled and focus', () {
    testWidgets('a disabled VTextField cannot take focus or validate', (
      tester,
    ) async {
      final node = FocusNode();
      final formKey = GlobalKey<FormState>();
      var validated = false;
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrap(
          VForm(
            formKey: formKey,
            children: [
              VTextField(
                name: 'a',
                enabled: false,
                focusNode: node,
                validator: (_) {
                  validated = true;
                  return 'never';
                },
              ),
            ],
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();

      expect(node.hasFocus, isFalse);
      expect(formKey.currentState!.validate(), isTrue);
      expect(validated, isFalse);
    });

    testWidgets('a disabled VTextArea cannot take focus', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(wrap(VTextArea(enabled: false, focusNode: node)));
      node.requestFocus();
      await tester.pump();

      expect(node.hasFocus, isFalse);
    });

    testWidgets('a tap in the padding of a VTextField focuses it', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrap(VTextField(name: 'a', focusNode: node, fullWidth: true)),
      );
      final box = tester.getRect(find.byType(VFormBody));

      await tester.tapAt(Offset(box.right - 3, box.center.dy));
      await tester.pump();

      expect(node.hasFocus, isTrue);
    });

    testWidgets('a tap low in a tall VTextArea focuses it', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        wrap(VTextArea(focusNode: node, minLines: 4, fullWidth: true)),
      );
      final box = tester.getRect(find.byType(AnimatedContainer));

      await tester.tapAt(Offset(box.center.dx, box.bottom - 6));
      await tester.pump();

      expect(node.hasFocus, isTrue);
    });

    testWidgets('semanticLabel reaches VTextField and VTextArea', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              VTextField(name: 'a', semanticLabel: 'FIELD-SEM'),
              VTextArea(semanticLabel: 'AREA-SEM'),
            ],
          ),
        ),
      );

      expect(find.bySemanticsLabel('FIELD-SEM'), findsOneWidget);
      expect(find.bySemanticsLabel('AREA-SEM'), findsOneWidget);
    });

    testWidgets('replacing the focused node clears the focus ring', (
      tester,
    ) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Widget build(FocusNode n) => wrap(VTextField(name: 'a', focusNode: n));
      await tester.pumpWidget(build(first));
      first.requestFocus();
      await tester.pumpAndSettle();
      expect(tester.widget<VFormBody>(find.byType(VFormBody)).focused, isTrue);

      await tester.pumpWidget(build(second));
      await tester.pumpAndSettle();

      expect(second.hasFocus, isFalse);
      expect(tester.widget<VFormBody>(find.byType(VFormBody)).focused, isFalse);
    });
  });

  group('keyboard activation', () {
    Future<void> expectActivates(
      WidgetTester tester,
      Type host,
      Widget Function(VoidCallback tap) build,
    ) async {
      var taps = 0;
      await tester.pumpWidget(wrap(build(() => taps++)));
      detectorNode(tester, host).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1, reason: '$host Enter');
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 2, reason: '$host Space');
    }

    testWidgets('VButton', (t) async {
      await expectActivates(
        t,
        VButton,
        (tap) => VButton(onPressed: tap, child: const Text('x')),
      );
    });
    testWidgets('VIconButton', (t) async {
      await expectActivates(
        t,
        VIconButton,
        (tap) => VIconButton(icon: const Text('x'), onPressed: tap),
      );
    });
    testWidgets('VToggleButton', (t) async {
      await expectActivates(
        t,
        VToggleButton,
        (tap) => VToggleButton(
          isSelected: false,
          onChanged: (_) => tap(),
          child: const Text('x'),
        ),
      );
    });
    testWidgets('VFab', (t) async {
      await expectActivates(
        t,
        VFab,
        (tap) => VFab(icon: const Text('x'), onPressed: tap),
      );
    });
    testWidgets('VLink', (t) async {
      await expectActivates(
        t,
        VLink,
        (tap) => VLink(onTap: tap, child: const Text('x')),
      );
    });
    testWidgets('VCheckbox', (t) async {
      await expectActivates(
        t,
        VCheckbox,
        (tap) => VCheckbox(value: false, onChanged: (_) => tap()),
      );
    });
    testWidgets('VRadio', (t) async {
      await expectActivates(
        t,
        VRadio<int>,
        (tap) => VRadio<int>(value: 1, groupValue: 0, onChanged: (_) => tap()),
      );
    });
    testWidgets('VSwitch', (t) async {
      await expectActivates(
        t,
        VSwitch,
        (tap) => VSwitch(value: false, onChanged: (_) => tap()),
      );
    });

    testWidgets('a button without onPressed is not a focus stop', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const VButton(child: Text('x'))));
      final node = detectorNode(tester, VButton)..requestFocus();
      await tester.pump();

      expect(node.hasFocus, isFalse);
    });

    testWidgets('a button without onPressed is dimmed', (tester) async {
      await tester.pumpWidget(wrap(const VButton(child: Text('x'))));

      final opacity = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(VButton),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, 0.5);
    });
  });

  group('VSwitch and VRadio', () {
    testWidgets('a labelled switch fits an unbounded-width Row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VSwitch(
                value: true,
                onChanged: (_) {},
                label: const Text('Label'),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('the I and O marks stay out of the semantics label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(VSwitch.labeled(value: true, onChanged: (_) {})),
      );

      final label = tester.getSemantics(find.byType(VSwitch)).label;
      expect(label, isNot(contains('I')));
      expect(label, isNot(contains('O')));
      handle.dispose();
    });

    testWidgets('VRadio reports a checked state', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(VRadio<int>(value: 1, groupValue: 1, onChanged: (_) {})),
      );

      final data = tester
          .getSemantics(find.byType(VRadio<int>))
          .getSemanticsData();
      expect(data.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });
  });

  group('VSlider', () {
    testWidgets('touching range thumbs can be pulled apart again', (
      tester,
    ) async {
      var current = const RangeValues(80, 80);
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => VSlider.range(
              values: current,
              onRangeChanged: (v) => setState(() => current = v),
            ),
          ),
        ),
      );
      final r = tester.getRect(find.byType(VSlider));

      await tester.tapAt(Offset(r.left + r.width * 0.3, r.center.dy));
      await tester.pump();

      expect(current.start, lessThan(80));
      expect(current.end, 80);
    });

    testWidgets('the snapping grid starts at min', (tester) async {
      double? got;
      await tester.pumpWidget(
        wrap(
          VSlider(
            value: 0.5,
            min: 0.5,
            max: 5.5,
            divisions: 5,
            onChanged: (v) => got = v,
          ),
        ),
      );
      final r = tester.getRect(find.byType(VSlider));

      // The grid is 0.5, 1.5, 2.5 ... so a tap at 30% (value 2.0) snaps to a
      // grid point, never to 2.0.
      await tester.tapAt(Offset(r.left + r.width * 0.3, r.center.dy));

      expect(got, isNotNull);
      final steps = (got! - 0.5) / 1.0;
      expect(steps, closeTo(steps.roundToDouble(), 1e-9));
    });

    testWidgets('a touch that becomes a scroll does not move the value', (
      tester,
    ) async {
      var changes = 0;
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: ListView(
              children: [
                VSlider(value: 10, onChanged: (_) => changes++),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      final r = tester.getRect(find.byType(VSlider));

      final gesture = await tester.startGesture(
        Offset(r.left + 200, r.center.dy),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.moveBy(const Offset(0, -80));
      await gesture.up();
      await tester.pump();

      expect(changes, 0);
    });

    testWidgets('Tab walks through a range slider and leaves it', (
      tester,
    ) async {
      final node = FocusNode();
      final after = FocusNode();
      addTearDown(node.dispose);
      addTearDown(after.dispose);
      await tester.pumpWidget(
        wrap(
          Shortcuts(
            shortcuts: WidgetsApp.defaultShortcuts,
            child: Actions(
              actions: WidgetsApp.defaultActions,
              child: Column(
                children: [
                  Focus(
                    focusNode: node,
                    child: VSlider.range(
                      values: const RangeValues(10, 20),
                      onRangeChanged: (_) {},
                    ),
                  ),
                  Focus(focusNode: after, child: const SizedBox(height: 10)),
                ],
              ),
            ),
          ),
        ),
      );
      // The slider owns a Focus of its own; focus it through the tree.
      final sliderFocus =
          tester
                .widgetList<Focus>(
                  find.descendant(
                    of: find.byType(VSlider),
                    matching: find.byType(Focus),
                  ),
                )
                .firstWhere((focus) => focus.onKeyEvent != null)
                .focusNode!
            ..requestFocus();
      await tester.pump();

      // First Tab moves from the start thumb to the end thumb, the second
      // one leaves the slider.
      for (var i = 0; i < 2; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }

      expect(sliderFocus.hasFocus, isFalse);
      expect(after.hasFocus, isTrue);
    });
  });

  group('VSelect', () {
    const items = [
      VSelectItem(value: 'a', label: 'Alpha'),
      VSelectItem(value: 'b', label: 'Beta'),
    ];

    testWidgets('a value that is not in items shows the placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapOv(
          VSelect<String>(
            items: items,
            value: 'zzz',
            placeholder: 'Pick',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Alpha'), findsNothing);
      expect(find.text('Pick'), findsOneWidget);
    });

    testWidgets('a value with empty items does not throw', (tester) async {
      await tester.pumpWidget(
        wrapOv(const VSelect<String>(items: [], value: 'zzz')),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('a disabled VSelect ignores the keyboard', (tester) async {
      String? got;
      await tester.pumpWidget(
        wrapOv(
          VSelect<String>(
            items: items,
            enabled: false,
            onChanged: (v) => got = v,
          ),
        ),
      );
      Focus.of(tester.element(find.byType(VPopover))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(find.text('Beta'), findsNothing);
      expect(got, isNull);
    });

    testWidgets('keyboard pick at maxSelection reports no change', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        wrapOv(
          VSelect<String>.multiple(
            items: items,
            values: const ['a'],
            maxSelection: 1,
            onValuesChanged: (_) => calls++,
          ),
        ),
      );
      Focus.of(tester.element(find.byType(VPopover))).requestFocus();
      await tester.pump();
      // Open, then move to the second option and press Enter.
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump(const Duration(milliseconds: 300));
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(calls, 0);
    });
  });

  group('VAutocomplete', () {
    const items = [
      VAutocompleteItem(value: 'seoul', label: 'Seoul'),
      VAutocompleteItem(value: 'busan', label: 'Busan'),
    ];

    testWidgets('shows the label of the initial value', (tester) async {
      await tester.pumpWidget(
        wrapOv(
          const VAutocomplete<String>(
            items: items,
            value: 'seoul',
            placeholder: 'PH',
          ),
        ),
      );

      expect(find.text('Seoul'), findsOneWidget);
      expect(find.text('PH'), findsNothing);
    });

    testWidgets('follows a value changed from outside', (tester) async {
      final value = ValueNotifier<String?>(null);
      addTearDown(value.dispose);
      await tester.pumpWidget(
        wrapOv(
          ValueListenableBuilder<String?>(
            valueListenable: value,
            builder: (context, v, _) => VAutocomplete<String>(
              items: items,
              value: v,
              placeholder: 'PH',
            ),
          ),
        ),
      );
      expect(find.text('PH'), findsOneWidget);

      value.value = 'busan';
      await tester.pump();
      expect(find.text('Busan'), findsOneWidget);

      value.value = null;
      await tester.pump();
      expect(find.text('PH'), findsOneWidget);
    });

    testWidgets('allowCustomValue accepts Enter when nothing matches', (
      tester,
    ) async {
      String? got;
      await tester.pumpWidget(
        wrapOv(
          VAutocomplete<String>(
            items: items,
            allowCustomValue: true,
            onChanged: (v) => got = v,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(got, 'zzz');
    });

    testWidgets('a disabled VAutocomplete cannot take focus', (tester) async {
      await tester.pumpWidget(
        wrapOv(const VAutocomplete<String>(items: items, enabled: false)),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      editable.focusNode.requestFocus();
      await tester.pump();

      expect(editable.focusNode.hasFocus, isFalse);
    });

    testWidgets('the short-query hint goes through the localizations', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapOv(
          VAutocomplete<String>.async(
            onSearch: (_) async => const [],
            minSearchLength: 3,
          ),
          l10n: const _FakeL10n(),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('need 3 chars'), findsOneWidget);
    });
  });

  group('VDatePicker and VCalendar', () {
    testWidgets('firstDate with a time of day still allows that day', (
      tester,
    ) async {
      DateTime? picked;
      final now = DateTime.now();
      // Keep the whole test on one month with a day that is not the last.
      final firstDate = DateTime(now.year, now.month, 15, 14, 30);
      await tester.pumpWidget(
        wrapOv(
          VDatePicker.date(
            value: DateTime(now.year, now.month, 20),
            firstDate: firstDate,
            onChanged: (d) => picked = d,
          ),
        ),
      );
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15').last);
      await tester.pump();

      expect(picked, DateTime(now.year, now.month, 15));
    });

    testWidgets('a range anchor does not survive closing the popover', (
      tester,
    ) async {
      VDateTimeRange? picked;
      final now = DateTime.now();
      await tester.pumpWidget(
        wrapOv(
          VDatePicker.range(
            rangeValue: VDateTimeRange(
              start: DateTime(now.year, now.month, 3),
              end: DateTime(now.year, now.month, 4),
            ),
            onRangeChanged: (r) => picked = r,
          ),
        ),
      );
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10').last);
      await tester.pump();

      // Close by tapping outside, then open again and pick a day.
      await tester.tapAt(const Offset(780, 580));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20').last);
      await tester.pump();

      expect(picked, isNull);
    });

    testWidgets('weekday headers, day labels and times are localized', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapOv(
          VCalendar(value: DateTime(2026, 1, 15), onChanged: (_) {}),
          l10n: const _FakeL10n(),
        ),
      );

      expect(find.text('D7'), findsOneWidget);
      expect(find.text('Sun'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('January 15, 2026')), findsOneWidget);
    });

    testWidgets('the date picker header and time use the localizations', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapOv(
          VDatePicker.time(
            timeValue: const VTimeOfDay(hour: 14, minute: 5),
            use24HourFormat: false,
            onTimeChanged: (_) {},
          ),
          l10n: const _FakeL10n(),
        ),
      );

      expect(find.text('T2:5p'), findsOneWidget);
    });
  });
}
