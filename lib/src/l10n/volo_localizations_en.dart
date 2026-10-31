import 'volo_localizations.dart';

/// Default English implementation of [VoloLocalizations].
class VoloLocalizationsEn extends VoloLocalizations {
  /// Creates the English localizations.
  const VoloLocalizationsEn();

  // Common
  @override
  String get noData => 'No data';
  @override
  String get noResults => 'No results found';
  @override
  String get noOptions => 'No options';
  @override
  String get loading => 'Loading...';
  @override
  String get searchPlaceholder => 'Search...';

  // VSelect
  @override
  String nSelected(int n) => '$n selected';
  @override
  String get selectNoResults => 'No results';
  @override
  String get selectNoOptions => 'No options';

  // VAutocomplete
  @override
  String autocompleteNoResults(String query) =>
      query.isNotEmpty ? "No results for '$query'" : 'No results found';

  // VCalendar / VDatePicker
  @override
  String monthYear(int year, int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month - 1]} $year';
  }

  @override
  String fullDate(int year, int month, int day) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month - 1]} $day, $year';
  }

  @override
  String get anteMeridiemAbbreviation => 'AM';
  @override
  String get postMeridiemAbbreviation => 'PM';

  // VDialog
  @override
  String get dialogCancel => 'Cancel';
  @override
  String get dialogConfirm => 'Confirm';

  // VStepper
  @override
  String get stepperPrevious => 'Previous';
  @override
  String get stepperNext => 'Next';
  @override
  String get stepperComplete => 'Complete';

  // VPagination
  @override
  String get paginationPrevious => 'Previous';
  @override
  String get paginationNext => 'Next';
  @override
  String pageOf(int current, int total) => 'Page $current of $total';
  @override
  String get paginationNavigationLabel => 'Page navigation';

  // VAvatarGroup
  @override
  String avatarGroupOverflow(int n) => '+$n more';
  @override
  String avatarGroupLabel(int total) => '$total avatars';

  // VChip
  @override
  String chipRemove(String label) => 'Remove $label';

  // VBreadcrumb
  @override
  String get breadcrumbLabel => 'Breadcrumb';

  // VProgress
  @override
  String get progressLoading => 'Loading...';

  // VTable
  @override
  String get tableNoData => 'No data';

  // VCommand
  @override
  String get commandNoResults => 'No results';
  @override
  String get commandPlaceholder => 'Search...';

  // Semantics and tooltips
  @override
  String get backTooltip => 'Back';
  @override
  String get drawerLabel => 'Navigation drawer';
  @override
  String get dialogLabel => 'Dialog';
  @override
  String get dialogDismissLabel => 'Dismiss dialog';
  @override
  String get alertDialogDismissLabel => 'Dismiss alert dialog';
  @override
  String get dialogOk => 'OK';
  @override
  String get notificationLabel => 'Notification';
  @override
  String get backdropLabel => 'Backdrop';
  @override
  String get sheetDismissLabel => 'Dismiss';
  @override
  String get popoverTriggerLabel => 'Open popover';
  @override
  String get popoverLabel => 'Popover';
  @override
  String get hoverCardLabel => 'Hover card content';
  @override
  String get fabLabel => 'Floating action button';
  @override
  String get requiredFieldLabel => 'Required field';
  @override
  String get chipDelete => 'Delete';
  @override
  String tableRowLabel(int n) => 'Row $n';

  // -- data display and surfaces (added) ----
  @override
  String get hoverCardHintTap => 'Tap to show additional information';
  @override
  String get hoverCardHintHover => 'Shows additional information on hover';

  // -- inputs (added) ----
  @override
  String autocompleteMinChars(int count) =>
      'Please enter at least $count characters';
  @override
  String weekdayShort(int weekday) => const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ][(weekday - 1) % 7];
  @override
  String time12Hour(int hour, int minute, {required bool isPm}) =>
      '$hour:${minute.toString().padLeft(2, '0')} ${isPm ? postMeridiemAbbreviation : anteMeridiemAbbreviation}';
  @override
  String get clearTextLabel => 'Clear';
  @override
  String get showPasswordLabel => 'Show password';
  @override
  String get hidePasswordLabel => 'Hide password';

  // navigation and feedback (added)
  @override
  String get paginationFirst => 'First page';
  @override
  String get paginationLast => 'Last page';
  @override
  String stepperStepOf(int step, int total) => 'Step $step of $total';
  @override
  String get alertCloseLabel => 'Close';
}
