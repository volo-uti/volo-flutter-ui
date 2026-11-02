import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormField', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormField', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(label: 'Label', child: Text('Content')),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('includes header and footer', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            label: 'Label',
            required: true,
            helper: 'Helper text',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
      expect(find.text('Helper text'), findsOneWidget);
    });

    testWidgets('custom header', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            header: Text('Custom Header'),
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Custom Header'), findsOneWidget);
    });

    testWidgets('custom footer', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            label: 'Label',
            footer: Text('Custom Footer'),
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Custom Footer'), findsOneWidget);
    });

    testWidgets('error message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            label: 'Label',
            error: true,
            errorText: 'Error message',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('success message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            label: 'Label',
            success: true,
            successText: 'Success message',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Success message'), findsOneWidget);
    });

    testWidgets('maxLength counter', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormField(
            label: 'Label',
            maxLength: 50,
            child: Text('Content'),
          ),
        ),
      );

      // currentLength uses VFormFooter internal default (0).
      expect(find.text('0/50'), findsOneWidget);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('labelStyle reaches the header label ($via)', (tester) async {
        const style = VFormFieldStyle(
          labelStyle: TextStyle(fontSize: 20, color: Color(0xFF654321)),
        );
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VFormField(
                label: 'Label',
                style: viaTheme ? null : style,
                child: const Text('Content'),
              ),
            ),
          ),
        );

        final label = tester.widget<Text>(find.text('Label')).style!;
        expect(label.fontSize, 20);
        expect(label.color, const Color(0xFF654321));
      });
    }

    testWidgets('labelStyle wins over the theme header titleStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VFormHeaderStyle(titleStyle: TextStyle(fontSize: 11)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VFormField(
              label: 'Label',
              style: VFormFieldStyle(labelStyle: TextStyle(fontSize: 20)),
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('Label')).style!.fontSize, 20);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('helperStyle and errorStyle reach the footer ($via)', (
        tester,
      ) async {
        const style = VFormFieldStyle(
          helperStyle: TextStyle(fontSize: 15, color: Color(0xFF00AA00)),
          errorStyle: TextStyle(fontSize: 16, color: Color(0xFFAA0000)),
        );
        Widget field({required bool error}) => VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VFormField(
              helper: 'Help',
              error: error,
              errorText: 'Wrong',
              style: viaTheme ? null : style,
              child: const Text('Content'),
            ),
          ),
        );

        await tester.pumpWidget(field(error: false));
        final help = tester.widget<Text>(find.text('Help')).style!;
        expect(help.fontSize, 15);
        expect(help.color, const Color(0xFF00AA00));

        await tester.pumpWidget(field(error: true));
        final error = tester.widget<Text>(find.text('Wrong')).style!;
        expect(error.fontSize, 16);
        expect(error.color, const Color(0xFFAA0000));
      });
    }

    testWidgets('helperStyle wins over the theme footer helperStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VFormFooterStyle(helperStyle: TextStyle(fontSize: 9)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VFormField(
              helper: 'Help',
              style: VFormFieldStyle(helperStyle: TextStyle(fontSize: 15)),
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('Help')).style!.fontSize, 15);
    });
  });
}
