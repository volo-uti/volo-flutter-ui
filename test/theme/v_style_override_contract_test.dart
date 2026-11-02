import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

// ---------------------------------------------------------------------------
// Helper: registers tests for a single StyleOverride class.
// By calling this function with explicit <T>, the type is preserved.
// ---------------------------------------------------------------------------
void _contract<T>({
  required String name,
  required T empty,
  required T a,
  required T b,
  required T mergeResult,
  required List<Object? Function(T)> nullFields,
  required T Function(T style, T? other) merge,
  required T Function(T style) copyWithOverride,
  required T copyWithResult,
}) {
  group(name, () {
    test('empty constructor has all null fields', () {
      for (var i = 0; i < nullFields.length; i++) {
        expect(
          nullFields[i](empty),
          isNull,
          reason: '$name field #$i should be null on empty constructor',
        );
      }
    });

    test('merge with null returns same instance', () {
      final result = merge(a, null);
      expect(result, same(a));
    });

    test('merge non-null wins', () {
      final merged = merge(a, b);
      expect(merged, equals(mergeResult));
    });

    test('copyWith replaces specified only', () {
      final result = copyWithOverride(a);
      expect(result, equals(copyWithResult));
    });

    test('equality and hashCode', () {
      expect(a, equals(a));
      expect(a, isNot(equals(b)));
      expect(a.hashCode, equals(a.hashCode));
    });
  });
}

// ---------------------------------------------------------------------------
// Test value constants
// ---------------------------------------------------------------------------
const _red = Color(0xFFFF0000);
const _green = Color(0xFF00FF00);
const _blue = Color(0xFF0000FF);
const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const _yellow = Color(0xFFFFFF00);
const _cyan = Color(0xFF00FFFF);
const _magenta = Color(0xFFFF00FF);
const _orange = Color(0xFFFFA500);
const _gray = Color(0xFF808080);
const _br4 = BorderRadius.all(Radius.circular(4));
const _br8 = BorderRadius.all(Radius.circular(8));
const _ei8 = EdgeInsets.all(8);
const _ei16 = EdgeInsets.all(16);
const _ts14 = TextStyle(fontSize: 14);
const _ts18 = TextStyle(fontSize: 18);

