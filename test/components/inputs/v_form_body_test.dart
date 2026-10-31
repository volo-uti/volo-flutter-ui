import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormBody', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormBody', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VFormBody(child: Text('Content'))),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    group('type', () {
      testWidgets('type=outlined', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VFormBody(child: Text('outlined'))),
        );

        expect(find.text('outlined'), findsOneWidget);
      });

      testWidgets('type=filled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(type: VFormBodyType.filled, child: Text('filled')),
          ),
        );

        expect(find.text('filled'), findsOneWidget);
      });

      testWidgets('type=underline', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(
              type: VFormBodyType.underline,
              child: Text('underline'),
            ),
          ),
        );

        expect(find.text('underline'), findsOneWidget);
      });
    });

    group('size', () {
      testWidgets('size=sm', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(size: VFormBodySize.sm, child: Text('Small')),
          ),
        );

        expect(find.text('Small'), findsOneWidget);
      });

      testWidgets('size=lg', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(size: VFormBodySize.lg, child: Text('Large')),
          ),
        );

        expect(find.text('Large'), findsOneWidget);
      });
    });

    testWidgets('displays leading', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(leading: Text('Front'), child: Text('Content')),
        ),
      );

      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays trailing', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(trailing: Text('Back'), child: Text('Content')),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('opacity 50% when enabled=false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(enabled: false, child: Text('Disabled')),
        ),
      );

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.5);
    });

    testWidgets('error and success change the border color', (tester) async {
      Color? borderColor(Widget body) {
        final box = tester
            .widgetList<Container>(find.byType(Container))
            .map((c) => c.decoration)
            .whereType<BoxDecoration>()
            .map((d) => d.border)
            .whereType<Border>()
            .first;
        return box.top.color;
      }

      final colors = VThemeData.light().colors;

      await tester.pumpWidget(
        buildTestWidget(const VFormBody(error: true, child: Text('x'))),
      );
      expect(borderColor(const Text('x')), colors.destructive);

      await tester.pumpWidget(
        buildTestWidget(const VFormBody(success: true, child: Text('x'))),
      );
      expect(borderColor(const Text('x')), colors.success);
    });

    testWidgets('fullWidth=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Center(
            child: SizedBox(
              width: 300,
              child: VFormBody(fullWidth: true, child: Text('Full')),
            ),
          ),
        ),
      );

      expect(find.text('Full'), findsOneWidget);
    });
  });
}
