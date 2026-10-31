import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VRadio', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VRadio', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VRadio<String>(value: 'a', onChanged: (_) {})),
      );

      expect(find.byType(VRadio<String>), findsOneWidget);
    });

    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VRadio<String>(
            value: 'a',
            onChanged: (_) {},
            label: const Text('Option A'),
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('selected state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VRadio<String>(
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
            label: const Text('Selected'),
          ),
        ),
      );

      expect(find.text('Selected'), findsOneWidget);
    });

    group('VRadio.group', () {
      testWidgets('renders all options', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VRadio<String>.group(
              options: const [
                VRadioItem(value: 'a', label: Text('Option A')),
                VRadioItem(value: 'b', label: Text('Option B')),
                VRadioItem(value: 'c', label: Text('Option C')),
              ],
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.text('Option A'), findsOneWidget);
        expect(find.text('Option B'), findsOneWidget);
        expect(find.text('Option C'), findsOneWidget);
      });

      testWidgets('invokes onValueChange with correct value', (tester) async {
        String? selected = 'a';

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VRadio<String>.group(
                options: const [
                  VRadioItem(value: 'a', label: Text('Option A')),
                  VRadioItem(value: 'b', label: Text('Option B')),
                ],
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Option B'));
        await tester.pump();
        expect(selected, 'Option B' == 'Option B' ? 'b' : 'a');
      });

      testWidgets('renders sublabels', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VRadio<String>.group(
              options: const [
                VRadioItem(
                  value: 'a',
                  label: Text('Option A'),
                  sublabel: Text('Description A'),
                ),
                VRadioItem(value: 'b', label: Text('Option B')),
              ],
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.text('Description A'), findsOneWidget);
      });

      testWidgets('disables individual options', (tester) async {
        String? selected = 'a';

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VRadio<String>.group(
                options: const [
                  VRadioItem(value: 'a', label: Text('Enabled')),
                  VRadioItem(
                    value: 'b',
                    label: Text('Disabled'),
                    enabled: false,
                  ),
                ],
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        await tester.pump();
        expect(selected, 'a');
      });

      testWidgets('disables entire group', (tester) async {
        String? selected = 'a';

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VRadio<String>.group(
                options: const [
                  VRadioItem(value: 'a', label: Text('Option A')),
                  VRadioItem(value: 'b', label: Text('Option B')),
                ],
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v),
                enabled: false,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Option B'));
        await tester.pump();
        expect(selected, 'a');
      });

      testWidgets('horizontal orientation uses Wrap', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VRadio<String>.group(
              options: const [
                VRadioItem(value: 'a', label: Text('A')),
                VRadioItem(value: 'b', label: Text('B')),
              ],
              groupValue: 'a',
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
            VRadio<String>.group(
              options: const [
                VRadioItem(value: 'a', label: Text('A')),
                VRadioItem(value: 'b', label: Text('B')),
              ],
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(Column), findsAtLeast(1));
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to radio', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VRadioStyle(activeColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VRadio<String>(value: 'a', onChanged: (_) {}),
            ),
          ),
        );

        expect(find.byType(VRadio<String>), findsOneWidget);
      });
    });
  });
}
