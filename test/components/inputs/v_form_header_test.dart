import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormHeader', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormHeader', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFormHeader(label: 'Label', child: Container())),
      );

      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('shows only child when label is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VFormHeader(child: Text('child'))),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('shows required indicator when required=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(label: 'Label', required: true, child: Container()),
        ),
      );

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('custom requiredMark', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            required: true,
            requiredMark: '(required)',
            child: Container(),
          ),
        ),
      );

      expect(find.text('(required)'), findsOneWidget);
    });

    testWidgets('displays more', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(label: 'Label', more: 'Optional', child: Container()),
        ),
      );

      expect(find.text('Optional'), findsOneWidget);
    });

    testWidgets('displays tooltip', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            tooltip: const Text('?'),
            child: Container(),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('the color of titleStyle and subtitleStyle is drawn', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            more: 'Optional',
            style: const VFormHeaderStyle(
              titleStyle: TextStyle(color: Color(0xFF654321)),
              subtitleStyle: TextStyle(color: Color(0xFF123456)),
            ),
            child: Container(),
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Label')).style!.color,
        const Color(0xFF654321),
      );
      expect(
        tester.widget<Text>(find.text('Optional')).style!.color,
        const Color(0xFF123456),
      );
    });
  });
}
