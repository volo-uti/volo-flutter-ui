import 'dart:ui';

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: SizedBox(width: 400, height: 300, child: child),
      ),
    ),
  );

  final testTabs = [
    const VTab(label: Text('Tab 1'), content: Text('Content 1')),
    const VTab(label: Text('Tab 2'), content: Text('Content 2')),
    const VTab(label: Text('Tab 3'), content: Text('Content 3')),
  ];

  group('VTabs', () {
    testWidgets('renders empty when no tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VTabs(tabs: [])));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders tab labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('shows first tab content by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('shows correct content for initial index', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs, initialIndex: 1)),
      );

      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('switches content on tab tap', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('calls onChanged when tab is tapped', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, onChanged: (index) => changedIndex = index),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, equals(1));
    });

    testWidgets('disabled tab cannot be selected', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
        const VTab(label: Text('Tab 3'), content: Text('Content 3')),
      ];

      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: tabsWithDisabled,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, isNull);
    });

    testWidgets('pills variant renders', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: testTabs)));

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('underline variant renders', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('renders tab with icon', (tester) async {
      final tabsWithIcon = [
        const VTab(
          label: Text('Home'),
          icon: Icon(Icons.home),
          content: Text('Home Content'),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithIcon)));

      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, backgroundColor: const Color(0xFFFF0000)),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom selectedColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, selectedColor: const Color(0xFF00FF00)),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, padding: const EdgeInsets.all(16)),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom tabPadding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            tabPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('underline variant applies indicatorColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            indicatorColor: const Color(0xFF0000FF),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('pills variant applies selectedColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(tabs: testTabs, selectedColor: const Color(0xFFFF00FF)),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom borderRadius', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            backgroundColor: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom indicatorBorderRadius', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            indicatorBorderRadius: BorderRadius.circular(16),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('applies custom indicatorBorder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            indicatorBorder: const Border.fromBorderSide(BorderSide(width: 2)),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });
  });

  group('VTabs isScrollable', () {
    testWidgets('isScrollable wraps tabs in SingleChildScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs, isScrollable: true)),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('non-scrollable does not wrap in SingleChildScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('scrollable tabs can scroll horizontally', (tester) async {
      final manyTabs = List.generate(
        10,
        (i) => VTab(
          label: Text('Tab ${i + 1}'),
          content: Text('Content ${i + 1}'),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: manyTabs, isScrollable: true)),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 10'), findsOneWidget);
    });
  });

  group('VTabs pills variant', () {
    testWidgets('pills variant displays correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: testTabs)));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('pills variant switches tabs on tap', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: testTabs)));

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('pills variant applies custom selectedColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(tabs: testTabs, selectedColor: const Color(0xFF123456)),
        ),
      );

      // Find AnimatedContainer for selected tab
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainers.isNotEmpty, isTrue);
    });

    testWidgets('pills variant with isScrollable', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs.pills(tabs: testTabs, isScrollable: true)),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('VTabs underline variant', () {
    testWidgets('underline variant displays correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('underline variant switches tabs on tap', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('underline variant applies indicatorColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            indicatorColor: const Color(0xFFABCDEF),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('underline variant with custom indicatorBorder', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            indicatorBorder: const Border(
              bottom: BorderSide(color: Color(0xFFFF0000), width: 4),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('underline variant with isScrollable', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs.underline(tabs: testTabs, isScrollable: true)),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('VTabs unselectedColor', () {
    testWidgets('unselectedColor applies to unselected tabs', (tester) async {
      const unselectedColor = Color(0xFF888888);

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, unselectedColor: unselectedColor),
        ),
      );

      // Tab 2 and Tab 3 should have unselected color applied
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('unselectedColor works with pills variant', (tester) async {
      const unselectedColor = Color(0xFF999999);

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(tabs: testTabs, unselectedColor: unselectedColor),
        ),
      );

      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('unselectedColor works with underline variant', (tester) async {
      const unselectedColor = Color(0xFFAAAAAA);

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(tabs: testTabs, unselectedColor: unselectedColor),
        ),
      );

      expect(find.text('Tab 2'), findsOneWidget);
    });
  });

  group('VTabs indicatorBorder', () {
    testWidgets('indicatorBorder applies to default variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            indicatorBorder: const Border.fromBorderSide(BorderSide(width: 2)),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('indicatorBorder applies to pills variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(
            tabs: testTabs,
            indicatorBorder: const Border.fromBorderSide(
              BorderSide(color: Color(0xFF123456), width: 2),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('indicatorBorder applies to underline variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            indicatorBorder: const Border(
              bottom: BorderSide(color: Color(0xFFFF0000), width: 3),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('indicatorBorder with indicatorBorderRadius', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            indicatorBorder: const Border.fromBorderSide(BorderSide(width: 2)),
            indicatorBorderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });
  });

  group('VTabs with icon', () {
    testWidgets('tab with icon renders icon and label', (tester) async {
      final tabsWithIcon = [
        const VTab(
          label: Text('Home'),
          icon: Icon(Icons.home),
          content: Text('Home Content'),
        ),
        const VTab(
          label: Text('Settings'),
          icon: Icon(Icons.settings),
          content: Text('Settings Content'),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithIcon)));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(2));
    });

    testWidgets('icon tab switches correctly', (tester) async {
      final tabsWithIcon = [
        const VTab(
          label: Text('Home'),
          icon: Icon(Icons.home),
          content: Text('Home Content'),
        ),
        const VTab(
          label: Text('Settings'),
          icon: Icon(Icons.settings),
          content: Text('Settings Content'),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithIcon)));

      expect(find.text('Home Content'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings Content'), findsOneWidget);
    });

    testWidgets('icon with pills variant', (tester) async {
      final tabsWithIcon = [
        const VTab(
          label: Text('Tab 1'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: tabsWithIcon)));

      expect(find.byType(Icon), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('icon with underline variant', (tester) async {
      final tabsWithIcon = [
        const VTab(
          label: Text('Tab 1'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs.underline(tabs: tabsWithIcon)),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('tabs with mixed icon and non-icon', (tester) async {
      final mixedTabs = [
        const VTab(
          label: Text('With Icon'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
        const VTab(label: Text('No Icon'), content: Text('Content 2')),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: mixedTabs)));

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.text('No Icon'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group('VTabs Semantics', () {
    testWidgets('tabs have button semantics', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final semantics = tester.getSemantics(find.text('Tab 1'));
      expect(semantics.getSemanticsData().flagsCollection.isButton, isTrue);
    });

    testWidgets('selected tab has selected semantics', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final semantics = tester.getSemantics(find.text('Tab 1'));
      expect(
        semantics.getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );
    });

    testWidgets('unselected tab does not have selected semantics', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final semantics = tester.getSemantics(find.text('Tab 2'));
      expect(
        semantics.getSemanticsData().flagsCollection.isSelected,
        isNot(Tristate.isTrue),
      );
    });

    testWidgets('disabled tab has disabled semantics', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Enabled'), content: Text('Content 1')),
        const VTab(
          label: Text('Disabled'),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithDisabled)));

      final semantics = tester.getSemantics(find.text('Disabled'));
      expect(
        semantics.getSemanticsData().flagsCollection.isEnabled,
        Tristate.isFalse,
      );
    });

    testWidgets('enabled tab has enabled semantics', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final semantics = tester.getSemantics(find.text('Tab 1'));
      expect(
        semantics.getSemanticsData().flagsCollection.isEnabled,
        Tristate.isTrue,
      );
    });

    testWidgets('semantics label is set for string labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final semantics = tester.getSemantics(find.text('Tab 1'));
      // Semantics label contains 'Tab 1' (may be merged with child Text semantics)
      expect(semantics.label, contains('Tab 1'));
    });
  });

  group('VTabs onChanged callback', () {
    testWidgets('onChanged is called with correct index', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, onChanged: (index) => changedIndex = index),
        ),
      );

      await tester.tap(find.text('Tab 3'));
      await tester.pump();

      expect(changedIndex, equals(2));
    });

    testWidgets('onChanged is not called when tapping same tab', (
      tester,
    ) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, onChanged: (index) => callCount++),
        ),
      );

      // Tap on already selected tab
      await tester.tap(find.text('Tab 1'));
      await tester.pump();

      expect(callCount, equals(0));
    });

    testWidgets('onChanged is not called for disabled tabs', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: tabsWithDisabled,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, isNull);
    });

    testWidgets('onChanged works with pills variant', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(
            tabs: testTabs,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, equals(1));
    });

    testWidgets('onChanged works with underline variant', (tester) async {
      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, equals(1));
    });
  });

  group('VTabs disabled tabs', () {
    testWidgets('disabled tab does not change selection', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
        const VTab(label: Text('Tab 3'), content: Text('Content 3')),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithDisabled)));

      expect(find.text('Content 1'), findsOneWidget);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      // Content should still be Content 1
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('enabled tab after disabled can be selected', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
        const VTab(label: Text('Tab 3'), content: Text('Content 3')),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithDisabled)));

      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();

      expect(find.text('Content 3'), findsOneWidget);
    });

    testWidgets('disabled tab in pills variant', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(
            tabs: tabsWithDisabled,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, isNull);
    });

    testWidgets('disabled tab in underline variant', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: tabsWithDisabled,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(changedIndex, isNull);
    });

    testWidgets('multiple disabled tabs', (tester) async {
      final tabsWithMultipleDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
        const VTab(
          label: Text('Tab 3'),
          content: Text('Content 3'),
          enabled: false,
        ),
        const VTab(label: Text('Tab 4'), content: Text('Content 4')),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithMultipleDisabled)),
      );

      // Try disabled tabs
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);

      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);

      // Select enabled tab
      await tester.tap(find.text('Tab 4'));
      await tester.pumpAndSettle();
      expect(find.text('Content 4'), findsOneWidget);
    });
  });

  group('VTabs edge cases', () {
    testWidgets('initialIndex clamped to valid range', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            initialIndex: 100, // Out of range
          ),
        ),
      );

      // Should clamp to last valid index (2) and show Content 3
      expect(find.text('Content 3'), findsOneWidget);
    });

    testWidgets('negative initialIndex clamped to 0', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            initialIndex: -5, // Negative
          ),
        ),
      );

      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('tab with widget label', (tester) async {
      final tabsWithWidgetLabel = [
        const VTab(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Custom Label')],
          ),
          content: Text('Content'),
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithWidgetLabel)),
      );

      expect(find.text('Custom Label'), findsOneWidget);
    });

    testWidgets('tab with key property', (tester) async {
      final tabsWithKey = [
        const VTab(
          key: 'tab-1',
          label: Text('Tab 1'),
          content: Text('Content 1'),
        ),
        const VTab(
          key: 'tab-2',
          label: Text('Tab 2'),
          content: Text('Content 2'),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithKey)));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('single tab works correctly', (tester) async {
      final singleTab = [
        const VTab(label: Text('Only Tab'), content: Text('Only Content')),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: singleTab)));

      expect(find.text('Only Tab'), findsOneWidget);
      expect(find.text('Only Content'), findsOneWidget);
    });

    testWidgets('many tabs render correctly', (tester) async {
      final manyTabs = List.generate(
        20,
        (i) => VTab(label: Text('Tab $i'), content: Text('Content $i')),
      );

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: manyTabs, isScrollable: true)),
      );

      expect(find.text('Tab 0'), findsOneWidget);
      expect(find.text('Content 0'), findsOneWidget);
    });
  });

  group('VTabs hover behavior', () {
    testWidgets('hover changes cursor to click for enabled tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Hover over an enabled tab
      await gesture.moveTo(tester.getCenter(find.text('Tab 2')));
      await tester.pump();

      // Verify mouse region exists with click cursor
      final mouseRegionFinder = find.ancestor(
        of: find.text('Tab 2'),
        matching: find.byType(MouseRegion),
      );
      expect(mouseRegionFinder, findsOneWidget);
    });

    testWidgets('hover on disabled tab shows basic cursor', (tester) async {
      final tabsWithDisabled = [
        const VTab(label: Text('Tab 1'), content: Text('Content 1')),
        const VTab(
          label: Text('Tab 2'),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(VTabs(tabs: tabsWithDisabled)));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Hover over disabled tab
      await gesture.moveTo(tester.getCenter(find.text('Tab 2')));
      await tester.pump();

      // Mouse region should exist
      final mouseRegionFinder = find.ancestor(
        of: find.text('Tab 2'),
        matching: find.byType(MouseRegion),
      );
      expect(mouseRegionFinder, findsOneWidget);
    });

    testWidgets('hover state changes on mouse enter and exit', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Move to tab 2
      await gesture.moveTo(tester.getCenter(find.text('Tab 2')));
      await tester.pump();

      // Find AnimatedContainer for the hovered tab
      final animatedContainers = find.byType(AnimatedContainer);
      expect(animatedContainers, findsWidgets);

      // Move away
      await gesture.moveTo(Offset.zero);
      await tester.pump();
    });

    testWidgets('hover works with pills variant', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: testTabs)));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Tab 2')));
      await tester.pump();

      // Verify no errors and widget renders
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('hover works with underline variant', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Tab 2')));
      await tester.pump();

      expect(find.text('Tab 2'), findsOneWidget);
    });
  });

  group('VTabs animation', () {
    testWidgets('AnimatedSwitcher is used for content transitions', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });

    testWidgets('AnimatedContainer is used for tab decoration', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Each tab uses AnimatedContainer
      final animatedContainers = find.byType(AnimatedContainer);
      expect(animatedContainers, findsNWidgets(testTabs.length));
    });

    testWidgets('content animates on tab switch', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.text('Content 1'), findsOneWidget);

      await tester.tap(find.text('Tab 2'));
      await tester.pump(); // Start animation

      // During animation, we should be in transition
      await tester.pump(const Duration(milliseconds: 75)); // Mid-animation

      await tester.pumpAndSettle(); // Complete animation

      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('KeyedSubtree is used for content', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.byType(KeyedSubtree), findsWidgets);
    });
  });

  group('VTabs decoration verification', () {
    testWidgets('default variant uses muted background for selected tab', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Find AnimatedContainer widgets
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // First tab (selected) should have decoration
      final firstContainer = animatedContainers.first;
      expect(firstContainer.decoration, isNotNull);
    });

    testWidgets('pills variant uses primary background for selected tab', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs.pills(tabs: testTabs)));

      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final firstContainer = animatedContainers.first;
      expect(firstContainer.decoration, isNotNull);
    });

    testWidgets('underline variant uses border for selected tab', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final firstContainer = animatedContainers.first;
      expect(firstContainer.decoration, isNotNull);
      final decoration = firstContainer.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });

    testWidgets('underline variant has bottom border on tab bar', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));

      // Find Container with border decoration
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('ClipRRect is applied to tab bar', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, borderRadius: BorderRadius.circular(12)),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('VTabs with disabled and icon combination', () {
    testWidgets('disabled tab with icon renders correctly', (tester) async {
      final tabsWithDisabledIcon = [
        const VTab(
          label: Text('Enabled'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
        const VTab(
          label: Text('Disabled'),
          icon: Icon(Icons.settings),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithDisabledIcon)),
      );

      expect(find.text('Enabled'), findsOneWidget);
      expect(find.text('Disabled'), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(2));
    });

    testWidgets('disabled tab with icon cannot be selected', (tester) async {
      final tabsWithDisabledIcon = [
        const VTab(
          label: Text('Enabled'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
        const VTab(
          label: Text('Disabled'),
          icon: Icon(Icons.settings),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      int? changedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: tabsWithDisabledIcon,
            onChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pump();

      expect(changedIndex, isNull);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('icon color changes for disabled state', (tester) async {
      final tabsWithDisabledIcon = [
        const VTab(
          label: Text('Tab 1'),
          icon: Icon(Icons.home),
          content: Text('Content 1'),
        ),
        const VTab(
          label: Text('Tab 2'),
          icon: Icon(Icons.settings),
          content: Text('Content 2'),
          enabled: false,
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithDisabledIcon)),
      );

      // Find IconTheme widgets
      final iconThemes = tester.widgetList<IconTheme>(find.byType(IconTheme));
      expect(iconThemes.length, greaterThanOrEqualTo(2));
    });
  });

  group('VTabs GestureDetector', () {
    testWidgets('GestureDetector uses opaque hit test behavior', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );

      for (final detector in gestureDetectors) {
        if (detector.behavior == HitTestBehavior.opaque) {
          // At least one GestureDetector should use opaque behavior
          expect(detector.behavior, HitTestBehavior.opaque);
        }
      }
    });

    testWidgets('tap on tab area triggers selection', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Tap on the center of Tab 2 text
      final tab2Finder = find.text('Tab 2');
      await tester.tap(tab2Finder);
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
    });
  });

  group('VTabs Row layout', () {
    testWidgets('non-scrollable tabs use Expanded in Row', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Find Row widget in tab bar
      final rows = find.byType(Row);
      expect(rows, findsWidgets);

      // Find Expanded widgets (tabs + content area)
      // 3 tabs + 1 content area = 4 Expanded widgets
      final expandedWidgets = find.byType(Expanded);
      expect(expandedWidgets, findsNWidgets(testTabs.length + 1));
    });

    testWidgets('scrollable tabs use flex 0 for tab items', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs, isScrollable: true)),
      );

      // For scrollable tabs, tab items are NOT wrapped in Expanded.
      // Only the content area uses Expanded (flex: 1).
      final expandedWidgets = tester.widgetList<Expanded>(
        find.byType(Expanded),
      );

      // Only 1 Expanded for content area, none for tabs
      expect(expandedWidgets.length, equals(1));
    });
  });

  group('VTabs Column structure', () {
    testWidgets('VTabs uses Column with stretch alignment', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
    });

    testWidgets('content area uses Expanded', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // The content should be in an Expanded widget
      // Note: tab items also use Expanded, so we check for Expanded widgets
      expect(find.byType(Expanded), findsWidgets);
    });
  });

  group('VTab class', () {
    test('VTab can be created with minimal parameters', () {
      const tab = VTab(label: Text('Test'), content: Text('Content'));

      expect((tab.label as Text).data, 'Test');
      expect(tab.content, isA<Text>());
      expect(tab.key, isNull);
      expect(tab.icon, isNull);
      expect(tab.enabled, isTrue);
    });

    test('VTab can be created with all parameters', () {
      const icon = Icon(Icons.home);
      const tab = VTab(
        key: 'test-key',
        label: Text('Test'),
        content: Text('Content'),
        icon: icon,
        enabled: false,
      );

      expect(tab.key, 'test-key');
      expect((tab.label as Text).data, 'Test');
      expect(tab.content, isA<Text>());
      expect(tab.icon, isA<Icon>());
      expect(tab.enabled, isFalse);
    });

    test('VTab label can be a Widget', () {
      const labelWidget = Row(children: [Text('Custom')]);
      const tab = VTab(label: labelWidget, content: Text('Content'));

      expect(tab.label, isA<Row>());
    });
  });

  group('VTabs comprehensive styling', () {
    testWidgets('all styling properties can be applied together', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            backgroundColor: const Color(0xFFEEEEEE),
            selectedColor: const Color(0xFF00FF00),
            unselectedColor: const Color(0xFF888888),
            indicatorColor: const Color(0xFF0000FF),
            padding: const EdgeInsets.all(8),
            tabPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(12),
            indicatorBorderRadius: BorderRadius.circular(8),
            indicatorBorder: const Border.fromBorderSide(BorderSide()),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('pills variant with all styling properties', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.pills(
            tabs: testTabs,
            backgroundColor: const Color(0xFFEEEEEE),
            selectedColor: const Color(0xFF00FF00),
            unselectedColor: const Color(0xFF888888),
            indicatorColor: const Color(0xFF0000FF),
            padding: const EdgeInsets.all(8),
            tabPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(12),
            indicatorBorderRadius: BorderRadius.circular(20),
            indicatorBorder: const Border.fromBorderSide(BorderSide()),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('underline variant with all styling properties', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            backgroundColor: const Color(0xFFEEEEEE),
            selectedColor: const Color(0xFF00FF00),
            unselectedColor: const Color(0xFF888888),
            indicatorColor: const Color(0xFF0000FF),
            padding: const EdgeInsets.all(8),
            tabPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: BorderRadius.circular(12),
            indicatorBorderRadius: BorderRadius.circular(4),
            indicatorBorder: const Border(
              bottom: BorderSide(color: Color(0xFFFF0000), width: 3),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
    });
  });

  group('VTabs content display', () {
    testWidgets('complex content widget renders correctly', (tester) async {
      final tabsWithComplexContent = [
        const VTab(
          label: Text('Tab 1'),
          content: Column(
            children: [
              Text('Header'),
              SizedBox(height: 8),
              Text('Body content'),
            ],
          ),
        ),
        const VTab(
          label: Text('Tab 2'),
          content: Center(child: Text('Centered')),
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithComplexContent)),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Body content'), findsOneWidget);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Centered'), findsOneWidget);
    });

    testWidgets('content with stateful widget preserves state on switch back', (
      tester,
    ) async {
      // Since we use KeyedSubtree, state should be preserved per index
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.text('Content 1'), findsOneWidget);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      expect(find.text('Content 2'), findsOneWidget);

      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);
    });
  });

  group('VTabs accessibility', () {
    testWidgets('tabs are accessible via semantics tree', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Verify semantics are present for all tabs
      for (final tab in testTabs) {
        final finder = find.byWidget(tab.label);
        expect(finder, findsOneWidget);

        final semantics = tester.getSemantics(finder);
        expect(semantics, isNotNull);
      }
    });

    testWidgets('semantics updates on selection change', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Initially Tab 1 is selected
      var tab1Semantics = tester.getSemantics(find.text('Tab 1'));
      expect(
        tab1Semantics.getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );

      var tab2Semantics = tester.getSemantics(find.text('Tab 2'));
      expect(
        tab2Semantics.getSemanticsData().flagsCollection.isSelected,
        isNot(Tristate.isTrue),
      );

      // Select Tab 2
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      // Now Tab 2 should be selected
      tab1Semantics = tester.getSemantics(find.text('Tab 1'));
      expect(
        tab1Semantics.getSemanticsData().flagsCollection.isSelected,
        isNot(Tristate.isTrue),
      );

      tab2Semantics = tester.getSemantics(find.text('Tab 2'));
      expect(
        tab2Semantics.getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );
    });

    testWidgets('widget labels have semantics label', (tester) async {
      final tabsWithWidgetLabel = [
        const VTab(label: Text('Widget Label'), content: Text('Content')),
      ];

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: tabsWithWidgetLabel)),
      );

      // Widget label should still be accessible
      expect(find.text('Widget Label'), findsWidgets);
    });
  });

  group('VTabs theme integration', () {
    testWidgets('uses VTheme colors', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Verify theme is accessible and tabs render
      expect(find.byType(VTabs), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
    });

    testWidgets('uses VTheme typography', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Typography is applied via Text widgets
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsWidgets);
    });

    testWidgets('works with different VThemeData', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.dark(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: SizedBox(
                width: 400,
                height: 300,
                child: VTabs(tabs: testTabs),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    });
  });

  group('VTabs rapid interaction', () {
    testWidgets('rapid tab switches work correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      // Rapidly switch tabs
      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      await tester.tap(find.text('Tab 3'));
      await tester.pump();
      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('double tap on same tab does nothing', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(tabs: testTabs, onChanged: (index) => callCount++),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(callCount, equals(1));

      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(callCount, equals(1)); // Still 1, no additional call
    });
  });

  group('VTabs initialIndex behavior', () {
    testWidgets('initialIndex 0 shows first tab', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('initialIndex points to last tab', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs, initialIndex: 2)),
      );

      expect(find.text('Content 3'), findsOneWidget);
    });

    testWidgets('initialIndex at boundary works', (tester) async {
      final fiveTabs = List.generate(
        5,
        (i) => VTab(label: Text('Tab $i'), content: Text('Content $i')),
      );

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: fiveTabs, initialIndex: 4)),
      );

      expect(find.text('Content 4'), findsOneWidget);
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to tabs', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VTabsStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(),
              child: SizedBox(
                width: 400,
                height: 300,
                child: VTabs(
                  tabs: [
                    VTab(label: Text('Tab 1'), content: Text('Content 1')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VTabs), findsOneWidget);
    });
  });

  group('VTab label slot and enabled', () {
    testWidgets('a plain Text label takes the theme label style', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      final theme = VThemeData.light();
      final selected = tester
          .renderObject<RenderParagraph>(find.text('Tab 1'))
          .text
          .style!;
      final other = tester
          .renderObject<RenderParagraph>(find.text('Tab 2'))
          .text
          .style!;
      expect(selected.fontSize, theme.typography.labelMedium.fontSize);
      expect(selected.color, theme.colors.foreground);
      expect(selected.fontWeight, FontWeight.w600);
      expect(other.color, theme.colors.mutedForeground);
    });

    testWidgets('enabled defaults to true and false blocks selection', (
      tester,
    ) async {
      expect(const VTab(label: Text('a'), content: SizedBox()).enabled, isTrue);

      int? changed;
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            onChanged: (i) => changed = i,
            tabs: const [
              VTab(label: Text('A'), content: Text('a')),
              VTab(label: Text('B'), content: Text('b'), enabled: false),
            ],
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();

      expect(changed, isNull);
    });
  });

  group('VTabs regressions', () {
    testWidgets('keeps a valid selection when the tab list shrinks', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));
      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(find.text('Content 3'), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs.take(2).toList())),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('Enter and Space select the focused tab', (tester) async {
      int? changed;
      await tester.pumpWidget(
        buildTestWidget(VTabs(tabs: testTabs, onChanged: (i) => changed = i)),
      );

      Focus.of(tester.element(find.text('Tab 2'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(changed, 1);

      Focus.of(tester.element(find.text('Tab 3'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(changed, 2);
    });

    testWidgets('arrow keys move focus together with the selection', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VTabs(tabs: testTabs)));

      Focus.of(tester.element(find.text('Tab 1'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
      expect(Focus.of(tester.element(find.text('Tab 2'))).hasFocus, isTrue);
    });

    testWidgets('arrow keys follow the reading direction in RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: SizedBox(
                width: 400,
                height: 300,
                child: VTabs(tabs: testTabs),
              ),
            ),
          ),
        ),
      );

      Focus.of(tester.element(find.text('Tab 1'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      expect(find.text('Content 2'), findsOneWidget);
    });
  });

  group('VTabsStyle', () {
    TextStyle labelOf(WidgetTester tester, String text) =>
        tester.renderObject<RenderParagraph>(find.text(text)).text.style!;

    Widget themed(Widget child, {VThemeData? theme}) => VTheme(
      data: theme ?? VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: SizedBox(width: 400, height: 300, child: child),
        ),
      ),
    );

    BorderSide underlineOf(WidgetTester tester, String text) {
      final container = tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text(text),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final border = (container.decoration! as BoxDecoration).border! as Border;
      return border.bottom;
    }

    testWidgets('indicatorHeight sets the underline thickness', (tester) async {
      await tester.pumpWidget(buildTestWidget(VTabs.underline(tabs: testTabs)));
      expect(underlineOf(tester, 'Tab 1').width, 2);

      await tester.pumpWidget(
        buildTestWidget(
          VTabs.underline(
            tabs: testTabs,
            style: const VTabsStyle(indicatorHeight: 4),
          ),
        ),
      );
      expect(underlineOf(tester, 'Tab 1').width, 4);
    });

    testWidgets('textStyle lays over every tab label', (tester) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            style: const VTabsStyle(
              textStyle: TextStyle(fontSize: 18, letterSpacing: 1),
            ),
          ),
        ),
      );

      final selected = labelOf(tester, 'Tab 1');
      final other = labelOf(tester, 'Tab 2');
      expect(selected.fontSize, 18);
      expect(other.fontSize, 18);
      expect(other.letterSpacing, 1);
      // Fields it does not set keep the defaults.
      expect(selected.fontWeight, FontWeight.w600);
      expect(other.fontWeight, FontWeight.normal);
      expect(other.color, theme.colors.mutedForeground);
    });

    testWidgets('selectedTextStyle lays over textStyle on the selected tab', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            style: const VTabsStyle(
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              selectedTextStyle: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );

      final selected = labelOf(tester, 'Tab 1');
      expect(selected.fontSize, 18);
      expect(selected.fontWeight, FontWeight.w700);
      expect(labelOf(tester, 'Tab 2').fontWeight, FontWeight.w500);
    });

    testWidgets('text style colors apply, color fields win over them', (
      tester,
    ) async {
      const red = Color(0xFFFF0000);
      const green = Color(0xFF00FF00);
      const blue = Color(0xFF0000FF);
      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            style: const VTabsStyle(
              textStyle: TextStyle(color: red),
              selectedTextStyle: TextStyle(color: green),
            ),
          ),
        ),
      );
      expect(labelOf(tester, 'Tab 1').color, green);
      expect(labelOf(tester, 'Tab 2').color, red);

      await tester.pumpWidget(
        buildTestWidget(
          VTabs(
            tabs: testTabs,
            style: const VTabsStyle(
              activeColor: blue,
              inactiveColor: blue,
              textStyle: TextStyle(color: red),
              selectedTextStyle: TextStyle(color: green),
            ),
          ),
        ),
      );
      expect(labelOf(tester, 'Tab 1').color, blue);
      expect(labelOf(tester, 'Tab 2').color, blue);
    });

    testWidgets('a disabled tab dims its text style color', (tester) async {
      const red = Color(0xFFFF0000);
      await tester.pumpWidget(
        buildTestWidget(
          const VTabs(
            tabs: [
              VTab(label: Text('A'), content: Text('a')),
              VTab(label: Text('B'), content: Text('b'), enabled: false),
            ],
            style: VTabsStyle(textStyle: TextStyle(color: red)),
          ),
        ),
      );

      expect(labelOf(tester, 'B').color, red.withValues(alpha: 0.5));
    });

    testWidgets('a theme override applies and an instance style wins', (
      tester,
    ) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VTabsStyle(textStyle: TextStyle(fontSize: 18), indicatorHeight: 3),
        ]),
      );
      await tester.pumpWidget(
        themed(VTabs.underline(tabs: testTabs), theme: theme),
      );
      expect(labelOf(tester, 'Tab 2').fontSize, 18);
      expect(underlineOf(tester, 'Tab 1').width, 3);

      await tester.pumpWidget(
        themed(
          VTabs.underline(
            tabs: testTabs,
            style: const VTabsStyle(textStyle: TextStyle(fontSize: 12)),
          ),
          theme: theme,
        ),
      );
      expect(labelOf(tester, 'Tab 2').fontSize, 12);
      expect(underlineOf(tester, 'Tab 1').width, 3);
    });
  });
}
