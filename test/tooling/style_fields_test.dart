import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/src/tooling/dart_source.dart';
import 'package:volo_flutter_ui/src/tooling/style_fields.dart';

const _style = '''
import 'package:flutter/widgets.dart';

/// Style override for [VXChip].
@immutable
class VXChipStyle implements VComponentStyle {
  const VXChipStyle({this.padding, this.spacing, this.gap});

  static const VXChipStyle none = VXChipStyle();

  /// Inner padding.
  final EdgeInsets? padding;

  /// Space between rows.
  final double? spacing;

  /// Space between the icon and the label.
  final double?
      gap;

  /// Merges [other] on top of this style.
  @override
  VXChipStyle merge(VXChipStyle? other) {
    if (other == null) return this;
    return VXChipStyle(
      padding: other.padding ?? padding,
      spacing: other.spacing ?? spacing,
      gap: other.gap ?? gap,
    );
  }

  @override
  int get hashCode => Object.hash(padding, spacing, gap);
}
''';

/// A widget file that reads its style the way the library widgets do.
String _widget(String build) =>
    '''
class VXChip extends StatelessWidget {
  const VXChip({super.key, this.style});

  final VXChipStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final themeStyle = theme.componentOverrides.get<VXChipStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
$build
  }
}
''';

List<String> _unread(List<String> siblings, {Map<String, String>? elsewhere}) =>
    unreadStyleFields(
      'v_x_chip_style.dart',
      _style,
      siblings,
      readElsewhere: elsewhere ?? const {},
    );