// ---------------------------------------------------------------------------
// main — registers contract tests for all 64 StyleOverride classes
// ---------------------------------------------------------------------------
void main() {
  // =========================================================================
  // INPUTS (22)
  // =========================================================================
  _contract<VButtonStyle>(
    name: 'VButtonStyle',
    empty: const VButtonStyle(),
    a: const VButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      iconColor: _black,
      gap: 8,
    ),
    b: const VButtonStyle(backgroundColor: _green, gap: 16),
    mergeResult: const VButtonStyle(
      backgroundColor: _green,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      iconColor: _black,
      gap: 16,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.iconColor,
      (s) => s.gap,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(gap: 24),
    copyWithResult: const VButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      iconColor: _black,
      gap: 24,
    ),
  );

  _contract<VIconButtonStyle>(
    name: 'VIconButtonStyle',
    empty: const VIconButtonStyle(),
    a: const VIconButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      overlayColor: _white,
      iconColor: _black,
      iconSize: 24,
    ),
    b: const VIconButtonStyle(iconSize: 32),
    mergeResult: const VIconButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      overlayColor: _white,
      iconColor: _black,
      iconSize: 32,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.overlayColor,
      (s) => s.iconColor,
      (s) => s.iconSize,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(iconSize: 48),
    copyWithResult: const VIconButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      overlayColor: _white,
      iconColor: _black,
      iconSize: 48,
    ),
  );

  _contract<VFabStyle>(
    name: 'VFabStyle',
    empty: const VFabStyle(),
    a: const VFabStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderRadius: _br4,
      elevation: 6,
      overlayColor: _white,
      iconColor: _black,
    ),
    b: const VFabStyle(elevation: 12),
    mergeResult: const VFabStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderRadius: _br4,
      elevation: 12,
      overlayColor: _white,
      iconColor: _black,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.overlayColor,
      (s) => s.iconColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(elevation: 0),
    copyWithResult: const VFabStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderRadius: _br4,
      elevation: 0,
      overlayColor: _white,
      iconColor: _black,
    ),
  );

  _contract<VToggleButtonStyle>(
    name: 'VToggleButtonStyle',
    empty: const VToggleButtonStyle(),
    a: const VToggleButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      selectedBackgroundColor: _green,
      selectedForegroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
    ),
    b: const VToggleButtonStyle(selectedBackgroundColor: _yellow),
    mergeResult: const VToggleButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      selectedBackgroundColor: _yellow,
      selectedForegroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.selectedBackgroundColor,
      (s) => s.selectedForegroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VToggleButtonStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      selectedBackgroundColor: _green,
      selectedForegroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei16,
    ),
  );

  _contract<VButtonGroupStyle>(
    name: 'VButtonGroupStyle',
    empty: const VButtonGroupStyle(),
    a: const VButtonGroupStyle(
      borderColor: _red,
      borderRadius: _br4,
      spacing: 4,
    ),
    b: const VButtonGroupStyle(spacing: 8),
    mergeResult: const VButtonGroupStyle(
      borderColor: _red,
      borderRadius: _br4,
      spacing: 8,
    ),
    nullFields: [(s) => s.borderColor, (s) => s.borderRadius, (s) => s.spacing],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VButtonGroupStyle(
      borderColor: _red,
      borderRadius: _br8,
      spacing: 4,
    ),
  );

  _contract<VTextFieldStyle>(
    name: 'VTextFieldStyle',
    empty: const VTextFieldStyle(),
    a: const VTextFieldStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      hintStyle: _ts14,
      labelStyle: _ts14,
      cursorColor: _black,
    ),
    b: const VTextFieldStyle(cursorColor: _red),
    mergeResult: const VTextFieldStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      hintStyle: _ts14,
      labelStyle: _ts14,
      cursorColor: _red,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.focusBorderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.hintStyle,
      (s) => s.labelStyle,
      (s) => s.cursorColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VTextFieldStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
      hintStyle: _ts14,
      labelStyle: _ts14,
      cursorColor: _black,
    ),
  );

  _contract<VTextAreaStyle>(
    name: 'VTextAreaStyle',
    empty: const VTextAreaStyle(),
    a: const VTextAreaStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      hintStyle: _ts14,
    ),
    b: const VTextAreaStyle(hintStyle: _ts18),
    mergeResult: const VTextAreaStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      hintStyle: _ts18,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.focusBorderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.hintStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(textStyle: _ts18),
    copyWithResult: const VTextAreaStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts18,
      hintStyle: _ts14,
    ),
  );

  _contract<VSelectStyle>(
    name: 'VSelectStyle',
    empty: const VSelectStyle(),
    a: const VSelectStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      dropdownBackgroundColor: _white,
      dropdownBorderRadius: _br8,
    ),
    b: const VSelectStyle(dropdownBackgroundColor: _black),
    mergeResult: const VSelectStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      dropdownBackgroundColor: _black,
      dropdownBorderRadius: _br8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.focusBorderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.dropdownBackgroundColor,
      (s) => s.dropdownBorderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VSelectStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
      dropdownBackgroundColor: _white,
      dropdownBorderRadius: _br8,
    ),
  );

  _contract<VAutocompleteStyle>(
    name: 'VAutocompleteStyle',
    empty: const VAutocompleteStyle(),
    a: const VAutocompleteStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      dropdownBackgroundColor: _white,
    ),
    b: const VAutocompleteStyle(dropdownBackgroundColor: _black),
    mergeResult: const VAutocompleteStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      dropdownBackgroundColor: _black,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.focusBorderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.dropdownBackgroundColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VAutocompleteStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br8,
      padding: _ei8,
      textStyle: _ts14,
      dropdownBackgroundColor: _white,
    ),
  );

  _contract<VCheckboxStyle>(
    name: 'VCheckboxStyle',
    empty: const VCheckboxStyle(),
    a: const VCheckboxStyle(
      activeColor: _red,
      checkColor: _white,
      borderColor: _black,
      borderRadius: _br4,
    ),
    b: const VCheckboxStyle(activeColor: _green),
    mergeResult: const VCheckboxStyle(
      activeColor: _green,
      checkColor: _white,
      borderColor: _black,
      borderRadius: _br4,
    ),
    nullFields: [
      (s) => s.activeColor,
      (s) => s.checkColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(checkColor: _black),
    copyWithResult: const VCheckboxStyle(
      activeColor: _red,
      checkColor: _black,
      borderColor: _black,
      borderRadius: _br4,
    ),
  );

  _contract<VRadioStyle>(
    name: 'VRadioStyle',
    empty: const VRadioStyle(),
    a: const VRadioStyle(
      activeColor: _red,
      dotColor: _white,
      borderColor: _black,
    ),
    b: const VRadioStyle(dotColor: _blue),
    mergeResult: const VRadioStyle(
      activeColor: _red,
      dotColor: _blue,
      borderColor: _black,
    ),
    nullFields: [(s) => s.activeColor, (s) => s.dotColor, (s) => s.borderColor],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(activeColor: _green),
    copyWithResult: const VRadioStyle(
      activeColor: _green,
      dotColor: _white,
      borderColor: _black,
    ),
  );

  _contract<VSwitchStyle>(
    name: 'VSwitchStyle',
    empty: const VSwitchStyle(),
    a: const VSwitchStyle(
      activeTrackColor: _green,
      inactiveTrackColor: _gray,
      thumbColor: _white,
      activeThumbColor: _blue,
    ),
    b: const VSwitchStyle(activeTrackColor: _red),
    mergeResult: const VSwitchStyle(
      activeTrackColor: _red,
      inactiveTrackColor: _gray,
      thumbColor: _white,
      activeThumbColor: _blue,
    ),
    nullFields: [
      (s) => s.activeTrackColor,
      (s) => s.inactiveTrackColor,
      (s) => s.thumbColor,
      (s) => s.activeThumbColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(thumbColor: _black),
    copyWithResult: const VSwitchStyle(
      activeTrackColor: _green,
      inactiveTrackColor: _gray,
      thumbColor: _black,
      activeThumbColor: _blue,
    ),
  );

  _contract<VSliderStyle>(
    name: 'VSliderStyle',
    empty: const VSliderStyle(),
    a: const VSliderStyle(
      activeColor: _green,
      inactiveColor: _gray,
      thumbColor: _white,
      trackHeight: 4,
    ),
    b: const VSliderStyle(trackHeight: 8),
    mergeResult: const VSliderStyle(
      activeColor: _green,
      inactiveColor: _gray,
      thumbColor: _white,
      trackHeight: 8,
    ),
    nullFields: [
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.thumbColor,
      (s) => s.trackHeight,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(activeColor: _red),
    copyWithResult: const VSliderStyle(
      activeColor: _red,
      inactiveColor: _gray,
      thumbColor: _white,
      trackHeight: 4,
    ),
  );

  _contract<VCalendarStyle>(
    name: 'VCalendarStyle',
    empty: const VCalendarStyle(),
    a: const VCalendarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _blue,
      selectedForegroundColor: _white,
      todayColor: _red,
      borderRadius: _br4,
    ),
    b: const VCalendarStyle(todayColor: _green),
    mergeResult: const VCalendarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _blue,
      selectedForegroundColor: _white,
      todayColor: _green,
      borderRadius: _br4,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.selectedColor,
      (s) => s.selectedForegroundColor,
      (s) => s.todayColor,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(selectedColor: _green),
    copyWithResult: const VCalendarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _green,
      selectedForegroundColor: _white,
      todayColor: _red,
      borderRadius: _br4,
    ),
  );

  _contract<VDatePickerStyle>(
    name: 'VDatePickerStyle',
    empty: const VDatePickerStyle(),
    a: const VDatePickerStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      calendarStyle: VCalendarStyle(selectedColor: _red),
    ),
    b: const VDatePickerStyle(
      calendarStyle: VCalendarStyle(selectedColor: _green),
    ),
    mergeResult: const VDatePickerStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      calendarStyle: VCalendarStyle(selectedColor: _green),
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.focusBorderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.calendarStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VDatePickerStyle(
      backgroundColor: _red,
      foregroundColor: _blue,
      borderColor: _green,
      focusBorderColor: _cyan,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
      calendarStyle: VCalendarStyle(selectedColor: _red),
    ),
  );

  _contract<VFormStyle>(
    name: 'VFormStyle',
    empty: const VFormStyle(),
    a: const VFormStyle(spacing: 16),
    b: const VFormStyle(spacing: 24),
    mergeResult: const VFormStyle(spacing: 24),
    nullFields: [(s) => s.spacing],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(spacing: 32),
    copyWithResult: const VFormStyle(spacing: 32),
  );

  _contract<VFormFieldStyle>(
    name: 'VFormFieldStyle',
    empty: const VFormFieldStyle(),
    a: const VFormFieldStyle(
      labelStyle: _ts14,
      helperStyle: _ts14,
      errorStyle: _ts14,
      spacing: 4,
    ),
    b: const VFormFieldStyle(spacing: 8),
    mergeResult: const VFormFieldStyle(
      labelStyle: _ts14,
      helperStyle: _ts14,
      errorStyle: _ts14,
      spacing: 8,
    ),
    nullFields: [
      (s) => s.labelStyle,
      (s) => s.helperStyle,
      (s) => s.errorStyle,
      (s) => s.spacing,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(labelStyle: _ts18),
    copyWithResult: const VFormFieldStyle(
      labelStyle: _ts18,
      helperStyle: _ts14,
      errorStyle: _ts14,
      spacing: 4,
    ),
  );

  _contract<VFormBodyStyle>(
    name: 'VFormBodyStyle',
    empty: const VFormBodyStyle(),
    a: const VFormBodyStyle(spacing: 12, padding: _ei8),
    b: const VFormBodyStyle(spacing: 20),
    mergeResult: const VFormBodyStyle(spacing: 20, padding: _ei8),
    nullFields: [(s) => s.spacing, (s) => s.padding],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VFormBodyStyle(spacing: 12, padding: _ei16),
  );

  _contract<VFormHeaderStyle>(
    name: 'VFormHeaderStyle',
    empty: const VFormHeaderStyle(),
    a: const VFormHeaderStyle(
      titleStyle: _ts14,
      subtitleStyle: _ts14,
      padding: _ei8,
    ),
    b: const VFormHeaderStyle(titleStyle: _ts18),
    mergeResult: const VFormHeaderStyle(
      titleStyle: _ts18,
      subtitleStyle: _ts14,
      padding: _ei8,
    ),
    nullFields: [(s) => s.titleStyle, (s) => s.subtitleStyle, (s) => s.padding],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VFormHeaderStyle(
      titleStyle: _ts14,
      subtitleStyle: _ts14,
      padding: _ei16,
    ),
  );

  _contract<VFormFooterStyle>(
    name: 'VFormFooterStyle',
    empty: const VFormFooterStyle(),
    a: const VFormFooterStyle(padding: _ei8, spacing: 8),
    b: const VFormFooterStyle(spacing: 16),
    mergeResult: const VFormFooterStyle(padding: _ei8, spacing: 16),
    nullFields: [(s) => s.padding, (s) => s.spacing],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VFormFooterStyle(padding: _ei16, spacing: 8),
  );

  _contract<VLabelStyle>(
    name: 'VLabelStyle',
    empty: const VLabelStyle(),
    a: const VLabelStyle(
      foregroundColor: _black,
      textStyle: _ts14,
      requiredColor: _red,
    ),
    b: const VLabelStyle(requiredColor: _orange),
    mergeResult: const VLabelStyle(
      foregroundColor: _black,
      textStyle: _ts14,
      requiredColor: _orange,
    ),
    nullFields: [
      (s) => s.foregroundColor,
      (s) => s.textStyle,
      (s) => s.requiredColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(textStyle: _ts18),
    copyWithResult: const VLabelStyle(
      foregroundColor: _black,
      textStyle: _ts18,
      requiredColor: _red,
    ),
  );

  _contract<VLinkStyle>(
    name: 'VLinkStyle',
    empty: const VLinkStyle(),
    a: const VLinkStyle(
      foregroundColor: _blue,
      hoverColor: _cyan,
      visitedColor: _magenta,
      textStyle: _ts14,
    ),
    b: const VLinkStyle(hoverColor: _red),
    mergeResult: const VLinkStyle(
      foregroundColor: _blue,
      hoverColor: _red,
      visitedColor: _magenta,
      textStyle: _ts14,
    ),
    nullFields: [
      (s) => s.foregroundColor,
      (s) => s.hoverColor,
      (s) => s.visitedColor,
      (s) => s.textStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(visitedColor: _gray),
    copyWithResult: const VLinkStyle(
      foregroundColor: _blue,
      hoverColor: _cyan,
      visitedColor: _gray,
      textStyle: _ts14,
    ),
  );

  // =========================================================================
  // DATA DISPLAY (12)
  // =========================================================================
  _contract<VAvatarStyle>(
    name: 'VAvatarStyle',
    empty: const VAvatarStyle(),
    a: const VAvatarStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
    ),
    b: const VAvatarStyle(borderRadius: _br8),
    mergeResult: const VAvatarStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(backgroundColor: _blue),
    copyWithResult: const VAvatarStyle(
      backgroundColor: _blue,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
    ),
  );

  _contract<VBadgeStyle>(
    name: 'VBadgeStyle',
    empty: const VBadgeStyle(),
    a: const VBadgeStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderRadius: _br4,
      textStyle: _ts14,
    ),
    b: const VBadgeStyle(backgroundColor: _green),
    mergeResult: const VBadgeStyle(
      backgroundColor: _green,
      foregroundColor: _white,
      borderRadius: _br4,
      textStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.textStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(textStyle: _ts18),
    copyWithResult: const VBadgeStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderRadius: _br4,
      textStyle: _ts18,
    ),
  );

  _contract<VChipStyle>(
    name: 'VChipStyle',
    empty: const VChipStyle(),
    a: const VChipStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      deleteIconColor: _gray,
    ),
    b: const VChipStyle(deleteIconColor: _red),
    mergeResult: const VChipStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      deleteIconColor: _red,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.deleteIconColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VChipStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
      deleteIconColor: _gray,
    ),
  );

  _contract<VDividerStyle>(
    name: 'VDividerStyle',
    empty: const VDividerStyle(),
    a: const VDividerStyle(color: _gray, thickness: 1, indent: 16),
    b: const VDividerStyle(thickness: 2),
    mergeResult: const VDividerStyle(color: _gray, thickness: 2, indent: 16),
    nullFields: [(s) => s.color, (s) => s.thickness, (s) => s.indent],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(indent: 24),
    copyWithResult: const VDividerStyle(color: _gray, thickness: 1, indent: 24),
  );

  _contract<VImageStyle>(
    name: 'VImageStyle',
    empty: const VImageStyle(),
    a: const VImageStyle(borderRadius: _br4, backgroundColor: _gray),
    b: const VImageStyle(backgroundColor: _white),
    mergeResult: const VImageStyle(borderRadius: _br4, backgroundColor: _white),
    nullFields: [(s) => s.borderRadius, (s) => s.backgroundColor],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VImageStyle(
      borderRadius: _br8,
      backgroundColor: _gray,
    ),
  );

  _contract<VTooltipStyle>(
    name: 'VTooltipStyle',
    empty: const VTooltipStyle(),
    a: const VTooltipStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
    ),
    b: const VTooltipStyle(backgroundColor: _gray),
    mergeResult: const VTooltipStyle(
      backgroundColor: _gray,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VTooltipStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
    ),
  );

  _contract<VHoverCardStyle>(
    name: 'VHoverCardStyle',
    empty: const VHoverCardStyle(),
    a: const VHoverCardStyle(
      backgroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
    ),
    b: const VHoverCardStyle(elevation: 8),
    mergeResult: const VHoverCardStyle(
      backgroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VHoverCardStyle(
      backgroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei16,
    ),
  );

  _contract<VTableStyle>(
    name: 'VTableStyle',
    empty: const VTableStyle(),
    a: const VTableStyle(
      headerBackgroundColor: _gray,
      headerForegroundColor: _black,
      rowBackgroundColor: _white,
      borderColor: _gray,
      cellPadding: _ei8,
      headerTextStyle: _ts14,
    ),
    b: const VTableStyle(headerBackgroundColor: _blue),
    mergeResult: const VTableStyle(
      headerBackgroundColor: _blue,
      headerForegroundColor: _black,
      rowBackgroundColor: _white,
      borderColor: _gray,
      cellPadding: _ei8,
      headerTextStyle: _ts14,
    ),
    nullFields: [
      (s) => s.headerBackgroundColor,
      (s) => s.headerForegroundColor,
      (s) => s.rowBackgroundColor,
      (s) => s.borderColor,
      (s) => s.cellPadding,
      (s) => s.headerTextStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(cellPadding: _ei16),
    copyWithResult: const VTableStyle(
      headerBackgroundColor: _gray,
      headerForegroundColor: _black,
      rowBackgroundColor: _white,
      borderColor: _gray,
      cellPadding: _ei16,
      headerTextStyle: _ts14,
    ),
  );

  _contract<VListTileStyle>(
    name: 'VListTileStyle',
    empty: const VListTileStyle(),
    a: const VListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _blue,
      borderRadius: _br4,
      padding: _ei8,
      titleStyle: _ts14,
      subtitleStyle: _ts14,
      leadingWidth: 24,
      leadingGap: 8,
      trailingGap: 8,
      minHeight: 48,
    ),
    b: const VListTileStyle(selectedColor: _green, minHeight: 64),
    mergeResult: const VListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _green,
      borderRadius: _br4,
      padding: _ei8,
      titleStyle: _ts14,
      subtitleStyle: _ts14,
      leadingWidth: 24,
      leadingGap: 8,
      trailingGap: 8,
      minHeight: 64,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.selectedColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.titleStyle,
      (s) => s.subtitleStyle,
      (s) => s.leadingWidth,
      (s) => s.leadingGap,
      (s) => s.trailingGap,
      (s) => s.minHeight,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(titleStyle: _ts18, leadingGap: 12),
    copyWithResult: const VListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      selectedColor: _blue,
      borderRadius: _br4,
      padding: _ei8,
      titleStyle: _ts18,
      subtitleStyle: _ts14,
      leadingWidth: 24,
      leadingGap: 12,
      trailingGap: 8,
      minHeight: 48,
    ),
  );

  _contract<VCheckListTileStyle>(
    name: 'VCheckListTileStyle',
    empty: const VCheckListTileStyle(),
    a: const VCheckListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      activeColor: _blue,
    ),
    b: const VCheckListTileStyle(activeColor: _green),
    mergeResult: const VCheckListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      activeColor: _green,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.activeColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VCheckListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei16,
      activeColor: _blue,
    ),
  );

  _contract<VSwitchListTileStyle>(
    name: 'VSwitchListTileStyle',
    empty: const VSwitchListTileStyle(),
    a: const VSwitchListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      activeColor: _green,
    ),
    b: const VSwitchListTileStyle(activeColor: _red),
    mergeResult: const VSwitchListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      activeColor: _red,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.activeColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VSwitchListTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br8,
      padding: _ei8,
      activeColor: _green,
    ),
  );

  _contract<VSettingTileStyle>(
    name: 'VSettingTileStyle',
    empty: const VSettingTileStyle(),
    a: const VSettingTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
    ),
    b: const VSettingTileStyle(backgroundColor: _gray),
    mergeResult: const VSettingTileStyle(
      backgroundColor: _gray,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VSettingTileStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      padding: _ei16,
    ),
  );

  // =========================================================================
  // FEEDBACK (9)
  // =========================================================================
  _contract<VAlertStyle>(
    name: 'VAlertStyle',
    empty: const VAlertStyle(),
    a: const VAlertStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      iconColor: _yellow,
      titleStyle: _ts14,
    ),
    b: const VAlertStyle(iconColor: _blue),
    mergeResult: const VAlertStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      iconColor: _blue,
      titleStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.iconColor,
      (s) => s.titleStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(titleStyle: _ts18),
    copyWithResult: const VAlertStyle(
      backgroundColor: _red,
      foregroundColor: _white,
      borderColor: _black,
      borderRadius: _br4,
      padding: _ei8,
      iconColor: _yellow,
      titleStyle: _ts18,
    ),
  );

  _contract<VAlertDialogStyle>(
    name: 'VAlertDialogStyle',
    empty: const VAlertDialogStyle(),
    a: const VAlertDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 4)],
      padding: _ei8,
      titleStyle: _ts14,
    ),
    b: const VAlertDialogStyle(shadows: [BoxShadow(blurRadius: 12)]),
    mergeResult: const VAlertDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 12)],
      padding: _ei8,
      titleStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.shadows,
      (s) => s.padding,
      (s) => s.titleStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VAlertDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 4)],
      padding: _ei16,
      titleStyle: _ts14,
    ),
  );

  _contract<VDialogStyle>(
    name: 'VDialogStyle',
    empty: const VDialogStyle(),
    a: const VDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 4)],
      padding: _ei8,
      titleStyle: _ts14,
    ),
    b: const VDialogStyle(shadows: [BoxShadow(blurRadius: 12)]),
    mergeResult: const VDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 12)],
      padding: _ei8,
      titleStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.shadows,
      (s) => s.padding,
      (s) => s.titleStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(titleStyle: _ts18),
    copyWithResult: const VDialogStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderRadius: _br4,
      shadows: [BoxShadow(blurRadius: 4)],
      padding: _ei8,
      titleStyle: _ts18,
    ),
  );

  _contract<VToastStyle>(
    name: 'VToastStyle',
    empty: const VToastStyle(),
    a: const VToastStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
    ),
    b: const VToastStyle(backgroundColor: _gray),
    mergeResult: const VToastStyle(
      backgroundColor: _gray,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(textStyle: _ts18),
    copyWithResult: const VToastStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts18,
    ),
  );

  _contract<VSnackbarStyle>(
    name: 'VSnackbarStyle',
    empty: const VSnackbarStyle(),
    a: const VSnackbarStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      actionColor: _blue,
    ),
    b: const VSnackbarStyle(actionColor: _green),
    mergeResult: const VSnackbarStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei8,
      textStyle: _ts14,
      actionColor: _green,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.actionColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VSnackbarStyle(
      backgroundColor: _black,
      foregroundColor: _white,
      borderRadius: _br4,
      padding: _ei16,
      textStyle: _ts14,
      actionColor: _blue,
    ),
  );

  _contract<VProgressStyle>(
    name: 'VProgressStyle',
    empty: const VProgressStyle(),
    a: const VProgressStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      borderRadius: _br4,
      trackHeight: 4,
    ),
    b: const VProgressStyle(trackHeight: 8),
    mergeResult: const VProgressStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      borderRadius: _br4,
      trackHeight: 8,
    ),
    nullFields: [
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.borderRadius,
      (s) => s.trackHeight,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(activeColor: _green),
    copyWithResult: const VProgressStyle(
      activeColor: _green,
      inactiveColor: _gray,
      borderRadius: _br4,
      trackHeight: 4,
    ),
  );

  _contract<VSkeletonStyle>(
    name: 'VSkeletonStyle',
    empty: const VSkeletonStyle(),
    a: const VSkeletonStyle(
      baseColor: _gray,
      highlightColor: _white,
      borderRadius: _br4,
    ),
    b: const VSkeletonStyle(highlightColor: _yellow),
    mergeResult: const VSkeletonStyle(
      baseColor: _gray,
      highlightColor: _yellow,
      borderRadius: _br4,
    ),
    nullFields: [
      (s) => s.baseColor,
      (s) => s.highlightColor,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(baseColor: _black),
    copyWithResult: const VSkeletonStyle(
      baseColor: _black,
      highlightColor: _white,
      borderRadius: _br4,
    ),
  );

  _contract<VBackdropStyle>(
    name: 'VBackdropStyle',
    empty: const VBackdropStyle(),
    a: const VBackdropStyle(color: _black),
    b: const VBackdropStyle(color: _gray),
    mergeResult: const VBackdropStyle(color: _gray),
    nullFields: [(s) => s.color],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(color: _white),
    copyWithResult: const VBackdropStyle(color: _white),
  );

  _contract<VLoadingSpinnerStyle>(
    name: 'VLoadingSpinnerStyle',
    empty: const VLoadingSpinnerStyle(),
    a: const VLoadingSpinnerStyle(color: _blue, strokeWidth: 2),
    b: const VLoadingSpinnerStyle(strokeWidth: 4),
    mergeResult: const VLoadingSpinnerStyle(color: _blue, strokeWidth: 4),
    nullFields: [(s) => s.color, (s) => s.strokeWidth],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(color: _red),
    copyWithResult: const VLoadingSpinnerStyle(color: _red, strokeWidth: 2),
  );

  // =========================================================================
  // SURFACES (4)
  // =========================================================================
  _contract<VCardStyle>(
    name: 'VCardStyle',
    empty: const VCardStyle(),
    a: const VCardStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
    ),
    b: const VCardStyle(elevation: 8),
    mergeResult: const VCardStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VCardStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei16,
    ),
  );

  _contract<VSheetStyle>(
    name: 'VSheetStyle',
    empty: const VSheetStyle(),
    a: const VSheetStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
    ),
    b: const VSheetStyle(padding: _ei16),
    mergeResult: const VSheetStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei16,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VSheetStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br8,
      padding: _ei8,
    ),
  );

  _contract<VAccordionStyle>(
    name: 'VAccordionStyle',
    empty: const VAccordionStyle(),
    a: const VAccordionStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
      headerPadding: _ei16,
      iconColor: _blue,
    ),
    b: const VAccordionStyle(iconColor: _red),
    mergeResult: const VAccordionStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
      headerPadding: _ei16,
      iconColor: _red,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
      (s) => s.headerPadding,
      (s) => s.iconColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(headerPadding: _ei8),
    copyWithResult: const VAccordionStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
      headerPadding: _ei8,
      iconColor: _blue,
    ),
  );

  _contract<VPopoverStyle>(
    name: 'VPopoverStyle',
    empty: const VPopoverStyle(),
    a: const VPopoverStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
    ),
    b: const VPopoverStyle(elevation: 8),
    mergeResult: const VPopoverStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderColor: _black),
    copyWithResult: const VPopoverStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _black,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
    ),
  );

  // =========================================================================
  // NAVIGATION (10)
  // =========================================================================
  _contract<VAppBarStyle>(
    name: 'VAppBarStyle',
    empty: const VAppBarStyle(),
    a: const VAppBarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      elevation: 2,
      padding: _ei8,
      titleStyle: _ts14,
    ),
    b: const VAppBarStyle(elevation: 4),
    mergeResult: const VAppBarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      elevation: 4,
      padding: _ei8,
      titleStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.elevation,
      (s) => s.padding,
      (s) => s.titleStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(titleStyle: _ts18),
    copyWithResult: const VAppBarStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      elevation: 2,
      padding: _ei8,
      titleStyle: _ts18,
    ),
  );

  _contract<VBottomNavStyle>(
    name: 'VBottomNavStyle',
    empty: const VBottomNavStyle(),
    a: const VBottomNavStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeColor: _blue,
      inactiveColor: _gray,
      borderColor: _gray,
      elevation: 4,
    ),
    b: const VBottomNavStyle(activeColor: _green),
    mergeResult: const VBottomNavStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeColor: _green,
      inactiveColor: _gray,
      borderColor: _gray,
      elevation: 4,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.borderColor,
      (s) => s.elevation,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(elevation: 0),
    copyWithResult: const VBottomNavStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeColor: _blue,
      inactiveColor: _gray,
      borderColor: _gray,
      elevation: 0,
    ),
  );

  _contract<VTabsStyle>(
    name: 'VTabsStyle',
    empty: const VTabsStyle(),
    a: const VTabsStyle(
      backgroundColor: _white,
      activeColor: _blue,
      inactiveColor: _gray,
      indicatorColor: _blue,
      indicatorHeight: 2,
      padding: _ei8,
      textStyle: _ts14,
      selectedTextStyle: _ts14,
    ),
    b: const VTabsStyle(indicatorHeight: 4, selectedTextStyle: _ts18),
    mergeResult: const VTabsStyle(
      backgroundColor: _white,
      activeColor: _blue,
      inactiveColor: _gray,
      indicatorColor: _blue,
      indicatorHeight: 4,
      padding: _ei8,
      textStyle: _ts14,
      selectedTextStyle: _ts18,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.indicatorColor,
      (s) => s.indicatorHeight,
      (s) => s.padding,
      (s) => s.textStyle,
      (s) => s.selectedTextStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(activeColor: _green),
    copyWithResult: const VTabsStyle(
      backgroundColor: _white,
      activeColor: _green,
      inactiveColor: _gray,
      indicatorColor: _blue,
      indicatorHeight: 2,
      padding: _ei8,
      textStyle: _ts14,
      selectedTextStyle: _ts14,
    ),
  );

  _contract<VBreadcrumbStyle>(
    name: 'VBreadcrumbStyle',
    empty: const VBreadcrumbStyle(),
    a: const VBreadcrumbStyle(
      foregroundColor: _black,
      activeColor: _blue,
      separatorColor: _gray,
      textStyle: _ts14,
    ),
    b: const VBreadcrumbStyle(separatorColor: _red),
    mergeResult: const VBreadcrumbStyle(
      foregroundColor: _black,
      activeColor: _blue,
      separatorColor: _red,
      textStyle: _ts14,
    ),
    nullFields: [
      (s) => s.foregroundColor,
      (s) => s.activeColor,
      (s) => s.separatorColor,
      (s) => s.textStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(textStyle: _ts18),
    copyWithResult: const VBreadcrumbStyle(
      foregroundColor: _black,
      activeColor: _blue,
      separatorColor: _gray,
      textStyle: _ts18,
    ),
  );

  _contract<VPaginationStyle>(
    name: 'VPaginationStyle',
    empty: const VPaginationStyle(),
    a: const VPaginationStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeBackgroundColor: _blue,
      activeForegroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
    ),
    b: const VPaginationStyle(activeBackgroundColor: _green),
    mergeResult: const VPaginationStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeBackgroundColor: _green,
      activeForegroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.activeBackgroundColor,
      (s) => s.activeForegroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VPaginationStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      activeBackgroundColor: _blue,
      activeForegroundColor: _white,
      borderColor: _gray,
      borderRadius: _br8,
    ),
  );

  _contract<VPageIndicatorThemeStyle>(
    name: 'VPageIndicatorThemeStyle',
    empty: const VPageIndicatorThemeStyle(),
    a: const VPageIndicatorThemeStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      activeSize: 10,
      inactiveSize: 6,
    ),
    b: const VPageIndicatorThemeStyle(activeSize: 14),
    mergeResult: const VPageIndicatorThemeStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      activeSize: 14,
      inactiveSize: 6,
    ),
    nullFields: [
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.activeSize,
      (s) => s.inactiveSize,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(inactiveSize: 8),
    copyWithResult: const VPageIndicatorThemeStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      activeSize: 10,
      inactiveSize: 8,
    ),
  );

  _contract<VStepperStyle>(
    name: 'VStepperStyle',
    empty: const VStepperStyle(),
    a: const VStepperStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      completedColor: _green,
      errorColor: _red,
      connectorColor: _gray,
    ),
    b: const VStepperStyle(completedColor: _cyan),
    mergeResult: const VStepperStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      completedColor: _cyan,
      errorColor: _red,
      connectorColor: _gray,
    ),
    nullFields: [
      (s) => s.activeColor,
      (s) => s.inactiveColor,
      (s) => s.completedColor,
      (s) => s.errorColor,
      (s) => s.connectorColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(errorColor: _orange),
    copyWithResult: const VStepperStyle(
      activeColor: _blue,
      inactiveColor: _gray,
      completedColor: _green,
      errorColor: _orange,
      connectorColor: _gray,
    ),
  );

  _contract<VDrawerStyle>(
    name: 'VDrawerStyle',
    empty: const VDrawerStyle(),
    a: const VDrawerStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      elevation: 8,
      borderRadius: _br4,
    ),
    b: const VDrawerStyle(elevation: 16),
    mergeResult: const VDrawerStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      elevation: 16,
      borderRadius: _br4,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.elevation,
      (s) => s.borderRadius,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VDrawerStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      elevation: 8,
      borderRadius: _br8,
    ),
  );

  _contract<VMenuStyle>(
    name: 'VMenuStyle',
    empty: const VMenuStyle(),
    a: const VMenuStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
      itemPadding: _ei16,
    ),
    b: const VMenuStyle(elevation: 8),
    mergeResult: const VMenuStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
      itemPadding: _ei16,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.padding,
      (s) => s.itemPadding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(itemPadding: _ei8),
    copyWithResult: const VMenuStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 4,
      padding: _ei8,
      itemPadding: _ei8,
    ),
  );

  _contract<VCommandStyle>(
    name: 'VCommandStyle',
    empty: const VCommandStyle(),
    a: const VCommandStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
      inputTextStyle: _ts14,
    ),
    b: const VCommandStyle(elevation: 16),
    mergeResult: const VCommandStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 16,
      padding: _ei8,
      inputTextStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.foregroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.elevation,
      (s) => s.padding,
      (s) => s.inputTextStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(inputTextStyle: _ts18),
    copyWithResult: const VCommandStyle(
      backgroundColor: _white,
      foregroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      elevation: 8,
      padding: _ei8,
      inputTextStyle: _ts18,
    ),
  );

  // =========================================================================
  // LAYOUT (7)
  // =========================================================================
  _contract<VBoxStyle>(
    name: 'VBoxStyle',
    empty: const VBoxStyle(),
    a: const VBoxStyle(
      backgroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
    ),
    b: const VBoxStyle(backgroundColor: _black),
    mergeResult: const VBoxStyle(
      backgroundColor: _black,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei8,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.borderColor,
      (s) => s.borderRadius,
      (s) => s.padding,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(padding: _ei16),
    copyWithResult: const VBoxStyle(
      backgroundColor: _white,
      borderColor: _gray,
      borderRadius: _br4,
      padding: _ei16,
    ),
  );

  _contract<VStackStyle>(
    name: 'VStackStyle',
    empty: const VStackStyle(),
    a: const VStackStyle(spacing: 8),
    b: const VStackStyle(spacing: 16),
    mergeResult: const VStackStyle(spacing: 16),
    nullFields: [(s) => s.spacing],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(spacing: 24),
    copyWithResult: const VStackStyle(spacing: 24),
  );

  _contract<VGridStyle>(
    name: 'VGridStyle',
    empty: const VGridStyle(),
    a: const VGridStyle(spacing: 8),
    b: const VGridStyle(spacing: 16),
    mergeResult: const VGridStyle(spacing: 16),
    nullFields: [(s) => s.spacing],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(spacing: 24),
    copyWithResult: const VGridStyle(spacing: 24),
  );

  _contract<VSectionStyle>(
    name: 'VSectionStyle',
    empty: const VSectionStyle(),
    a: const VSectionStyle(
      backgroundColor: _white,
      padding: _ei8,
      titleStyle: _ts14,
    ),
    b: const VSectionStyle(backgroundColor: _gray),
    mergeResult: const VSectionStyle(
      backgroundColor: _gray,
      padding: _ei8,
      titleStyle: _ts14,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.padding,
      (s) => s.titleStyle,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(titleStyle: _ts18),
    copyWithResult: const VSectionStyle(
      backgroundColor: _white,
      padding: _ei8,
      titleStyle: _ts18,
    ),
  );

  _contract<VScrollAreaStyle>(
    name: 'VScrollAreaStyle',
    empty: const VScrollAreaStyle(),
    a: const VScrollAreaStyle(
      scrollbarColor: _gray,
      scrollbarRadius: _br4,
      scrollbarThickness: 6,
    ),
    b: const VScrollAreaStyle(scrollbarThickness: 8),
    mergeResult: const VScrollAreaStyle(
      scrollbarColor: _gray,
      scrollbarRadius: _br4,
      scrollbarThickness: 8,
    ),
    nullFields: [
      (s) => s.scrollbarColor,
      (s) => s.scrollbarRadius,
      (s) => s.scrollbarThickness,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(scrollbarColor: _blue),
    copyWithResult: const VScrollAreaStyle(
      scrollbarColor: _blue,
      scrollbarRadius: _br4,
      scrollbarThickness: 6,
    ),
  );

  _contract<VCarouselStyle>(
    name: 'VCarouselStyle',
    empty: const VCarouselStyle(),
    a: const VCarouselStyle(
      backgroundColor: _white,
      borderRadius: _br4,
      indicatorActiveColor: _blue,
      indicatorInactiveColor: _gray,
    ),
    b: const VCarouselStyle(indicatorActiveColor: _green),
    mergeResult: const VCarouselStyle(
      backgroundColor: _white,
      borderRadius: _br4,
      indicatorActiveColor: _green,
      indicatorInactiveColor: _gray,
    ),
    nullFields: [
      (s) => s.backgroundColor,
      (s) => s.borderRadius,
      (s) => s.indicatorActiveColor,
      (s) => s.indicatorInactiveColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(borderRadius: _br8),
    copyWithResult: const VCarouselStyle(
      backgroundColor: _white,
      borderRadius: _br8,
      indicatorActiveColor: _blue,
      indicatorInactiveColor: _gray,
    ),
  );

  _contract<VResizableStyle>(
    name: 'VResizableStyle',
    empty: const VResizableStyle(),
    a: const VResizableStyle(
      handleColor: _gray,
      handleSize: 8,
      borderColor: _black,
    ),
    b: const VResizableStyle(handleSize: 12),
    mergeResult: const VResizableStyle(
      handleColor: _gray,
      handleSize: 12,
      borderColor: _black,
    ),
    nullFields: [
      (s) => s.handleColor,
      (s) => s.handleSize,
      (s) => s.borderColor,
    ],
    merge: (s, o) => s.merge(o),
    copyWithOverride: (s) => s.copyWith(handleColor: _blue),
    copyWithResult: const VResizableStyle(
      handleColor: _blue,
      handleSize: 8,
      borderColor: _black,
    ),
  );
}
