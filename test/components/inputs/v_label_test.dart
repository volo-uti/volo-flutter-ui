import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VLabel', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('lg size uses the lg font size token', (tester) async {
      final sizes = VThemeData.light().sizes;
      expect(sizes.lg.fontSize, isNot(sizes.md.fontSize));

      await tester.pumpWidget(
        buildTestWidget(
          const VLabel(size: VLabelSize.lg, child: Text('Large')),
        ),
      );

      final style = tester
          .widget<RichText>(
            find.descendant(
              of: find.byType(VLabel),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;
      expect(style.fontSize, sizes.lg.fontSize);
    });

    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VLabel(child: Text('Email Address'))),
      );

      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('renders required asterisk when required=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VLabel(required: true, child: Text('Password'))),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('renders with child widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLabel(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Custom'), Text(' Label')],
            ),
          ),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text(' Label'), findsOneWidget);
    });

    testWidgets('size variants render', (tester) async {
      for (final size in VLabelSize.values) {
        await tester.pumpWidget(
          buildTestWidget(VLabel(size: size, child: const Text('Label'))),
        );

        expect(find.text('Label'), findsOneWidget);
      }
    });

    testWidgets('custom requiredMark renders', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VLabel(
            required: true,
            requiredMark: '(required)',
            child: Text('Field'),
          ),
        ),
      );

      expect(find.text('Field'), findsOneWidget);
      expect(find.text('(required)'), findsOneWidget);
    });
  });
}
