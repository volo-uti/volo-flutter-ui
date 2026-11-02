import 'dart:ui' show Color, PointerDeviceKind;

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VCard', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('default constructor', () {
      testWidgets('creates default card', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Card Content'))),
        );

        expect(find.byType(VCard), findsOneWidget);
        expect(find.text('Card Content'), findsOneWidget);
      });

      testWidgets('default card has background color and border', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Default Card'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.color, isNotNull);
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.border, isNull);
      });
    });

    group('VCard.outlined variant', () {
      testWidgets('creates outlined card', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard.outlined(child: Text('Outlined'))),
        );

        expect(find.byType(VCard), findsOneWidget);
        expect(find.text('Outlined'), findsOneWidget);
      });

      testWidgets('outlined card has transparent background and border only', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard.outlined(child: Text('Outlined Card'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        // Transparent background (Color(0x00000000))
        expect(decoration.color, const Color(0x00000000));
        expect(decoration.border, isNotNull);
        expect(decoration.boxShadow, isNull);
      });

      testWidgets('applies onTap to outlined card', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCard.outlined(
              onTap: () => tapped = true,
              child: const Text('Tappable Outlined'),
            ),
          ),
        );

        await tester.tap(find.byType(VCard));
        expect(tapped, isTrue);
      });

      testWidgets('applies custom borderRadius to outlined card', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard.outlined(
              borderRadius: BorderRadius.circular(20),
              child: const Text('Rounded Outlined'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(20));
      });
    });

    group('VCard.elevated variant', () {
      testWidgets('creates elevated card', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard.elevated(child: Text('Shadow'))),
        );

        expect(find.byType(VCard), findsOneWidget);
        expect(find.text('Shadow'), findsOneWidget);
      });

      testWidgets('elevated card has shadow', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard.elevated(child: Text('Shadow Card'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.color, isNotNull);
        expect(decoration.border, isNull);
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, 1);
      });

      testWidgets('applies onTap to elevated card', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCard.elevated(
              onTap: () => tapped = true,
              child: const Text('Tappable Elevated'),
            ),
          ),
        );

        await tester.tap(find.byType(VCard));
        expect(tapped, isTrue);
      });

      testWidgets('applies custom padding to elevated card', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCard.elevated(
              padding: EdgeInsets.all(24),
              child: Text('Padding Applied'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.padding, const EdgeInsets.all(24));
      });
    });

    group('onTap callback', () {
      testWidgets('calls onTap callback', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCard(onTap: () => tapped = true, child: const Text('Tap')),
          ),
        );

        await tester.tap(find.byType(VCard));
        expect(tapped, isTrue);
      });

      testWidgets('no GestureDetector when onTap is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Not Tappable'))),
        );

        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('has GestureDetector when onTap is set', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCard(onTap: () {}, child: const Text('Tappable'))),
        );

        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('changes pressed state on tap down', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCard(onTap: () {}, child: const Text('Tap'))),
        );

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(VCard)),
        );
        await tester.pump();

        // Tap up
        await gesture.up();
        await tester.pump();

        expect(find.byType(VCard), findsOneWidget);
      });
    });

    group('onLongPress callback', () {
      testWidgets('calls onLongPress callback', (tester) async {
        var longPressed = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCard(
              onLongPress: () => longPressed = true,
              child: const Text('Long Press'),
            ),
          ),
        );

        await tester.longPress(find.byType(VCard));
        expect(longPressed, isTrue);
      });

      testWidgets('has GestureDetector when only onLongPress is set', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard(onLongPress: () {}, child: const Text('Long Press Only')),
          ),
        );

        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('onTap and onLongPress set simultaneously', (tester) async {
        var tapped = false;
        var longPressed = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCard(
              onTap: () => tapped = true,
              onLongPress: () => longPressed = true,
              child: const Text('Tap and Long Press'),
            ),
          ),
        );

        // Tap
        await tester.tap(find.byType(VCard));
        expect(tapped, isTrue);
        expect(longPressed, isFalse);

        // Long press
        await tester.longPress(find.byType(VCard));
        expect(longPressed, isTrue);
      });
    });

    group('padding customization', () {
      testWidgets('default padding is EdgeInsets.all(16)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Default Padding'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.padding, const EdgeInsets.all(16));
      });

      testWidgets('applies custom padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCard(
              padding: EdgeInsets.all(32),
              child: Text('Custom Padding'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.padding, const EdgeInsets.all(32));
      });

      testWidgets('applies asymmetric padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCard(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text('Asymmetric Padding'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(
          animatedContainer.padding,
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        );
      });

      testWidgets('no padding (EdgeInsets.zero)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCard(padding: EdgeInsets.zero, child: Text('No Padding')),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.padding, EdgeInsets.zero);
      });
    });

    group('borderRadius customization', () {
      testWidgets('default borderRadius is 12', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Default Radius'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(12));
      });

      testWidgets('applies custom borderRadius', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard(
              borderRadius: BorderRadius.circular(24),
              child: const Text('Rounded Corner'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.borderRadius, BorderRadius.circular(24));
      });

      testWidgets('applies different radius per corner', (tester) async {
        const customRadius = BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(2),
        );

        await tester.pumpWidget(
          buildTestWidget(
            const VCard(
              borderRadius: customRadius,
              child: Text('Different Corners'),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;

        expect(decoration.borderRadius, customRadius);
      });
    });

    group('Semantics accessibility', () {
      testWidgets('non-tappable card has container semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Container'))),
        );

        final semantics = tester.getSemantics(find.byType(VCard));
        expect(semantics.getSemanticsData().flagsCollection.isButton, isFalse);
      });

      testWidgets('tappable card has button semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCard(onTap: () {}, child: const Text('Button'))),
        );

        final semantics = tester.getSemantics(find.byType(VCard));
        expect(semantics.getSemanticsData().flagsCollection.isButton, isTrue);
      });

      testWidgets('button semantics even with only onLongPress', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard(onLongPress: () {}, child: const Text('Long Press Button')),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VCard));
        expect(semantics.getSemanticsData().flagsCollection.isButton, isTrue);
      });
    });

    group('hover state', () {
      testWidgets('tappable card has MouseRegion', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCard(onTap: () {}, child: const Text('Hover'))),
        );

        expect(find.byType(MouseRegion), findsOneWidget);
      });

      testWidgets('non-tappable card has no MouseRegion', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('No Hover'))),
        );

        expect(find.byType(MouseRegion), findsNothing);
      });

      testWidgets('elevated card shadow changes on hover enter', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard.elevated(onTap: () {}, child: const Text('Hover Shadow')),
          ),
        );

        // Check initial shadow
        var animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        var decoration = animatedContainer.decoration as BoxDecoration;
        final initialBlurRadius = decoration.boxShadow!.first.blurRadius;

        // Hover enter
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(tester.getCenter(find.byType(VCard)));
        await tester.pump();

        // Check shadow in hover state
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final hoveredBlurRadius = decoration.boxShadow!.first.blurRadius;

        expect(hoveredBlurRadius, greaterThan(initialBlurRadius));

        // Hover exit
        await gesture.moveTo(const Offset(1000, 1000));
        await tester.pump();

        // Restore original state
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final exitedBlurRadius = decoration.boxShadow!.first.blurRadius;

        expect(exitedBlurRadius, initialBlurRadius);

        await gesture.removePointer();
      });
    });

    group('pressed state', () {
      testWidgets('filled card background color changes on tap down', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard(onTap: () {}, child: const Text('filled pressed')),
          ),
        );

        // Initial background color
        var animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        var decoration = animatedContainer.decoration as BoxDecoration;
        final initialColor = decoration.color;

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(VCard)),
        );
        await tester.pump();

        // Pressed state background color
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final pressedColor = decoration.color;

        expect(pressedColor, isNot(equals(initialColor)));

        await gesture.up();
      });

      testWidgets('outlined card background color changes on tap down', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard.outlined(onTap: () {}, child: const Text('outlined pressed')),
          ),
        );

        // Initial background color (transparent)
        var animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        var decoration = animatedContainer.decoration as BoxDecoration;
        final initialColor = decoration.color;
        expect(initialColor, const Color(0x00000000));

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(VCard)),
        );
        await tester.pump();

        // Pressed state background color
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final pressedColor = decoration.color;

        expect(pressedColor, isNot(equals(initialColor)));
        expect(pressedColor!.a, greaterThan(0));

        await gesture.up();
      });

      testWidgets('elevated card background color changes on tap down', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCard.elevated(onTap: () {}, child: const Text('elevated pressed')),
          ),
        );

        // Initial background color
        var animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        var decoration = animatedContainer.decoration as BoxDecoration;
        final initialColor = decoration.color;

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(VCard)),
        );
        await tester.pump();

        // Pressed state background color
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final pressedColor = decoration.color;

        expect(pressedColor, isNot(equals(initialColor)));

        await gesture.up();
      });

      testWidgets('pressed state restores on tap cancel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCard(onTap: () {}, child: const Text('Tap Cancel'))),
        );

        // Initial background color
        var animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        var decoration = animatedContainer.decoration as BoxDecoration;
        final initialColor = decoration.color;

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(VCard)),
        );
        await tester.pump();

        // Tap cancel (drag out)
        await gesture.moveTo(const Offset(1000, 1000));
        await gesture.cancel();
        await tester.pump();

        // Restore original state
        animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        decoration = animatedContainer.decoration as BoxDecoration;
        final restoredColor = decoration.color;

        expect(restoredColor, initialColor);
      });
    });

    group('AnimatedContainer properties', () {
      testWidgets('animation duration is 150ms', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Animation'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.duration, const Duration(milliseconds: 150));
      });

      testWidgets('animation curve is easeOut', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCard(child: Text('Curve'))),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.curve, Curves.easeOut);
      });
    });

    group('theme application', () {
      testWidgets('applies different theme data (dark)', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.dark(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VCard(child: Text('Dark Theme')),
            ),
          ),
        );

        expect(find.byType(VCard), findsOneWidget);
        expect(find.text('Dark Theme'), findsOneWidget);
      });

      testWidgets('applies zinc theme', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VCard(child: Text('Zinc Theme')),
            ),
          ),
        );

        expect(find.byType(VCard), findsOneWidget);
      });
    });
  });

  group('VCardHeader', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('title functionality', () {
      testWidgets('displays String title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardHeader(title: Text('Card Title'))),
        );

        expect(find.text('Card Title'), findsOneWidget);
      });

      testWidgets('displays Widget title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Row(children: [Text('Widget'), Text(' '), Text('Title')]),
            ),
          ),
        );

        expect(find.text('Widget'), findsOneWidget);
        expect(find.text('Title'), findsOneWidget);
      });
    });

    group('description functionality', () {
      testWidgets('displays String description', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              description: Text('Description Text'),
            ),
          ),
        );

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description Text'), findsOneWidget);
      });

      testWidgets('displays Widget description', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              description: Row(
                children: [Text('Widget'), Text(' '), Text('Description')],
              ),
            ),
          ),
        );

        expect(find.text('Widget'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('does not display when description is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardHeader(title: Text('Title Only'))),
        );

        expect(find.text('Title Only'), findsOneWidget);
        // Column has only 1 child
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.children.length, 1);
      });
    });

    group('action functionality', () {
      testWidgets('displays action widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              action: Icon(Icons.more_vert),
            ),
          ),
        );

        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('does not display when action is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardHeader(title: Text('Title'))),
        );

        expect(find.byType(Icon), findsNothing);
      });

      testWidgets('action is tappable', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCardHeader(
              title: const Text('Title'),
              action: GestureDetector(
                onTap: () => tapped = true,
                child: const Text('Action'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Action'));
        expect(tapped, isTrue);
      });
    });

    group('layout', () {
      testWidgets('uses Row layout', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(title: Text('Title'), action: Text('Action')),
          ),
        );

        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('bottom padding 16px', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardHeader(title: Text('Title'))),
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, const EdgeInsets.only(bottom: 16));
      });

      testWidgets('Row crossAxisAlignment is start', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              description: Text('Description'),
              action: Text('Action'),
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('title/description area is Expanded', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(title: Text('Title'), action: Text('Action')),
          ),
        );

        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('description top padding 4px', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              description: Text('Description'),
            ),
          ),
        );

        // Find Padding inside Column
        final column = tester.widget<Column>(find.byType(Column).first);
        expect(column.children.length, 2);

        // Second child is Padding
        final descriptionPadding = column.children[1] as Padding;
        expect(descriptionPadding.padding, const EdgeInsets.only(top: 4));
      });
    });

    group('theme application', () {
      testWidgets('applies theme typography', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardHeader(
              title: Text('Title'),
              description: Text('Description'),
            ),
          ),
        );

        // Text widgets are rendered
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('works with different themes', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.dark(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VCardHeader(
                title: Text('Dark Theme Header'),
                description: Text('Description'),
              ),
            ),
          ),
        );

        expect(find.text('Dark Theme Header'), findsOneWidget);
      });
    });

    testWidgets('styles a plain Text title with the card heading style', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const VCardHeader(title: Text('Heading'))),
      );

      final style = tester.widget<Text>(find.text('Heading'));
      expect(style.style, isNull);
      final merged = DefaultTextStyle.of(tester.element(find.text('Heading')));
      expect(
        merged.style.fontSize,
        VThemeData.light().typography.titleMedium.fontSize,
      );
    });
  });

  group('VCardFooter', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('children functionality', () {
      testWidgets('single button', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardFooter(children: [Text('Confirm')])),
        );

        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('multiple buttons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(children: [Text('Cancel'), Text('Confirm')]),
          ),
        );

        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('8px spacing between buttons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(children: [Text('Cancel'), Text('Confirm')]),
          ),
        );

        // SizedBox(width: 8) exists between buttons
        expect(find.byType(SizedBox), findsOneWidget);
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, 8);
      });
    });

    group('alignment functionality', () {
      testWidgets('default alignment is end (right)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardFooter(children: [Text('Button')])),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.end);
      });

      testWidgets('start alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              alignment: MainAxisAlignment.start,
              children: [Text('Button')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.start);
      });

      testWidgets('center alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              alignment: MainAxisAlignment.center,
              children: [Text('Button')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('spaceBetween alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              alignment: MainAxisAlignment.spaceBetween,
              children: [Text('Left'), Text('Right')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });
    });

    group('layout', () {
      testWidgets('top padding 16px', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCardFooter(children: [Text('Button')])),
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        expect(padding.padding, const EdgeInsets.only(top: 16));
      });

      testWidgets('2 spacers for 3 buttons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              children: [Text('First'), Text('Second'), Text('Third')],
            ),
          ),
        );

        // Should have 2 SizedBoxes (between buttons)
        expect(find.byType(SizedBox), findsNWidgets(2));
      });

      testWidgets('3 spacers for 4 buttons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              children: [Text('1'), Text('2'), Text('3'), Text('4')],
            ),
          ),
        );

        expect(find.byType(SizedBox), findsNWidgets(3));
      });
    });

    group('various alignments', () {
      testWidgets('spaceAround alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              alignment: MainAxisAlignment.spaceAround,
              children: [Text('Left'), Text('Right')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.spaceAround);
      });

      testWidgets('spaceEvenly alignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCardFooter(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [Text('Left'), Text('Right')],
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
      });
    });
  });

  group('VCard integration tests', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('VCard + VCardHeader + VCardFooter combination', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(
                  title: Text('Card Title'),
                  description: Text('This is a card description.'),
                ),
                Text('Body Content'),
                VCardFooter(children: [Text('Cancel'), Text('Confirm')]),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VCard), findsOneWidget);
      expect(find.byType(VCardHeader), findsOneWidget);
      expect(find.byType(VCardFooter), findsOneWidget);
      expect(find.text('Card Title'), findsOneWidget);
      expect(find.text('This is a card description.'), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('tappable card + VCardHeader + action', (tester) async {
      var cardTapped = false;
      var actionTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VCard(
            onTap: () => cardTapped = true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(
                  title: const Text('Title'),
                  action: GestureDetector(
                    onTap: () => actionTapped = true,
                    child: const Text('Action'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap action
      await tester.tap(find.text('Action'));
      expect(actionTapped, isTrue);
      expect(cardTapped, isFalse);
    });

    testWidgets('VCardHeader/VCardFooter works in all variants', (
      tester,
    ) async {
      for (final variant in ['filled', 'outlined', 'elevated']) {
        Widget card;
        switch (variant) {
          case 'outlined':
            card = const VCard.outlined(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VCardHeader(title: Text('Title')),
                  VCardFooter(children: [Text('Button')]),
                ],
              ),
            );
            break;
          case 'elevated':
            card = const VCard.elevated(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VCardHeader(title: Text('Title')),
                  VCardFooter(children: [Text('Button')]),
                ],
              ),
            );
            break;
          default:
            card = const VCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VCardHeader(title: Text('Title')),
                  VCardFooter(children: [Text('Button')]),
                ],
              ),
            );
        }

        await tester.pumpWidget(buildTestWidget(card));

        expect(find.byType(VCard), findsOneWidget);
        expect(find.byType(VCardHeader), findsOneWidget);
        expect(find.byType(VCardFooter), findsOneWidget);
      }
    });

    testWidgets('renders nested VCard', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(title: Text('Outer Card')),
                VCard.outlined(child: VCardHeader(title: Text('Inner Card'))),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VCard), findsNWidgets(2));
      expect(find.text('Outer Card'), findsOneWidget);
      expect(find.text('Inner Card'), findsOneWidget);
    });

    testWidgets('VCard.elevated + long press + custom properties combination', (
      tester,
    ) async {
      var longPressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          VCard.elevated(
            padding: const EdgeInsets.all(24),
            borderRadius: BorderRadius.circular(20),
            onLongPress: () => longPressed = true,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(
                  title: Text('Custom Card'),
                  description: Text('All Properties Combined'),
                ),
                VCardFooter(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Left'), Text('Right')],
                ),
              ],
            ),
          ),
        ),
      );

      // Verify properties
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainer.padding, const EdgeInsets.all(24));

      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect(decoration.boxShadow, isNotNull);

      // Long press action
      await tester.longPress(find.byType(VCard).first);
      expect(longPressed, isTrue);
    });

    testWidgets('empty VCardFooter children list', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(title: Text('Title')),
                VCardFooter(children: []),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VCardFooter), findsOneWidget);
      // Should have no SizedBox spacing
      final row = tester.widget<Row>(find.byType(Row).last);
      expect(row.children.length, 0);
    });

    testWidgets('both VCardHeader action and footer button are tappable', (
      tester,
    ) async {
      var actionTapped = false;
      var footerTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(
                  title: const Text('Title'),
                  action: GestureDetector(
                    onTap: () => actionTapped = true,
                    child: const Text('Header Action'),
                  ),
                ),
                VCardFooter(
                  children: [
                    GestureDetector(
                      onTap: () => footerTapped = true,
                      child: const Text('Footer Button'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Header Action'));
      expect(actionTapped, isTrue);

      await tester.tap(find.text('Footer Button'));
      expect(footerTapped, isTrue);
    });

    testWidgets('Widget title and Widget description combination', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCard(
            child: VCardHeader(
              title: Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 8),
                  Text('Icon Title'),
                ],
              ),
              description: Row(
                children: [Text('Subtitle '), Text('Description')],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Icon Title'), findsOneWidget);
      expect(find.text('Subtitle '), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to card', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VCardStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VCard(child: Text('Card Content')),
          ),
        ),
      );

      expect(find.byType(VCard), findsOneWidget);
    });
  });

  group('keyboard activation', () {
    testWidgets('Enter and Space press a focused card', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VCard(onTap: () => taps++, child: const Text('Body')),
            ),
          ),
        ),
      );
      Focus.of(tester.element(find.text('Body'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);

      expect(taps, 2);
    });
  });

  group('VCard style fields', () {
    final theme = VThemeData.light();
    const shadow = BoxShadow(blurRadius: 3);

    // Applies [style] through the theme or as the instance style.
    Widget styled(
      VCardStyle style, {
      required bool viaTheme,
      bool outlined = false,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: outlined
              ? VCard.outlined(
                  onTap: () {},
                  style: viaTheme ? null : style,
                  child: const Text('Body'),
                )
              : VCard(
                  onTap: () {},
                  style: viaTheme ? null : style,
                  child: const Text('Body'),
                ),
        ),
      ),
    );

    List<BoxShadow>? shadowsOf(WidgetTester tester) =>
        (tester
                    .widget<AnimatedContainer>(
                      find.descendant(
                        of: find.byType(VCard),
                        matching: find.byType(AnimatedContainer),
                      ),
                    )
                    .decoration!
                as BoxDecoration)
            .boxShadow;

    Future<void> hover(WidgetTester tester) async {
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(VCard)));
      await tester.pump();
    }

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('shadows replace the resting and hover shadow ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(const VCardStyle(shadows: [shadow]), viaTheme: viaTheme),
        );
        expect(shadowsOf(tester), [shadow]);

        await hover(tester);
        expect(shadowsOf(tester), [shadow]);
      });

      testWidgets('an outlined card ignores shadows ($via)', (tester) async {
        await tester.pumpWidget(
          styled(
            const VCardStyle(shadows: [shadow]),
            viaTheme: viaTheme,
            outlined: true,
          ),
        );
        expect(shadowsOf(tester), isNull);
      });
    }

    testWidgets('an empty shadow list draws no shadow', (tester) async {
      await tester.pumpWidget(
        styled(const VCardStyle(shadows: []), viaTheme: false),
      );
      expect(shadowsOf(tester), isEmpty);
    });

    testWidgets('defaults to the medium shadow and the large one on hover', (
      tester,
    ) async {
      await tester.pumpWidget(styled(const VCardStyle(), viaTheme: false));
      expect(shadowsOf(tester), theme.shadows.md);

      await hover(tester);
      expect(shadowsOf(tester), theme.shadows.lg);
    });
  });

  group('VCard foregroundColor', () {
    final theme = VThemeData.light();
    const color = Color(0xFF123456);

    // Builds a card styled through the theme or as the instance style.
    Widget styled(VCardStyle? style, {bool viaTheme = false}) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: VCard(
            style: viaTheme ? null : style,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VCardHeader(title: Text('Title')),
                Text('Body'),
                Icon(Icons.star),
              ],
            ),
          ),
        ),
      ),
    );

    Color? textColor(WidgetTester tester, String text) => tester
        .widget<RichText>(
          find.descendant(of: find.text(text), matching: find.byType(RichText)),
        )
        .text
        .style
        ?.color;

    Color? iconColor(WidgetTester tester) =>
        IconTheme.of(tester.element(find.byType(Icon))).color;

    testWidgets('text keeps its inherited color by default', (tester) async {
      await tester.pumpWidget(styled(null));
      expect(textColor(tester, 'Title'), theme.colors.foreground);
      expect(textColor(tester, 'Body'), isNot(color));
      expect(iconColor(tester), isNot(color));
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('colors the body, icons and header title ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(const VCardStyle(foregroundColor: color), viaTheme: viaTheme),
        );
        expect(textColor(tester, 'Title'), color);
        expect(textColor(tester, 'Body'), color);
        expect(iconColor(tester), color);
      });
    }
  });
}
