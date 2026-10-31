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
  });
}
