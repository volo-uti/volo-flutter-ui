// Pure Dart (no Flutter): used by `dart run volo_flutter_ui:raw_widgets`.
import 'dart:io';

/// Raw Material widget -> replacement from volo_flutter_ui. A new volo_flutter_ui widget that
/// replaces a raw one adds one entry here.
const rawWidgets = {
  'ElevatedButton': 'VButton',
  'FilledButton': 'VButton',
  'OutlinedButton': 'VButton',
  'TextButton': 'VButton',
  'IconButton': 'VIconButton',
  'FloatingActionButton': 'VFab',
  'Checkbox': 'VCheckbox',
  'Radio': 'VRadio',
  'Switch': 'VSwitch',
  'Slider': 'VSlider',
  'RangeSlider': 'VSlider',
  'DropdownButton': 'VSelect',
  'DropdownButtonFormField': 'VSelect',
  'DropdownMenu': 'VSelect',
  'Autocomplete': 'VAutocomplete',
  'ToggleButtons': 'VToggleButton',
  'SegmentedButton': 'VToggleButtonGroup',
  'TextField': 'VTextField (VTextArea for multi-line)',
  'TextFormField': 'VTextField (VTextArea for multi-line)',
  'Form': 'VForm',
  'CalendarDatePicker': 'VCalendar',
  'DatePickerDialog': 'VDatePicker',
  'showDatePicker': 'VDatePicker',
  'showDateRangePicker': 'VDatePicker.range',
  'showTimePicker': 'VDatePicker.time',
  'Chip': 'VChip',
  'ActionChip': 'VChip',
  'FilterChip': 'VChip.filter',
  'ChoiceChip': 'VChip.filter',
  'InputChip': 'VChip.input',
  'RawChip': 'VChip',
  'Badge': 'VBadge',
  'CircleAvatar': 'VAvatar',
  'Divider': 'VDivider',
  'VerticalDivider': 'VDivider',
  'Tooltip': 'VTooltip',
  'ListTile': 'VListTile',
  'CheckboxListTile': 'VCheckListTile',
  'SwitchListTile': 'VSwitchListTile',
  'DataTable': 'VTable',
  'PaginatedDataTable': 'VTable',
  'AlertDialog': 'VAlertDialog',
  'SimpleDialog': 'VDialog',
  'Dialog': 'VDialog',
  'showDialog': 'VDialog.show',
  'SnackBar': 'VSnackbar',
  'MaterialBanner': 'VAlert',
  'ModalBarrier': 'VBackdrop',
  'CircularProgressIndicator':
      'VLoadingSpinner (VProgress.circular for a value)',
  'LinearProgressIndicator': 'VProgress.linear',
  'ExpansionTile': 'VAccordion',
  'ExpansionPanelList': 'VAccordion',
  'Card': 'VCard',
  'showModalBottomSheet': 'VBottomSheet.show',
  'BottomSheet': 'VBottomSheet',
  'AppBar': 'VAppBar',
  'SliverAppBar': 'VAppBar',
  'BottomNavigationBar': 'VBottomNav',
  'NavigationBar': 'VBottomNav',
  'Drawer': 'VDrawer',
  'NavigationDrawer': 'VDrawer',
  'TabBar': 'VTabs',
  'TabBarView': 'VTabs',
  'PopupMenuButton': 'VMenu',
  'MenuAnchor': 'VMenu',
  'showMenu': 'VMenu',
  'Stepper': 'VStepper',
  'SearchAnchor': 'VCommand',
  'TabPageSelector': 'VPageIndicator',
  'Scaffold': 'VScaffold',
  'MaterialApp': 'VApp (VApp.router for a router config)',
  'WidgetsApp': 'VApp (VApp.router for a router config)',
  'PageView': 'VCarousel',
  'GridView': 'VGrid',
  'Scrollbar': 'VScrollArea',
  'RawScrollbar': 'VScrollArea',
  'Image.network': 'VImage.network',
  'Image.asset': 'VImage.asset',
  'Image.file': 'VImage.file',
};

// Optional generic arguments, nested up to three levels: `<Map<String, int>>`.
const _generics = '(?:<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>)?';

/// Violations in [source] as `path:line: message`, skipping comment lines.
List<String> scanRawWidgets(String path, String source) {
  final found = <String>[];
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].trimLeft().startsWith('//')) continue;
    for (final e in rawWidgets.entries) {
      if (RegExp('\\b${e.key}$_generics(?:\\.\\w+)?\\(').hasMatch(lines[i])) {
        found.add(
          '$path:${i + 1}: Use ${e.value} from package:volo_flutter_ui/volo_flutter_ui.dart '
          '(see the volo_flutter_ui index in AGENTS.md).',
        );
      }
    }
  }
  return found;
}

/// Violations in every `.dart` file under [dirs]; generated files are skipped.
List<String> scanRawWidgetDirs(Iterable<String> dirs) {
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
      found.addAll(scanRawWidgets(f.path, f.readAsStringSync()));
    }
  }
  return found;
}
