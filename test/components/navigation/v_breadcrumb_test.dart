import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VBreadcrumb', () {
    testWidgets('renders empty when no items', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VBreadcrumb(items: [])));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
              const VBreadcrumbItem(label: Text('Electronics')),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('renders default separator', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const VBreadcrumbItem(label: Text('Current')),
            ],
          ),
        ),
      );

      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('renders custom separator', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            separator: const Text('>'),
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const VBreadcrumbItem(label: Text('Current')),
            ],
          ),
        ),
      );

      expect(find.text('>'), findsOneWidget);
    });

    testWidgets('calls onTap when link is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(
                label: const Text('Home'),
                onTap: () => tapped = true,
              ),
              const VBreadcrumbItem(label: Text('Current')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(
                label: const Text('Home'),
                icon: const Icon(Icons.home),
                onTap: () {},
              ),
              const VBreadcrumbItem(label: Text('Current')),
            ],
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    // ── FocusTraversalGroup ──────────────────────────────────────────

    testWidgets('wraps content in FocusTraversalGroup', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const VBreadcrumbItem(label: Text('Current')),
            ],
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(VBreadcrumb),
          matching: find.byType(FocusTraversalGroup),
        ),
        findsOneWidget,
      );
    });

    testWidgets('truncates when maxItems exceeded', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            maxItems: 3,
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
              VBreadcrumbItem(label: const Text('Electronics'), onTap: () {}),
              VBreadcrumbItem(label: const Text('Phones'), onTap: () {}),
              const VBreadcrumbItem(label: Text('iPhone')),
            ],
          ),
        ),
      );

      expect(find.text('...'), findsOneWidget);
    });
  });

  group('VBreadcrumb label slot', () {
    testWidgets('a plain Text takes the item style', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const VBreadcrumbItem(label: Text('Now')),
            ],
          ),
        ),
      );

      final theme = VThemeData.light();
      final link = tester
          .renderObject<RenderParagraph>(find.text('Home'))
          .text
          .style!;
      final current = tester
          .renderObject<RenderParagraph>(find.text('Now'))
          .text
          .style!;
      expect(link.fontSize, theme.typography.bodyMedium.fontSize);
      expect(link.color, theme.colors.mutedForeground);
      expect(current.color, theme.colors.foreground);
      expect(current.fontWeight, FontWeight.w500);
    });

    testWidgets('an item without onTap is not tappable', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VBreadcrumb(
            items: [
              VBreadcrumbItem(label: Text('A')),
              VBreadcrumbItem(label: Text('B')),
            ],
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
    });
  });

  group('VBreadcrumb regressions', () {
    testWidgets('Enter and Space follow a focused link', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VBreadcrumb(
            items: [
              VBreadcrumbItem(label: const Text('Home'), onTap: () => taps++),
              const VBreadcrumbItem(label: Text('Here')),
            ],
          ),
        ),
      );

      Focus.of(tester.element(find.text('Home'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);

      expect(taps, 2);
    });
  });
}
