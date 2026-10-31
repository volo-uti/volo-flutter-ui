import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/src/tooling/raw_widgets.dart';

void main() {
  group('scanRawWidgets', () {
    test('names the replacement and the line', () {
      final found = scanRawWidgets(
        'a.dart',
        'void f() {\n  ElevatedButton(onPressed: null);\n}',
      );
      expect(
        found.single,
        'a.dart:2: Use VButton from package:volo_flutter_ui/volo_flutter_ui.dart '
        '(see the volo_flutter_ui index in AGENTS.md).',
      );
    });

    test('maps every raw button to its replacement', () {
      for (final e in rawWidgets.entries) {
        final found = scanRawWidgets('a.dart', '${e.key}(child: x)');
        expect(found.single, contains('Use ${e.value} '));
      }
    });

    test('maps the input widgets to their replacements', () {
      const expected = {
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
      };
      expected.forEach((raw, replacement) {
        expect(rawWidgets[raw], replacement);
        expect(
          scanRawWidgets('a.dart', '$raw(onChanged: null)').single,
          contains('Use $replacement '),
        );
      });
    });

    test('maps the data display widgets to their replacements', () {
      const expected = {
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
        'Image.network': 'VImage.network',
        'Image.asset': 'VImage.asset',
        'Image.file': 'VImage.file',
      };
      expected.forEach((raw, replacement) {
        expect(rawWidgets[raw], replacement);
        expect(
          scanRawWidgets('a.dart', '$raw(x)').single,
          contains('Use $replacement '),
        );
      });
    });

    test('leaves the V widgets and bare Image alone', () {
      expect(
        scanRawWidgets(
          'a.dart',
          'VChip(); VBadge(); VDivider(); VTooltip(); VListTile(); VTable(); Image(image: x);',
        ),
        isEmpty,
      );
    });

    test('maps navigation widgets to their VUI replacements', () {
      const expected = {
        'AppBar': 'VAppBar',
        'SliverAppBar': 'VAppBar',
        'BottomNavigationBar': 'VBottomNav',
        'NavigationBar': 'VBottomNav',
        'Drawer': 'VDrawer',
        'NavigationDrawer': 'VDrawer',
        'TabBar': 'VTabs',
        'TabBarView': 'VTabs',
      };
      expected.forEach((raw, replacement) {
        expect(rawWidgets[raw], replacement);
        expect(
          scanRawWidgets('a.dart', '$raw(children: [])').single,
          contains('Use $replacement '),
        );
      });
      expect(
        scanRawWidgets(
          'a.dart',
          'VAppBar(); VBottomNav(); VDrawer(); VTabs();',
        ),
        isEmpty,
      );
    });

    test('maps menu, stepper, command and indicator widgets to navigation', () {
      const expected = {
        'PopupMenuButton': 'VMenu',
        'MenuAnchor': 'VMenu',
        'showMenu': 'VMenu',
        'Stepper': 'VStepper',
        'SearchAnchor': 'VCommand',
        'TabPageSelector': 'VPageIndicator',
      };
      expected.forEach((raw, replacement) {
        expect(rawWidgets[raw], replacement);
        expect(
          scanRawWidgets('a.dart', '$raw(items: [])').single,
          contains('Use $replacement '),
        );
      });
      expect(
        scanRawWidgets(
          'a.dart',
          'VMenu(); VStepper(); VCommand(); VPageIndicator.dots();',
        ),
        isEmpty,
      );
    });

    test('maps scaffold, app, page, grid and scrollbar widgets to layout', () {
      const expected = {
        'Scaffold': 'VScaffold',
        'MaterialApp': 'VApp',
        'WidgetsApp': 'VApp',
        'PageView': 'VCarousel',
        'GridView': 'VGrid',
        'Scrollbar': 'VScrollArea',
        'RawScrollbar': 'VScrollArea',
      };
      expected.forEach((raw, replacement) {
        expect(rawWidgets[raw], replacement);
        expect(
          scanRawWidgets('a.dart', '$raw(child: x)').single,
          contains('Use $replacement '),
        );
      });
      expect(
        scanRawWidgets('a.dart', 'GridView.builder(itemBuilder: x)').single,
        contains('Use VGrid '),
      );
      expect(
        scanRawWidgets(
          'a.dart',
          'VScaffold(); VApp(); VCarousel(); VGrid.count(); VScrollArea(); '
              'Row(); Column(); Stack(); ScaffoldMessenger();',
        ),
        isEmpty,
      );
    });

    test('maps text, form and date widgets to their replacements', () {
      const expected = {
        'TextField': 'VTextField (VTextArea for multi-line)',
        'TextFormField': 'VTextField (VTextArea for multi-line)',
        'Form': 'VForm',
        'CalendarDatePicker': 'VCalendar',
        'DatePickerDialog': 'VDatePicker',
        'showDatePicker': 'VDatePicker',
        'showDateRangePicker': 'VDatePicker.range',
        'showTimePicker': 'VDatePicker.time',
      };
      expected.forEach((raw, replacement) {
        expect(
          scanRawWidgets('a.dart', '$raw(context: null)').single,
          contains('Use $replacement '),
        );
      });
      expect(scanRawWidgets('a.dart', 'VTextField(name: "a")'), isEmpty);
      expect(scanRawWidgets('a.dart', 'VForm(children: [])'), isEmpty);
    });

    test('maps dialog, snackbar, banner and barrier widgets to feedback', () {
      const expected = {
        'AlertDialog': 'VAlertDialog',
        'SimpleDialog': 'VDialog',
        'Dialog': 'VDialog',
        'showDialog': 'VDialog.show',
        'SnackBar': 'VSnackbar',
        'MaterialBanner': 'VAlert',
        'ModalBarrier': 'VBackdrop',
      };
      expected.forEach((raw, replacement) {
        expect(
          scanRawWidgets('a.dart', '$raw(context: null)').single,
          contains('Use $replacement '),
        );
      });
      expect(
        scanRawWidgets(
          'a.dart',
          'VDialog.alert(); VAlertDialog(); VSnackbar(); VAlert(); VBackdrop();',
        ),
        isEmpty,
      );
    });

    test(
      'maps progress, accordion, card and sheet widgets to their VUI replacements',
      () {
        const expected = {
          'CircularProgressIndicator': 'VLoadingSpinner',
          'LinearProgressIndicator': 'VProgress.linear',
          'ExpansionTile': 'VAccordion',
          'ExpansionPanelList': 'VAccordion',
          'Card': 'VCard',
          'showModalBottomSheet': 'VBottomSheet.show',
          'BottomSheet': 'VBottomSheet',
        };
        expected.forEach((raw, replacement) {
          expect(
            scanRawWidgets('a.dart', '$raw(context: null)').single,
            contains('Use $replacement'),
          );
        });
        expect(
          scanRawWidgets(
            'a.dart',
            'VCard(); VCardHeader(); VProgress.linear(); VAccordion(); VSheet.bottom();',
          ),
          isEmpty,
        );
      },
    );

    test('maps FloatingActionButton and its constructors to VFab', () {
      for (final call in [
        'FloatingActionButton(onPressed: null)',
        'FloatingActionButton.extended(onPressed: null)',
        'FloatingActionButton.small(onPressed: null)',
      ]) {
        expect(scanRawWidgets('a.dart', call).single, contains('Use VFab '));
      }
    });

    test('does not flag V widgets that contain a raw name', () {
      expect(
        scanRawWidgets('a.dart', 'VCheckbox(\nVSwitch(\nSwitchTheme(\n'),
        isEmpty,
      );
    });

    test('matches generic calls, including nested type arguments', () {
      expect(
        scanRawWidgets('a.dart', 'DropdownButton<String>(value: x)'),
        hasLength(1),
      );
      expect(
        scanRawWidgets('a.dart', 'DropdownButton<Map<String, int>>(x)'),
        hasLength(1),
      );
      expect(
        scanRawWidgets('a.dart', 'Autocomplete<String>.new(x)'),
        hasLength(1),
      );
      expect(scanRawWidgets('a.dart', 'VSelect<String>(x)'), isEmpty);
    });

    test('matches named constructors', () {
      expect(
        scanRawWidgets('a.dart', 'TextButton.icon(onPressed: null)'),
        hasLength(1),
      );
    });

    test('ignores comments, V widgets and similar names', () {
      const source =
          '// ElevatedButton(\n/// TextButton(\nVIconButton(\nMyTextButton(\nTextButtonTheme(\n';
      expect(scanRawWidgets('a.dart', source), isEmpty);
    });
  });

  test('scanRawWidgetDirs walks folders and skips generated files', () {
    final dir = Directory.systemTemp.createTempSync('raw_widgets_');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/a.dart').writeAsStringSync('IconButton(icon: x)');
    File('${dir.path}/a.g.dart').writeAsStringSync('IconButton(icon: x)');
    final found = scanRawWidgetDirs([dir.path]);
    expect(found, hasLength(1));
    expect(found.single, contains('a.dart:1: Use VIconButton'));
  });
}
