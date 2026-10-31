import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VCheckboxGroup', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('renders all options', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCheckboxGroup<String>(
            options: const [
              VCheckboxItem(value: 'email', label: Text('Email')),
              VCheckboxItem(value: 'sms', label: Text('SMS')),
              VCheckboxItem(value: 'push', label: Text('Push')),
            ],
            values: const ['email'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('SMS'), findsOneWidget);
      expect(find.text('Push'), findsOneWidget);
    });

    testWidgets('adds value on tap', (tester) async {
      var selected = <String>['email'];

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VCheckboxGroup<String>(
              options: const [
                VCheckboxItem(value: 'email', label: Text('Email')),
                VCheckboxItem(value: 'sms', label: Text('SMS')),
              ],
              values: selected,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('SMS'));
      await tester.pump();
      expect(selected, contains('sms'));
      expect(selected, contains('email'));
    });

    testWidgets('removes value on tap', (tester) async {
      var selected = <String>['email', 'sms'];

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VCheckboxGroup<String>(
              options: const [
                VCheckboxItem(value: 'email', label: Text('Email')),
                VCheckboxItem(value: 'sms', label: Text('SMS')),
              ],
              values: selected,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Email'));
      await tester.pump();
      expect(selected, isNot(contains('email')));
      expect(selected, contains('sms'));
    });

    testWidgets('renders sublabels', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCheckboxGroup<String>(
            options: const [
              VCheckboxItem(
                value: 'a',
                label: Text('Option A'),
                sublabel: Text('Description A'),
              ),
              VCheckboxItem(value: 'b', label: Text('Option B')),
            ],
            values: const [],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Description A'), findsOneWidget);
    });

    testWidgets('disables individual options', (tester) async {
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VCheckboxGroup<String>(
              options: const [
                VCheckboxItem(value: 'a', label: Text('Enabled')),
                VCheckboxItem(
                  value: 'b',
                  label: Text('Disabled'),
                  enabled: false,
                ),
              ],
              values: selected,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pump();
      expect(selected, isEmpty);
    });

    testWidgets('disables entire group', (tester) async {
      var selected = <String>[];

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VCheckboxGroup<String>(
              options: const [
                VCheckboxItem(value: 'a', label: Text('Option A')),
                VCheckboxItem(value: 'b', label: Text('Option B')),
              ],
              values: selected,
              onChanged: (v) => setState(() => selected = v),
              enabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option A'));
      await tester.pump();
      expect(selected, isEmpty);
    });

    testWidgets('horizontal orientation uses Wrap', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCheckboxGroup<String>(
            options: const [
              VCheckboxItem(value: 'a', label: Text('A')),
              VCheckboxItem(value: 'b', label: Text('B')),
            ],
            values: const [],
            onChanged: (_) {},
            orientation: Axis.horizontal,
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('vertical orientation uses Column', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCheckboxGroup<String>(
            options: const [
              VCheckboxItem(value: 'a', label: Text('A')),
              VCheckboxItem(value: 'b', label: Text('B')),
            ],
            values: const [],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Column), findsAtLeast(1));
    });
  });
}
