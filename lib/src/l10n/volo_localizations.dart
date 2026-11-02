import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_theme.dart';

/// Strings volo_flutter_ui widgets show or announce.
///
/// Subclass it to translate. [VoloLocalizationsEn] ships with the library;
/// [VTheme.localizations] picks the instance the widgets read.
///
/// ```dart
/// VTheme(
///   data: VThemeData.light(),
///   localizations: MyLocalizations(),
///   child: MyApp(),
/// )
/// ```
///
/// See also:
/// * [VoloLocalizationsEn] for the default English implementation
/// * [MaterialLocalizations] for a similar pattern in Flutter Material
abstract class VoloLocalizations {
  /// Creates a localizations instance.
  const VoloLocalizations();

  // -- Common ------------------------------------------------

  /// Empty state text for data views. ('No data')
  String get noData;

  /// Empty search result text. ('No results found')
  String get noResults;

  /// No options available text. ('No options')
  String get noOptions;

  /// Loading indicator label. ('Loading...')
  String get loading;

  /// Search placeholder. ('Search...')
  String get searchPlaceholder;

  // -- VSelect -----------------------------------------------

  /// Multiple selection label. ('3 selected')
  String nSelected(int n);

  /// No search results in select. ('No results')
  String get selectNoResults;

  /// No options in select. ('No options')
  String get selectNoOptions;

  // -- VAutocomplete -----------------------------------------

  /// No results with query text. ('No results for "query"')
  String autocompleteNoResults(String query);

  // -- VCalendar / VDatePicker -------------------------------

  /// Month-year header format. ('January 2026')
  String monthYear(int year, int month);

  /// Full date format. ('January 15, 2026')
  String fullDate(int year, int month, int day);

  /// AM period text. ('AM')
  String get anteMeridiemAbbreviation;

  /// PM period text. ('PM')
  String get postMeridiemAbbreviation;

  // -- VDialog -----------------------------------------------

  /// Default cancel button text. ('Cancel')
  String get dialogCancel;

  /// Default confirm button text. ('Confirm')
  String get dialogConfirm;

  // -- VStepper ----------------------------------------------

  /// Previous step button text. ('Previous')
  String get stepperPrevious;

  /// Next step button text. ('Next')
  String get stepperNext;

  /// Final step button text. ('Complete')
  String get stepperComplete;

  // -- VPagination -------------------------------------------

  /// Previous page text. ('Previous')
  String get paginationPrevious;

  /// Next page text. ('Next')
  String get paginationNext;

  /// Page indicator text. ('Page 1 of 10')
  String pageOf(int current, int total);

  /// Navigation semantics label. ('Page navigation')
  String get paginationNavigationLabel;

  // -- VAvatarGroup ------------------------------------------

  /// Overflow count label. ('+3 more')
  String avatarGroupOverflow(int n);

  /// Group aria-label. ('5 avatars')
  String avatarGroupLabel(int total);

  // -- VChip -------------------------------------------------

  /// Delete button semantics label. ('Remove React')
  String chipRemove(String label);

  // -- VBreadcrumb -------------------------------------------

  /// Breadcrumb semantics label. ('Breadcrumb')
  String get breadcrumbLabel;

  // -- VProgress ---------------------------------------------

  /// Indeterminate progress semantics label. ('Loading...')
  String get progressLoading;

  // -- VTable ------------------------------------------------

  /// Empty table text. ('No data')
  String get tableNoData;

  // -- VCommand ----------------------------------------------

  /// Empty command palette text. ('No results')
  String get commandNoResults;

  /// Command input placeholder. ('Search...')
  String get commandPlaceholder;

  // -- Semantics and tooltips ---------------------------------

  /// Tooltip of the app bar back button. ('Back')
  String get backTooltip;

  /// Semantics label of a drawer. ('Navigation drawer')
  String get drawerLabel;

  /// Semantics label of a dialog without a title. ('Dialog')
  String get dialogLabel;

  /// Barrier label that closes a dialog. ('Dismiss dialog')
  String get dialogDismissLabel;

  /// Barrier label that closes an alert dialog. ('Dismiss alert dialog')
  String get alertDialogDismissLabel;

  /// Default confirm button text of an alert dialog. ('OK')
  String get dialogOk;

  /// Semantics label of a toast or snackbar without one. ('Notification')
  String get notificationLabel;

  /// Semantics label of a backdrop. ('Backdrop')
  String get backdropLabel;

  /// Barrier label that closes a sheet. ('Dismiss')
  String get sheetDismissLabel;

  /// Semantics label of a popover trigger. ('Open popover')
  String get popoverTriggerLabel;

  /// Semantics label of a popover panel. ('Popover')
  String get popoverLabel;

  /// Semantics label of a hover card panel. ('Hover card content')
  String get hoverCardLabel;

  /// Semantics label of a floating action button without a tooltip. ('Floating action button')
  String get fabLabel;

  /// Semantics label of the required mark on a form field. ('Required field')
  String get requiredFieldLabel;

  /// Semantics label of an input chip delete button. ('Delete')
  String get chipDelete;

  /// Semantics label of a table row, counted from 1. ('Row 1')
  String tableRowLabel(int n);

  // -- data display and surfaces (added) ----

  /// Semantics hint of a hover card trigger that opens on tap. ('Tap to show additional information')
  String get hoverCardHintTap;

  /// Semantics hint of a hover card trigger that opens on hover. ('Shows additional information on hover')
  String get hoverCardHintHover;

  // -- inputs (added) ----

  /// Hint shown while an autocomplete query is too short. ('Please enter at least 2 characters')
  String autocompleteMinChars(int count);

  /// Short weekday name for the calendar header, 1 is Monday and 7 is Sunday. ('Mon')
  String weekdayShort(int weekday);

  /// Twelve-hour time of day text. ('2:30 PM')
  String time12Hour(int hour, int minute, {required bool isPm});

  /// Semantics label of a text field clear button. ('Clear')
  String get clearTextLabel;

  /// Semantics label of the button that shows a password. ('Show password')
  String get showPasswordLabel;

  /// Semantics label of the button that hides a password. ('Hide password')
  String get hidePasswordLabel;

  // -- navigation and feedback (added) ----

  /// Semantics label of the button that jumps to the first page. ('First page')
  String get paginationFirst;

  /// Semantics label of the button that jumps to the last page. ('Last page')
  String get paginationLast;

  /// Semantics label of a stepper step, counted from 1. ('Step 2 of 4')
  String stepperStepOf(int step, int total);

  /// Semantics label of the close button of an alert. ('Close')
  String get alertCloseLabel;

  // -- VDismissible --------------------------------------------

  /// Screen reader action and default background text of a dismissible row. ('Delete')
  String get dismissibleActionLabel;

  // -- Lookup ------------------------------------------------

  /// Retrieves the nearest [VoloLocalizations] from the widget tree.
  static VoloLocalizations of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<VTheme>();
    assert(widget != null, 'No VTheme found in context');
    return widget!.localizations;
  }

  /// Retrieves the nearest [VoloLocalizations], or null.
  static VoloLocalizations? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<VTheme>();
    return widget?.localizations;
  }
}
