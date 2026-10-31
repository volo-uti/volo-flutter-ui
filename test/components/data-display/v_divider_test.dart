import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VDivider', () {
    group('default', () {
      testWidgets('renders horizontal divider', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider()));

        expect(find.byType(VDivider), findsOneWidget);
      });

      testWidgets('renders with 1px thickness', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider()));

        final container = tester.widget<Container>(find.byType(Container));
        // Container(height: 1) becomes tight height constraint
        expect(
          container.constraints,
          equals(const BoxConstraints.tightFor(height: 1)),
        );
      });

      testWidgets('uses theme border color by default', (tester) async {
        final theme = VThemeData.light();
        await tester.pumpWidget(buildTestWidget(const VDivider()));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(theme.colors.border));
      });
    });

    group('bold', () {
      testWidgets('renders bold divider', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.bold()));

        expect(find.byType(VDivider), findsOneWidget);
      });

      testWidgets('renders with 2px thickness', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.bold()));

        final container = tester.widget<Container>(find.byType(Container));
        expect(
          container.constraints,
          equals(const BoxConstraints.tightFor(height: 2)),
        );
      });
    });

    group('dashed', () {
      testWidgets('renders dashed divider', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.dashed()));

        expect(find.byType(VDivider), findsOneWidget);
      });

      testWidgets('uses CustomPaint for rendering', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.dashed()));

        expect(find.byType(CustomPaint), findsOneWidget);
      });

      testWidgets('renders with custom thickness', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VDivider.dashed(thickness: 3)),
        );

        expect(find.byType(VDivider), findsOneWidget);
        expect(find.byType(CustomPaint), findsOneWidget);
      });

      testWidgets('renders vertical dashed divider', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 100,
              child: VDivider.dashed(direction: Axis.vertical),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsOneWidget);
      });
    });

    group('label', () {
      testWidgets('renders with centered label text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VDivider.label(Text('OR'))),
        );

        expect(find.byType(VDivider), findsOneWidget);
        expect(find.text('OR'), findsOneWidget);
      });

      testWidgets('keeps the label in the semantics tree', (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          buildTestWidget(const VDivider.label(Text('OR'))),
        );

        expect(find.bySemanticsLabel('OR'), findsOneWidget);
        handle.dispose();
      });

      testWidgets('renders two line segments around label', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VDivider.label(Text('divider'))),
        );

        // Label variant renders a Row with two Expanded containers + Text
        expect(find.byType(Row), findsOneWidget);
        // Two Container segments (left + right lines)
        expect(find.byType(Container), findsNWidgets(2));
      });

      testWidgets('renders with custom color', (tester) async {
        const customColor = Color(0xFFFF0000);
        await tester.pumpWidget(
          buildTestWidget(
            const VDivider.label(Text('test'), color: customColor),
          ),
        );

        final containers = tester
            .widgetList<Container>(find.byType(Container))
            .toList();
        for (final container in containers) {
          expect(container.color, equals(customColor));
        }
      });

      testWidgets('uses muted foreground for label text', (tester) async {
        final theme = VThemeData.light();
        await tester.pumpWidget(
          buildTestWidget(const VDivider.label(Text('OR'))),
        );

        final style = DefaultTextStyle.of(tester.element(find.text('OR')));
        expect(style.style.color, equals(theme.colors.mutedForeground));
      });
    });

    group('direction', () {
      testWidgets('horizontal divider uses height constraint', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider()));

        final container = tester.widget<Container>(find.byType(Container));
        expect(
          container.constraints,
          equals(const BoxConstraints.tightFor(height: 1)),
        );
      });

      testWidgets('vertical divider uses width constraint', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 50,
              child: VDivider(direction: Axis.vertical),
            ),
          ),
        );

        expect(find.byType(VDivider), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        // Vertical divider sets width instead of height
        expect(
          container.constraints,
          equals(const BoxConstraints.tightFor(width: 1)),
        );
      });

      testWidgets('vertical bold divider renders with 2px width', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 50,
              child: VDivider.bold(direction: Axis.vertical),
            ),
          ),
        );

        expect(find.byType(VDivider), findsOneWidget);
      });
    });

    group('custom color', () {
      testWidgets('overrides theme color for default variant', (tester) async {
        const customColor = Color(0xFF00FF00);
        await tester.pumpWidget(
          buildTestWidget(const VDivider(color: customColor)),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(customColor));
      });

      testWidgets('overrides theme color for bold variant', (tester) async {
        const customColor = Color(0xFF0000FF);
        await tester.pumpWidget(
          buildTestWidget(const VDivider.bold(color: customColor)),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(customColor));
      });

      testWidgets('overrides theme color for dashed variant', (tester) async {
        const customColor = Color(0xFFFF00FF);
        await tester.pumpWidget(
          buildTestWidget(const VDivider.dashed(color: customColor)),
        );

        // Dashed variant still renders via CustomPaint
        expect(find.byType(CustomPaint), findsOneWidget);
      });
    });

    group('indent', () {
      testWidgets('applies left margin for horizontal indent', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider(indent: 16)));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.margin, equals(const EdgeInsets.only(left: 16)));
      });

      testWidgets('applies right margin for horizontal endIndent', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const VDivider(endIndent: 24)));

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.margin, equals(const EdgeInsets.only(right: 24)));
      });

      testWidgets('applies both indent and endIndent', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VDivider(indent: 10, endIndent: 20)),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(
          container.margin,
          equals(const EdgeInsets.only(left: 10, right: 20)),
        );
      });

      testWidgets('applies top margin for vertical indent', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 100,
              child: VDivider(direction: Axis.vertical, indent: 12),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.margin, equals(const EdgeInsets.only(top: 12)));
      });

      testWidgets('applies bottom margin for vertical endIndent', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 100,
              child: VDivider(direction: Axis.vertical, endIndent: 8),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.margin, equals(const EdgeInsets.only(bottom: 8)));
      });
    });

    group('custom thickness', () {
      testWidgets('applies custom thickness to horizontal divider', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const VDivider(thickness: 4)));

        final container = tester.widget<Container>(find.byType(Container));
        expect(
          container.constraints,
          equals(const BoxConstraints.tightFor(height: 4)),
        );
      });

      testWidgets('applies custom thickness to vertical divider', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 50,
              child: VDivider(direction: Axis.vertical, thickness: 3),
            ),
          ),
        );

        expect(find.byType(VDivider), findsOneWidget);
      });
    });

    group('semantics', () {
      testWidgets('wraps default variant with ExcludeSemantics', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const VDivider()));

        expect(find.byType(ExcludeSemantics), findsOneWidget);
      });

      testWidgets('wraps bold variant with ExcludeSemantics', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.bold()));

        expect(find.byType(ExcludeSemantics), findsOneWidget);
      });

      testWidgets('wraps dashed variant with ExcludeSemantics', (tester) async {
        await tester.pumpWidget(buildTestWidget(const VDivider.dashed()));

        expect(find.byType(ExcludeSemantics), findsOneWidget);
      });

      testWidgets('excludes only the two lines of the label variant', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VDivider.label(Text('test'))),
        );

        expect(find.byType(ExcludeSemantics), findsNWidgets(2));
        expect(
          find.ancestor(
            of: find.text('test'),
            matching: find.byType(ExcludeSemantics),
          ),
          findsNothing,
        );
      });

      testWidgets('wraps vertical variant with ExcludeSemantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const SizedBox(
              height: 50,
              child: VDivider(direction: Axis.vertical),
            ),
          ),
        );

        expect(find.byType(ExcludeSemantics), findsOneWidget);
      });
    });

    group('constants', () {
      test('kDashWidth is 4.0', () {
        expect(VDivider.kDashWidth, equals(4.0));
      });

      test('kDashSpace is 4.0', () {
        expect(VDivider.kDashSpace, equals(4.0));
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to divider', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VDividerStyle(color: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VDivider(),
            ),
          ),
        );

        expect(find.byType(VDivider), findsOneWidget);
      });
    });
  });
}
