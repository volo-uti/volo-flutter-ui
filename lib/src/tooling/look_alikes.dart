// Pure Dart (no Flutter): used by `dart run volo_flutter_ui:look_alikes`.
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/dart_source.dart';

/// Widget name ending -> the volo_flutter_ui widgets that fill that role.
///
/// An app widget whose name ends with a key builds one of its widgets, the
/// first one named in the message. The longest matching key wins, so
/// `IconButton` is checked before `Button`.
const lookAlikeRoles = <String, List<String>>{
  'IconButton': ['VIconButton'],
  'ToggleButton': ['VToggleButton'],
  'Button': ['VButton', 'VIconButton', 'VFab', 'VToggleButton'],
  'Fab': ['VFab'],
  'Chip': ['VChip'],
  'Badge': ['VBadge'],
  'Avatar': ['VAvatar'],
  'Divider': ['VDivider'],
  'Tooltip': ['VTooltip'],
  'ListTile': _listTiles,
  'ListRow': _listTiles,
  'ListItem': _listTiles,
  'SettingTile': _settingTiles,
  'SettingsTile': _settingTiles,
  'SettingRow': _settingTiles,
  'SettingsRow': _settingTiles,
  'SwitchTile': ['VSwitchListTile', 'VSettingTile'],
  'SwitchRow': ['VSwitchListTile', 'VSettingTile'],
  'CheckTile': ['VCheckListTile', 'VSettingTile'],
  'CheckRow': ['VCheckListTile', 'VSettingTile'],
  'BottomNav': ['VBottomNav'],
  'BottomNavBar': ['VBottomNav'],
  'NavBar': ['VBottomNav'],
  'NavItem': ['VBottomNav', 'VDrawer'],
  'TabBar': ['VTabs', 'VBottomNav'],
  'Tabs': ['VTabs'],
  'AppBar': ['VAppBar'],
  'TopBar': ['VAppBar'],
  'Drawer': ['VDrawer'],
  'Menu': ['VMenu'],
  'TextField': ['VTextField', 'VTextArea'],
  'Input': ['VTextField', 'VTextArea'],
  'TextArea': ['VTextArea'],
  'Select': ['VSelect'],
  'Dropdown': ['VSelect', 'VMenu'],
  'Checkbox': ['VCheckbox'],
  'Switch': ['VSwitch'],
  'Radio': ['VRadio'],
  'Slider': ['VSlider'],
  'DatePicker': ['VDatePicker'],
  'Dialog': ['VDialog', 'VAlertDialog'],
  'Snackbar': ['VSnackbar'],
  'SnackBar': ['VSnackbar'],
  'Toast': ['VToast'],
  'Spinner': ['VLoadingSpinner', 'VProgress'],
  'ProgressBar': ['VProgress'],
  'Skeleton': ['VSkeleton'],
  'Card': ['VCard'],
  'BottomSheet': ['VBottomSheet', 'VSheet'],
  'Sheet': ['VBottomSheet', 'VSideSheet', 'VSheet'],
};

const _listTiles = [
  'VListTile',
  'VSettingTile',
  'VSwitchListTile',
  'VCheckListTile',
];

const _settingTiles = [
  'VSettingTile',
  'VSwitchListTile',
  'VCheckListTile',
  'VListTile',
];

/// The [lookAlikeRoles] key that [className] ends with, longest first.
String? lookAlikeRoleOf(String className) {
  String? best;
  for (final role in lookAlikeRoles.keys) {
    if (className.endsWith(role) &&
        (best == null || role.length > best.length)) {
      best = role;
    }
  }
  return best;
}

// `class Name<T> extends SomethingWidget`; `State<...>` and plain classes do
// not end in Widget.
final _widgetClass = RegExp(
  r'\bclass\s+(\w+)\s*(?:<[^{]*?>)?\s+extends\s+(?:\w+\.)?(\w*Widget)\b',
);

/// Shortest reason a `// look-alike:` marker must give, in characters.
const minLookAlikeReason = 15;

/// What [scanLookAlikes] found: failures and look-alikes accepted by a marker.
class LookAlikeReport {
  /// Creates an empty report.
  LookAlikeReport();

  /// `path:line Name rebuilds VX — ...`, or a marker whose reason is too short.
  final List<String> failures = [];

  /// `path:line Name — reason` for each widget kept by a `// look-alike:` line.
  final List<String> accepted = [];

  /// Adds the entries of [other] to this report.
  void addAll(LookAlikeReport other) {
    failures.addAll(other.failures);
    accepted.addAll(other.accepted);
  }
}

// `// look-alike: <why>` (not a `///` doc line).
final _marker = RegExp(r'^\s*//(?!/)\s*look-alike:(.*)$');

/// Look-alikes in [source], each failure as `path:line Name rebuilds VX ...`.
///
/// A widget class whose name ends with a role fails unless the same file uses
/// one of the role's widgets in code. A `TODO(library: ...)` comment does not
/// count as a use. A `// look-alike: <why>` line in the comments and
/// annotations right above the class accepts it when the reason has at least
/// [minLookAlikeReason] characters.
LookAlikeReport scanLookAlikes(String path, String source) {
  final code = blankCommentsAndStrings(source);
  final lines = source.split('\n');
  final report = LookAlikeReport();
  for (final m in _widgetClass.allMatches(code)) {
    final name = m[1]!;
    final role = lookAlikeRoleOf(name);
    if (role == null) continue;
    final widgets = lookAlikeRoles[role]!;
    final uses = widgets.any((w) => RegExp('\\b$w\\b').hasMatch(code));
    if (uses) continue;
    final line = lineOf(code, m.start + m[0]!.indexOf(name, 'class'.length));
    final reason = _markerAbove(lines, lineOf(code, m.start));
    if (reason == null) {
      report.failures.add(
        '$path:$line $name rebuilds ${widgets.first} — use ${_oneOf(widgets)} '
        'and hand-write only the missing detail, marked TODO(library: …)',
      );
    } else if (reason.length < minLookAlikeReason) {
      report.failures.add(
        '$path:$line $name: the look-alike reason is too short '
        '(${reason.length} chars, at least $minLookAlikeReason) — say why '
        '${_oneOf(widgets)} cannot be used',
      );
    } else {
      report.accepted.add('$path:$line $name — $reason');
    }
  }
  return report;
}

/// The reason of the `// look-alike:` line in the run of comment and
/// annotation lines that ends just above the 1-based line [classLine].
String? _markerAbove(List<String> lines, int classLine) {
  for (var i = classLine - 2; i >= 0; i--) {
    final line = lines[i].trimLeft();
    if (!line.startsWith('//') && !line.startsWith('@')) return null;
    final m = _marker.firstMatch(line);
    if (m != null) return m[1]!.trim();
  }
  return null;
}

/// `A`, `A or B`, `A, B or C`.
String _oneOf(List<String> names) => names.length == 1
    ? names.single
    : '${names.sublist(0, names.length - 1).join(', ')} or ${names.last}';

/// [scanLookAlikes] over every `.dart` file under [dirs]; generated files are
/// skipped.
LookAlikeReport scanLookAlikeDirs(Iterable<String> dirs) {
  final report = LookAlikeReport();
  for (final dir in dirs) {
    final files =
        Directory(dir)
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where(
              (f) =>
                  !RegExp(r'\.(g|freezed|generated)\.dart$').hasMatch(f.path),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final f in files) {
      report.addAll(scanLookAlikes(f.path, f.readAsStringSync()));
    }
  }
  return report;
}
