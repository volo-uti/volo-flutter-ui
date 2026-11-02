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

// A button that is a VIconButton: the Button role takes every button widget.
const _findMeButton = '''
class _FindMeButton extends ConsumerWidget {
  const _FindMeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      VIconButton(icon: VIcons.close(), onPressed: () {});
}
''';

// An app frame that only shares the Tabs name, with the reason between doc
// lines.
const _mainTabs = '''
/// Frame of the signed-in screens.
// look-alike: app frame with a header, a body and a bottom bar, not a tab bar
///
/// Holds the router outlet.
class _MainTabs extends StatelessWidget {
  const _MainTabs({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Column(children: [child]);
}
''';

// A switch row built from a Row and a bare VSwitch instead of a switch tile.
const _alertSwitchRow = '''
class AlertSwitchRow extends StatefulWidget {
  const AlertSwitchRow({required this.label, super.key});

  final String label;

  @override
  State<AlertSwitchRow> createState() => _AlertSwitchRowState();
}

class _AlertSwitchRowState extends State<AlertSwitchRow> {
  var _on = false;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(widget.label),
      VSwitch(value: _on, onChanged: (v) => setState(() => _on = v)),
    ],
  );
}
''';

// A sheet the library does not have yet: it stays open while the page moves.
String _sheet(String marker) =>
    '''
import 'package:flutter/widgets.dart';

/// Panel that stays over the map.
$marker
@immutable
class MapPanelSheet extends StatelessWidget {
  const MapPanelSheet({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox();
}
''';

final _panelSheet = _sheet(
  '// look-alike: VBottomSheet is modal; this panel stays open while the map moves',
);

List<String> _failures(String source) =>
    scanLookAlikes('a.dart', source).failures;

void main() {
  group('look-alike marker', () {
    test('passes a button built on VIconButton', () {
      final report = scanLookAlikes('a.dart', _findMeButton);
      expect(report.failures, isEmpty);
      expect(report.accepted, isEmpty);
    });

    test('accepts and lists a widget that only shares a role name', () {
      final report = scanLookAlikes('a.dart', _mainTabs);
      expect(report.failures, isEmpty);
      expect(
        report.accepted.single,
        'a.dart:5 _MainTabs — app frame with a header, a body and a bottom '
        'bar, not a tab bar',
      );
    });

    test('fails a switch row built from a Row and a bare switch', () {
      expect(
        _failures(_alertSwitchRow).single,
        startsWith(
          'a.dart:1 AlertSwitchRow rebuilds VSwitchListTile — use '
          'VSwitchListTile or VSettingTile ',
        ),
      );
    });

    test('accepts and lists a sheet the library lacks, with its reason', () {
      final report = scanLookAlikes('a.dart', _panelSheet);
      expect(report.failures, isEmpty);
      expect(
        report.accepted.single,
        'a.dart:6 MapPanelSheet — VBottomSheet is modal; this panel stays '
        'open while the map moves',
      );
    });

    test('fails a marker with an empty or short reason', () {
      expect(
        _failures(_sheet('// look-alike:')).single,
        'a.dart:6 MapPanelSheet: the look-alike reason is too short '
        '(0 chars, at least 15) — say why VBottomSheet, VSideSheet or VSheet '
        'cannot be used',
      );
      expect(
        _failures(_sheet('// look-alike: not modal')).single,
        contains('too short (9 chars, at least 15)'),
      );
      expect(
        scanLookAlikes('a.dart', _sheet('// look-alike:')).accepted,
        isEmpty,
      );
    });

    test('reads only a // line in the block right above the class', () {
      const reason = 'VBottomSheet is modal; this panel stays open';
      expect(
        _failures(_sheet('/// look-alike: $reason')).single,
        contains('MapPanelSheet rebuilds VBottomSheet'),
      );
      expect(
        _failures(_sheet('// look-alike: $reason\n')).single,
        contains('MapPanelSheet rebuilds VBottomSheet'),
      );
      expect(
        _failures(
          _sheet('// TODO(library: VBottomSheet cannot stay open)'),
        ).single,
        contains('MapPanelSheet rebuilds VBottomSheet'),
      );
    });
  });

  group('scanLookAlikes', () {
    test('fails a widget that rebuilds the library widget of its role', () {
      expect(
        _failures(_appChip).single,
        'a.dart:5 AppChip rebuilds VChip — use VChip and hand-write only '
        'the missing detail, marked TODO(library: …)',
      );
    });

    test('passes a widget that builds the library widget', () {
      expect(_failures(_appBottomNav), isEmpty);
    });

    test('does not count a TODO(library:) marker or a string as a use', () {
      final source = _appChip.replaceFirst(
        'child: Text(label)',
        "child: Text('VChip')",
      );
      expect(source, contains('TODO(library: VChip'));
      expect(_failures(source), hasLength(1));
    });

    test('does not count the style or another widget with the name inside', () {
      final source = _appChip.replaceFirst(
        'final theme = VTheme.of(context);',
        'final theme = VTheme.of(context);\n    const s = VChipStyle();',
      );
      expect(_failures(source), hasLength(1));
    });

    test('skips State classes, data classes and other names', () {
      const source = '''
class _AppChipState extends State<AppChip> {}
class AppChipStyle { const AppChipStyle(); }
class ChipData {}
class CloudCell extends StatelessWidget {}
class Chips extends StatelessWidget {}
''';
      expect(_failures(source), isEmpty);
    });

    test('checks private, generic and Riverpod-style widgets', () {
      const source = '''
class _Chip extends StatelessWidget {}
class AppSelect<T> extends StatefulWidget {}
class PrefsSwitchRow extends ConsumerWidget {}
''';
      final found = _failures(source);
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
        _failures('class AppDialog extends StatelessWidget {}').single,
        contains('AppDialog rebuilds VDialog — use VDialog or VAlertDialog '),
      );
      expect(
        _failures(
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
      final found = _failures(
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
    File('${dir.path}/c.dart').writeAsStringSync(_panelSheet);
    final report = scanLookAlikeDirs([dir.path]);
    expect(
      report.failures.single,
      startsWith('${dir.path}/a.dart:5 AppChip rebuilds'),
    );
    expect(report.accepted.single, startsWith('${dir.path}/c.dart:6 '));
  });
}
