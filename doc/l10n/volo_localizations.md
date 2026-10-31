# volo_localizations

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VoloLocalizations

Strings volo_flutter_ui widgets show or announce.

Subclass it to translate. [VoloLocalizationsEn] ships with the library;
[VTheme.localizations] picks the instance the widgets read.

```dart
VTheme(
  data: VThemeData.light(),
  localizations: MyLocalizations(),
  child: MyApp(),
)
```

See also:
* [VoloLocalizationsEn] for the default English implementation
* [MaterialLocalizations] for a similar pattern in Flutter Material

### Constructors

#### `VoloLocalizations`

Creates a localizations instance.

### Members

| Member | Description |
|---|---|
| `String get noData` | Empty state text for data views. ('No data') |
| `String get noResults` | Empty search result text. ('No results found') |
| `String get noOptions` | No options available text. ('No options') |
| `String get loading` | Loading indicator label. ('Loading...') |
| `String get searchPlaceholder` | Search placeholder. ('Search...') |
| `String get selectNoResults` | No search results in select. ('No results') |
| `String get selectNoOptions` | No options in select. ('No options') |
| `String get anteMeridiemAbbreviation` | AM period text. ('AM') |
| `String get postMeridiemAbbreviation` | PM period text. ('PM') |
| `String get dialogCancel` | Default cancel button text. ('Cancel') |
| `String get dialogConfirm` | Default confirm button text. ('Confirm') |
| `String get stepperPrevious` | Previous step button text. ('Previous') |
| `String get stepperNext` | Next step button text. ('Next') |
| `String get stepperComplete` | Final step button text. ('Complete') |
| `String get paginationPrevious` | Previous page text. ('Previous') |
| `String get paginationNext` | Next page text. ('Next') |
| `String get paginationNavigationLabel` | Navigation semantics label. ('Page navigation') |
| `String get breadcrumbLabel` | Breadcrumb semantics label. ('Breadcrumb') |
| `String get progressLoading` | Indeterminate progress semantics label. ('Loading...') |
| `String get tableNoData` | Empty table text. ('No data') |
| `String get commandNoResults` | Empty command palette text. ('No results') |
| `String get commandPlaceholder` | Command input placeholder. ('Search...') |
| `String get backTooltip` | Tooltip of the app bar back button. ('Back') |
| `String get drawerLabel` | Semantics label of a drawer. ('Navigation drawer') |
| `String get dialogLabel` | Semantics label of a dialog without a title. ('Dialog') |
| `String get dialogDismissLabel` | Barrier label that closes a dialog. ('Dismiss dialog') |
| `String get alertDialogDismissLabel` | Barrier label that closes an alert dialog. ('Dismiss alert dialog') |
| `String get dialogOk` | Default confirm button text of an alert dialog. ('OK') |
| `String get notificationLabel` | Semantics label of a toast or snackbar without one. ('Notification') |
| `String get backdropLabel` | Semantics label of a backdrop. ('Backdrop') |
| `String get sheetDismissLabel` | Barrier label that closes a sheet. ('Dismiss') |
| `String get popoverTriggerLabel` | Semantics label of a popover trigger. ('Open popover') |
| `String get popoverLabel` | Semantics label of a popover panel. ('Popover') |
| `String get hoverCardLabel` | Semantics label of a hover card panel. ('Hover card content') |
| `String get fabLabel` | Semantics label of a floating action button without a tooltip. ('Floating action button') |
| `String get requiredFieldLabel` | Semantics label of the required mark on a form field. ('Required field') |
| `String get chipDelete` | Semantics label of an input chip delete button. ('Delete') |
| `String get hoverCardHintTap` | Semantics hint of a hover card trigger that opens on tap. ('Tap to show additional information') |
| `String get hoverCardHintHover` | Semantics hint of a hover card trigger that opens on hover. ('Shows additional information on hover') |
| `String get clearTextLabel` | Semantics label of a text field clear button. ('Clear') |
| `String get showPasswordLabel` | Semantics label of the button that shows a password. ('Show password') |
| `String get hidePasswordLabel` | Semantics label of the button that hides a password. ('Hide password') |
| `String get paginationFirst` | Semantics label of the button that jumps to the first page. ('First page') |
| `String get paginationLast` | Semantics label of the button that jumps to the last page. ('Last page') |
| `String get alertCloseLabel` | Semantics label of the close button of an alert. ('Close') |
| `String nSelected(int n)` | Multiple selection label. ('3 selected') |
| `String autocompleteNoResults(String query)` | No results with query text. ('No results for "query"') |
| `String monthYear(int year, int month)` | Month-year header format. ('January 2026') |
| `String fullDate(int year, int month, int day)` | Full date format. ('January 15, 2026') |
| `String pageOf(int current, int total)` | Page indicator text. ('Page 1 of 10') |
| `String avatarGroupOverflow(int n)` | Overflow count label. ('+3 more') |
| `String avatarGroupLabel(int total)` | Group aria-label. ('5 avatars') |
| `String chipRemove(String label)` | Delete button semantics label. ('Remove React') |
| `String tableRowLabel(int n)` | Semantics label of a table row, counted from 1. ('Row 1') |
| `String autocompleteMinChars(int count)` | Hint shown while an autocomplete query is too short. ('Please enter at least 2 characters') |
| `String weekdayShort(int weekday)` | Short weekday name for the calendar header, 1 is Monday and 7 is Sunday. ('Mon') |
| `String time12Hour(int hour, int minute, {required bool isPm})` | Twelve-hour time of day text. ('2:30 PM') |
| `String stepperStepOf(int step, int total)` | Semantics label of a stepper step, counted from 1. ('Step 2 of 4') |
| `static VoloLocalizations of(BuildContext context)` | Retrieves the nearest [VoloLocalizations] from the widget tree. |
| `static VoloLocalizations? maybeOf(BuildContext context)` | Retrieves the nearest [VoloLocalizations], or null. |