void main() {
  group('blankCommentsAndStrings', () {
    test('keeps offsets and line breaks', () {
      const source = "a; // b\n/* c\n d */ e('f // g', \"h\");";
      final blank = blankCommentsAndStrings(source);
      expect(blank.length, source.length);
      expect(blank.split('\n').length, source.split('\n').length);
      expect(blank, isNot(contains('b')));
      expect(blank, isNot(contains('c')));
      expect(blank, isNot(contains('g')));
      expect(blank, contains('e('));
    });

    test('keeps interpolated code and skips raw and nested forms', () {
      final blank = blankCommentsAndStrings(
        r"x('a ${s.padding} b'); r'\' y; /* 1 /* 2 */ 3 */ z; '''t''' w;",
      );
      expect(blank, contains('s.padding'));
      expect(blank, contains(' y;'));
      expect(blank, contains(' z;'));
      expect(blank, contains(' w;'));
      expect(blank, isNot(contains('3')));
      expect(blank, isNot(contains('t')));
    });

    test('lineOf counts from 1', () {
      expect(lineOf('a\nb\nc', 0), 1);
      expect(lineOf('a\nb\nc', 4), 3);
    });
  });

  group('styleFieldsOf', () {
    test('lists instance fields of style classes with their lines', () {
      final fields = styleFieldsOf(_style);
      expect(fields.map((f) => f.id), [
        'VXChipStyle.padding',
        'VXChipStyle.spacing',
        'VXChipStyle.gap',
      ]);
      expect(fields.map((f) => f.line), [11, 14, 18]);
    });

    test('skips static fields, getters and classes not named ...Style', () {
      final fields = styleFieldsOf('''
class VXChipVariants {
  final Color? color;
}
class VXStyle {
  static final VXStyle none = VXStyle();
  Color? get color => null;
  final Color? border;
}
''');
      expect(fields.map((f) => f.id), ['VXStyle.border']);
    });
  });

  group('unreadStyleFields', () {
    test('passes when every field is read from the resolved style', () {
      final found = _unread([
        _widget('''
    final padding = resolvedStyle?.padding ?? EdgeInsets.zero;
    final spacing = resolvedStyle?.spacing ?? theme.spacing.sm;
    return Gap(resolvedStyle!.gap);'''),
      ]);
      expect(found, isEmpty);
    });

    test('names the file, line and field that is never read', () {
      final found = _unread([
        _widget('    return Padding(padding: resolvedStyle?.padding);'),
      ]);
      expect(found, [
        'v_x_chip_style.dart:14 VXChipStyle.spacing',
        'v_x_chip_style.dart:18 VXChipStyle.gap',
      ]);
    });

    test('does not count a token or another object with the same name', () {
      final found = _unread([
        _widget('''
    final sizes = theme.sizes.md;
    final spacing = theme.spacing.sm;
    final text = DefaultTextStyle.of(context).style.gap;
    return Padding(padding: sizes.padding);'''),
      ]);
      expect(found, hasLength(3));
    });

    test('does not count a value taken out of the style', () {
      final found = _unread([
        _widget('''
    final padding = resolvedStyle?.padding ?? EdgeInsets.zero;
    return Text('', style: padding.spacing, gap: padding.gap);'''),
      ]);
      expect(found, [
        'v_x_chip_style.dart:14 VXChipStyle.spacing',
        'v_x_chip_style.dart:18 VXChipStyle.gap',
      ]);
    });

    test('does not count a mention in a comment or a string', () {
      final found = _unread([
        _widget('''
    // resolvedStyle?.spacing is not wired yet.
    final label = 'resolvedStyle?.gap';
    return Padding(padding: resolvedStyle?.padding);'''),
      ]);
      expect(found, hasLength(2));
    });

    test('follows widget.style into a State in another file', () {
      const state = '''
class _VXChipState extends State<VXChip> {
  @override
  Widget build(BuildContext context) {
    final s = widget.style ?? const VXChipStyle();
    return Row(
      spacing: s.spacing,
      children: [Gap(widget.style?.gap), Padding(padding: s.padding)],
    );
  }
}
''';
      const owner = '''
class VXChip extends StatefulWidget {
  final VXChipStyle? style;
}
''';
      expect(_unread([owner, state]), isEmpty);
    });

    test('counts a read straight off the theme override', () {
      final found = _unread([
        _widget(
          '''
    final gap = theme.componentOverrides.get<VXChipStyle>()?.gap;
    return Padding(padding: resolvedStyle?.padding, spacing: style!.spacing);''',
        ),
      ]);
      expect(found, isEmpty);
    });

    test('skips a field listed as read elsewhere', () {
      final found = _unread(
        [_widget('    return Padding(padding: resolvedStyle?.padding);')],
        elsewhere: const {
          'VXChipStyle.spacing': 'VXRow reads it',
          'VXChipStyle.gap': 'VXRow reads it',
        },
      );
      expect(found, isEmpty);
    });

    test(
      'flags a field listed as read elsewhere that its own folder reads',
      () {
        final found = _unread(
          [_widget('    return Padding(padding: resolvedStyle?.padding);')],
          elsewhere: const {
            'VXChipStyle.padding': 'VXRow reads it',
            'VXChipStyle.spacing': 'VXRow reads it',
            'VXChipStyle.gap': 'VXRow reads it',
          },
        );
        expect(
          found.single,
          'v_x_chip_style.dart:11 VXChipStyle.padding is read in its own '
          'folder: remove it from styleFieldsReadElsewhere',
        );
      },
    );
  });

  test('scanStyleFields walks component folders and flags stale entries', () {
    final dir = Directory.systemTemp.createTempSync('style_fields_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final folder = Directory('${dir.path}/inputs/v_x_chip')
      ..createSync(recursive: true);
    File('${folder.path}/v_x_chip_style.dart').writeAsStringSync(_style);
    File(
      '${folder.path}/v_x_chip.dart',
    ).writeAsStringSync(_widget('    return Gap(resolvedStyle?.gap);'));
    final found = scanStyleFields(
      dir.path,
      root: dir.path,
      readElsewhere: const {'VXChipStyle.radius': 'gone'},
    );
    expect(found, [
      'inputs/v_x_chip/v_x_chip_style.dart:11 VXChipStyle.padding',
      'inputs/v_x_chip/v_x_chip_style.dart:14 VXChipStyle.spacing',
      'styleFieldsReadElsewhere names VXChipStyle.radius, which no style declares',
    ]);
  });
}
