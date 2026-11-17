import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

/// Wraps [child] in a theme with the given `minTapTargetSize`.
Widget minTapApp(Widget child, {double min = 24}) => VTheme(
  data: VThemeData.light().copyWith(minTapTargetSize: min),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

/// Pumps [child] at the default minimum and at 48, then checks that the
/// semantics rectangle of [tap] is at least the minimum on both axes and that
/// the [drawn] widget keeps the size it has at the default minimum.
Future<void> expectMinTapTarget(
  WidgetTester tester,
  Widget child, {
  required Finder tap,
  required Finder drawn,
}) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(minTapApp(child));
  final drawnAt24 = tester.getSize(drawn.first);
  final semAt24 = tester.getSemantics(tap.first).rect.size;
  expect(semAt24.width, greaterThanOrEqualTo(24));
  expect(semAt24.height, greaterThanOrEqualTo(24));

  await tester.pumpWidget(minTapApp(child, min: 48));
  await tester.pump();
  final semAt48 = tester.getSemantics(tap.first).rect.size;
  expect(semAt48.width, greaterThanOrEqualTo(48));
  expect(semAt48.height, greaterThanOrEqualTo(48));
  expect(tester.getSize(drawn.first), drawnAt24);
  handle.dispose();
}
