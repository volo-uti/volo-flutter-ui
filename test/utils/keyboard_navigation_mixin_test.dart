import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

// ---------------------------------------------------------------------------
// Test harness widget that uses KeyboardNavigationMixin.
// ---------------------------------------------------------------------------

class _TestList extends StatefulWidget {
  const _TestList({
    required this.itemCount,
    this.disabledIndices = const {},
    this.axis = Axis.vertical,
    this.wrapAround = true,
  });

  final int itemCount;
  final Set<int> disabledIndices;
  final Axis axis;
  final bool wrapAround;

  @override
  State<_TestList> createState() => _TestListState();
}

class _TestListState extends State<_TestList>
    with KeyboardNavigationMixin<_TestList> {
  int? lastActivated;

  @override
  int get itemCount => widget.itemCount;

  @override
  bool isItemEnabled(int index) => !widget.disabledIndices.contains(index);

  @override
  Axis get navigationAxis => widget.axis;

  @override
  bool get wrapAround => widget.wrapAround;

  @override
  void onItemActivated(int index) {
    setState(() => lastActivated = index);
  }

  bool escapeCalled = false;

  @override
  void onEscapePressed() {
    setState(() => escapeCalled = true);
  }

  @override
  Widget build(BuildContext context) => Focus(
    onKeyEvent: handleKeyEvent,
    autofocus: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('focused: $focusedIndex'),
        Text('activated: $lastActivated'),
        Text('escape: $escapeCalled'),
      ],
    ),
  );
}

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  Future<void> sendKey(WidgetTester tester, LogicalKeyboardKey key) async {
    await tester.sendKeyDownEvent(key);
    await tester.sendKeyUpEvent(key);
    await tester.pump();
  }

  group('KeyboardNavigationMixin', () {
    group('focusNext', () {
      testWidgets('moves to next item', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 5)));

        await sendKey(tester, LogicalKeyboardKey.arrowDown);
        expect(find.text('focused: 0'), findsOneWidget);

        await sendKey(tester, LogicalKeyboardKey.arrowDown);
        expect(find.text('focused: 1'), findsOneWidget);
      });

      testWidgets('wraps around when wrapAround is true', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 3)));

        // Move to last item
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 1
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 2
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // wraps to 0
        expect(find.text('focused: 0'), findsOneWidget);
      });

      testWidgets('does not wrap when wrapAround is false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 3, wrapAround: false)),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 1
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 2
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // stays at 2
        expect(find.text('focused: 2'), findsOneWidget);
      });

      testWidgets('skips disabled items', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const _TestList(itemCount: 5, disabledIndices: {1, 2}),
          ),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // skips 1,2 -> 3
        expect(find.text('focused: 3'), findsOneWidget);
      });
    });

    group('focusPrevious', () {
      testWidgets('moves to previous item', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 5)));

        // Navigate forward first
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 1
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 2

        await sendKey(tester, LogicalKeyboardKey.arrowUp); // 1
        expect(find.text('focused: 1'), findsOneWidget);
      });

      testWidgets('wraps around when wrapAround is true', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 3)));

        // From -1, focusPrevious with wrapAround should go to last enabled.
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowUp); // wraps to 2
        expect(find.text('focused: 2'), findsOneWidget);
      });
    });

    group('focusPrevious from nothing focused', () {
      testWidgets('first ArrowUp lands on the last item (wrap)', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 5)));

        await sendKey(tester, LogicalKeyboardKey.arrowUp);
        expect(find.text('focused: 4'), findsOneWidget);
      });

      testWidgets('first ArrowUp lands on the last item (no wrap)', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 5, wrapAround: false)),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowUp);
        expect(find.text('focused: 4'), findsOneWidget);
      });

      testWidgets('first ArrowUp skips a disabled last item', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 5, disabledIndices: {4})),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowUp);
        expect(find.text('focused: 3'), findsOneWidget);
      });
    });

    group('focusFirst / focusLast', () {
      testWidgets('Home key focuses first enabled item', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 5, disabledIndices: {0})),
        );

        await sendKey(tester, LogicalKeyboardKey.home);
        expect(find.text('focused: 1'), findsOneWidget);
      });

      testWidgets('End key focuses last enabled item', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 5, disabledIndices: {4})),
        );

        await sendKey(tester, LogicalKeyboardKey.end);
        expect(find.text('focused: 3'), findsOneWidget);
      });
    });

    group('activation', () {
      testWidgets('Enter activates focused item', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 3)));

        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 1
        await sendKey(tester, LogicalKeyboardKey.enter);
        expect(find.text('activated: 1'), findsOneWidget);
      });

      testWidgets('Space activates focused item', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 3)));

        await sendKey(tester, LogicalKeyboardKey.arrowDown); // 0
        await sendKey(tester, LogicalKeyboardKey.space);
        expect(find.text('activated: 0'), findsOneWidget);
      });
    });

    group('escape', () {
      testWidgets('Escape calls onEscapePressed', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 3)));

        await sendKey(tester, LogicalKeyboardKey.escape);
        expect(find.text('escape: true'), findsOneWidget);
      });
    });

    group('horizontal axis', () {
      testWidgets('uses ArrowRight/Left for horizontal', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 3, axis: Axis.horizontal)),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowRight); // 0
        expect(find.text('focused: 0'), findsOneWidget);

        await sendKey(tester, LogicalKeyboardKey.arrowRight); // 1
        expect(find.text('focused: 1'), findsOneWidget);

        await sendKey(tester, LogicalKeyboardKey.arrowLeft); // 0
        expect(find.text('focused: 0'), findsOneWidget);
      });

      testWidgets('ArrowDown/Up ignored in horizontal mode', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const _TestList(itemCount: 3, axis: Axis.horizontal)),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowDown);
        // focusedIndex should remain -1 (the ArrowDown is ignored)
        expect(find.text('focused: -1'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('empty list does nothing', (tester) async {
        await tester.pumpWidget(buildTestWidget(const _TestList(itemCount: 0)));

        await sendKey(tester, LogicalKeyboardKey.arrowDown);
        expect(find.text('focused: -1'), findsOneWidget);
      });

      testWidgets('all disabled items does nothing', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const _TestList(itemCount: 3, disabledIndices: {0, 1, 2}),
          ),
        );

        await sendKey(tester, LogicalKeyboardKey.arrowDown);
        // Should stay at initial -1 since no item is enabled.
        expect(find.text('focused: -1'), findsOneWidget);
      });
    });
  });
}
