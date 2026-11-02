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
  'Button': ['VButton'],
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

/// Violations in [source] as `path:line Name rebuilds VX — use VX ...`.
///
/// A widget class whose name ends with a role fails unless the same file uses
/// one of the role's widgets in code. A `TODO(library: ...)` comment does not
/// count as a use.
List<String> scanLookAlikes(String path, String source) {
  final code = blankCommentsAndStrings(source);
  final found = <String>[];
  for (final m in _widgetClass.allMatches(code)) {
    final name = m[1]!;
    final role = lookAlikeRoleOf(name);
    if (role == null) continue;
    final widgets = lookAlikeRoles[role]!;
    final uses = widgets.any((w) => RegExp('\\b$w\\b').hasMatch(code));
    if (uses) continue;
    final line = lineOf(code, m.start + m[0]!.indexOf(name, 'class'.length));
    found.add(
      '$path:$line $name rebuilds ${widgets.first} — use ${_oneOf(widgets)} '
      'and hand-write only the missing detail, marked TODO(library: …)',
    );
  }
  return found;
}

/// `A`, `A or B`, `A, B or C`.
String _oneOf(List<String> names) => names.length == 1
    ? names.single
    : '${names.sublist(0, names.length - 1).join(', ')} or ${names.last}';

/// Violations in every `.dart` file under [dirs]; generated files are skipped.
List<String> scanLookAlikeDirs(Iterable<String> dirs) {
  final found = <String>[];
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
      found.addAll(scanLookAlikes(f.path, f.readAsStringSync()));
    }
  }
  return found;
}
