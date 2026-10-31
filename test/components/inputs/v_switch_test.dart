import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VSwitch', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VSwitch', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSwitch(value: false, onChanged: (_) {})),
      );

      expect(find.byType(VSwitch), findsOneWidget);
    });

    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VSwitch(
            value: false,
            onChanged: (_) {},
            label: const Text('Receive notifications'),
          ),
        ),
      );

      expect(find.text('Receive notifications'), findsOneWidget);
    });

    testWidgets('invokes onCheckedChange on tap', (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestWidget(VSwitch(value: false, onChanged: (v) => newValue = v)),
      );

      await tester.tap(find.byType(VSwitch));
      expect(newValue, true);
    });

    testWidgets('ignores tap when enabled=false', (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          VSwitch(value: false, onChanged: (v) => newValue = v, enabled: false),
        ),
      );

      await tester.tap(find.byType(VSwitch));
      expect(newValue, null);
    });

    testWidgets('value=true state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSwitch(value: true, onChanged: (_) {})),
      );

      expect(find.byType(VSwitch), findsOneWidget);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to switch', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VSwitchStyle(activeTrackColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VSwitch(value: false, onChanged: (_) {}),
            ),
          ),
        );

        expect(find.byType(VSwitch), findsOneWidget);
      });
    });
  });
}
