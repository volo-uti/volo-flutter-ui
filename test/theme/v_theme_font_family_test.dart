import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

VThemeData _themeWith(String? family) => VThemeData.light().copyWith(
  typography: VThemeData.light().typography.copyWith(fontFamily: family),
);

String? _family(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph.text.style?.fontFamily;
}

Widget _wrap(VThemeData theme, Widget child) => VTheme(
  data: theme,
  child: Directionality(textDirection: TextDirection.ltr, child: child),
);

void main() {
  group('theme font', () {
    testWidgets('reaches a Text that names no family', (tester) async {
      await tester.pumpWidget(_wrap(_themeWith('TestFont'), const Text('x')));
      expect(_family(tester, 'x'), 'TestFont');
    });

    testWidgets('reaches a library widget', (tester) async {
      await tester.pumpWidget(
        _wrap(_themeWith('TestFont'), const VBadge(label: Text('badge'))),
      );
      expect(_family(tester, 'badge'), 'TestFont');
    });

    testWidgets('reaches a widget that resets the default text style', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _themeWith('TestFont'),
          VButton(onPressed: () {}, child: const Text('save')),
        ),
      );
      expect(_family(tester, 'save'), 'TestFont');
    });

    testWidgets('reaches the text styles of the typography', (tester) async {
      final typography = _themeWith('TestFont').typography;
      expect(typography.bodyMedium.fontFamily, 'TestFont');
      expect(typography.labelSmall.fontFamily, 'TestFont');
    });

    testWidgets('reaches a Text under VApp', (tester) async {
      await tester.pumpWidget(
        VApp(theme: _themeWith('TestFont'), home: const Text('home')),
      );
      expect(_family(tester, 'home'), 'TestFont');
    });

    testWidgets('keeps a family the text names itself', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _themeWith('TestFont'),
          const Text('x', style: TextStyle(fontFamily: 'OtherFont')),
        ),
      );
      expect(_family(tester, 'x'), 'OtherFont');
    });

    testWidgets('draws no family when the theme has none', (tester) async {
      await tester.pumpWidget(_wrap(_themeWith(null), const Text('x')));
      expect(_family(tester, 'x'), isNull);
      expect(_themeWith(null).typography.bodyMedium.fontFamily, isNull);
    });

    testWidgets('leaves the monospace family alone', (tester) async {
      final typography = VThemeData.light().typography.copyWith(
        fontFamilyMono: 'MonoFont',
      );
      expect(typography.fontFamilyMono, 'MonoFont');
      expect(typography.bodyMedium.fontFamily, isNull);
    });

    testWidgets('follows a change of the family', (tester) async {
      await tester.pumpWidget(_wrap(_themeWith('A'), const Text('x')));
      expect(_family(tester, 'x'), 'A');
      await tester.pumpWidget(_wrap(_themeWith('B'), const Text('x')));
      expect(_family(tester, 'x'), 'B');
    });
  });
}
