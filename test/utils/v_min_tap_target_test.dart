import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/src/utils/v_min_tap_target.dart';

import 'min_tap_helpers.dart';

void main() {
  group('VMinTapTarget', () {
    const childKey = Key('child');

    testWidgets('grows a small child to the minimum and keeps its size', (
      tester,
    ) async {
      await tester.pumpWidget(
        minTapApp(
          const VMinTapTarget(
            child: SizedBox(key: childKey, width: 10, height: 12),
          ),
        ),
      );
      expect(tester.getSize(find.byType(VMinTapTarget)), const Size(24, 24));
      expect(tester.getSize(find.byKey(childKey)), const Size(10, 12));
      expect(
        tester.getCenter(find.byKey(childKey)),
        tester.getCenter(find.byType(VMinTapTarget)),
      );
    });

    testWidgets('leaves a child that is already large alone', (tester) async {
      await tester.pumpWidget(
        minTapApp(
          const VMinTapTarget(
            child: SizedBox(key: childKey, width: 60, height: 40),
          ),
        ),
      );
      expect(tester.getSize(find.byType(VMinTapTarget)), const Size(60, 40));
    });

    testWidgets('a tap in the grown area reaches the child', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        minTapApp(
          VMinTapTarget(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps++,
              child: const SizedBox(key: childKey, width: 10, height: 10),
            ),
          ),
        ),
      );
      final box = tester.getTopLeft(find.byType(VMinTapTarget));
      await tester.tapAt(box + const Offset(1, 1));
      expect(taps, 1);
    });

    testWidgets('follows the theme value', (tester) async {
      const child = VMinTapTarget(child: SizedBox(width: 10, height: 10));
      await tester.pumpWidget(minTapApp(child, min: 48));
      expect(tester.getSize(find.byType(VMinTapTarget)), const Size(48, 48));
      await tester.pumpWidget(minTapApp(child, min: 32));
      expect(tester.getSize(find.byType(VMinTapTarget)), const Size(32, 32));
    });

    testWidgets('growLayout false keeps the box and still reaches the child', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        minTapApp(
          SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: VMinTapTarget(
                growLayout: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => taps++,
                  child: const SizedBox(width: 10, height: 10),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(VMinTapTarget)), const Size(10, 10));
      final c = tester.getCenter(find.byType(VMinTapTarget));
      await tester.tapAt(c + const Offset(-10, -10));
      expect(taps, 1);
    });
  });
}
