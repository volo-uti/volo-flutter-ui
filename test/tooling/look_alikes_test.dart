import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/src/tooling/look_alikes.dart';

// Rebuilds VChip from a Container: reads only VTheme and leaves a marker.
const _appChip = '''
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

// TODO(library: VChip has no dense size)
class AppChip extends StatelessWidget {
  const AppChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(theme.spacing.xs),
        decoration: BoxDecoration(color: theme.colors.muted),
        child: Text(label),
      ),
    );
  }
}
''';

// Builds VBottomNav and draws only the missing top line by hand.
const _appBottomNav = '''
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      VBottomNav(currentIndex: index, items: const []),
      // TODO(library: VBottomNav has no 4px top line)
      const _TopLine(),
    ],
  );
}

class _TopLine extends StatelessWidget {
  const _TopLine();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 4);
}
''';

void main() {
  group('scanLookAlikes', () {
    test('fails a widget that rebuilds the library widget of its role', () {
      expect(
        scanLookAlikes('a.dart', _appChip).single,
        'a.dart:5 AppChip rebuilds VChip — use VChip and hand-write only '
        'the missing detail, marked TODO(library: …)',
      );
    });

    test('passes a widget that builds the library widget', () {
      expect(scanLookAlikes('a.dart', _appBottomNav), isEmpty);
    });

    test('does not count a TODO(library:) marker or a string as a use', () {
      final source = _appChip.replaceFirst(
        'child: Text(label)',
        "child: Text('VChip')",
      );
      expect(source, contains('TODO(library: VChip'));
      expect(scanLookAlikes('a.dart', source), hasLength(1));
    });

    test('does not count the style or another widget with the name inside', () {
      final source = _appChip.replaceFirst(
        'final theme = VTheme.of(context);',
        'final theme = VTheme.of(context);\n    const s = VChipStyle();',
      );
      expect(scanLookAlikes('a.dart', source), hasLength(1));
    });

    test('skips State classes, data classes and other names', () {
      const source = '''
class _AppChipState extends State<AppChip> {}
class AppChipStyle { const AppChipStyle(); }
class ChipData {}
class CloudCell extends StatelessWidget {}
class Chips extends StatelessWidget {}
''';
      expect(scanLookAlikes('a.dart', source), isEmpty);
    });

    test('checks private, generic and Riverpod-style widgets', () {
      const source = '''
class _Chip extends StatelessWidget {}
class AppSelect<T> extends StatefulWidget {}
class PrefsSwitchRow extends ConsumerWidget {}
''';
      final found = scanLookAlikes('a.dart', source);
      expect(found, hasLength(3));
      expect(found[0], startsWith('a.dart:1 _Chip rebuilds VChip '));
      expect(found[1], startsWith('a.dart:2 AppSelect rebuilds VSelect '));
      expect(
        found[2],
        startsWith(
          'a.dart:3 PrefsSwitchRow rebuilds VSwitchListTile — use '
          'VSwitchListTile or VSettingTile ',
        ),
      );
    });

    test('names every widget that fills a role with more than one', () {
      expect(
        scanLookAlikes(
          'a.dart',
          'class AppDialog extends StatelessWidget {}',
        ).single,
        contains('AppDialog rebuilds VDialog — use VDialog or VAlertDialog '),
      );
      expect(
        scanLookAlikes(
          'a.dart',
          'class AppDialog extends StatelessWidget { Widget b() => VAlertDialog(); }',
        ),
        isEmpty,
      );
    });
  });

  group('lookAlikeRoleOf', () {
    test('prefers the longest ending', () {
      expect(lookAlikeRoleOf('AppIconButton'), 'IconButton');
      expect(lookAlikeRoleOf('AppButton'), 'Button');
      expect(lookAlikeRoleOf('ProfileSwitchTile'), 'SwitchTile');
      expect(lookAlikeRoleOf('AppSwitch'), 'Switch');
      expect(lookAlikeRoleOf('HomeBottomSheet'), 'BottomSheet');
      expect(lookAlikeRoleOf('CloudCell'), isNull);
    });

    test('an IconButton look-alike points at VIconButton, not VButton', () {
      final found = scanLookAlikes(
        'a.dart',
        'class AppIconButton extends StatelessWidget { Widget b() => VButton(); }',
      );
      expect(found.single, contains('AppIconButton rebuilds VIconButton '));
    });
  });

  test('names only widgets that volo_flutter_ui declares', () {
    final declared = <String>{};
    for (final f
        in Directory('lib/src/components')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      for (final m in RegExp(
        r'\bclass\s+(V\w+)',
      ).allMatches(f.readAsStringSync())) {
        declared.add(m[1]!);
      }
    }
    for (final widgets in lookAlikeRoles.values) {
      for (final w in widgets) {
        expect(declared, contains(w), reason: w);
      }
    }
  });

  test('scanLookAlikeDirs walks folders and skips generated files', () {
    final dir = Directory.systemTemp.createTempSync('look_alikes_');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/a.dart').writeAsStringSync(_appChip);
    File('${dir.path}/a.g.dart').writeAsStringSync(_appChip);
    File('${dir.path}/b.dart').writeAsStringSync(_appBottomNav);
    final found = scanLookAlikeDirs([dir.path]);
    expect(found.single, startsWith('${dir.path}/a.dart:5 AppChip rebuilds'));
  });
}
