# VTabs

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTabs

A tabbed interface for switching views.

{@category Navigation}

## Overview

[VTabs] pairs a row or column of tabs with the content of the selected one.
It keeps the selected index itself and reports changes through [onChanged].

## Basic Usage

```dart
VTabs(
  tabs: [
    VTab(label: Text('Profile'), content: ProfileView()),
    VTab(label: Text('Settings'), content: SettingsView()),
  ],
)
```

## Variants

- [VTabs.new] - Default tabs with subtle background highlight
- [VTabs.pills] - Pill-shaped selected tab indicator
- [VTabs.underline] - Underline style tab indicator

## Tabs with icons

```dart
VTabs(
  tabs: [
    VTab(
      label: Text('Home'),
      icon: Icon(Icons.home),
      content: HomeView(),
    ),
    VTab(
      label: Text('Search'),
      icon: Icon(Icons.search),
      content: SearchView(),
    ),
    VTab(
      label: Text('Settings'),
      icon: Icon(Icons.settings),
      content: SettingsView(),
    ),
  ],
)
```

## Pills style tabs

```dart
VTabs.pills(
  tabs: [
    VTab(label: Text('Day'), content: DayView()),
    VTab(label: Text('Week'), content: WeekView()),
    VTab(label: Text('Month'), content: MonthView()),
  ],
)
```

## Underline style tabs

```dart
VTabs.underline(
  tabs: [
    VTab(label: Text('Overview'), content: OverviewTab()),
    VTab(label: Text('Analytics'), content: AnalyticsTab()),
    VTab(label: Text('Reports'), content: ReportsTab()),
  ],
)
```

## Controlled tabs with callback

```dart
VTabs(
  initialIndex: 1,
  onChanged: (index) => print('Selected tab: $index'),
  tabs: [
    VTab(label: Text('Tab 1'), content: Content1()),
    VTab(label: Text('Tab 2'), content: Content2()),
  ],
)
```

## Scrollable tabs for many items

```dart
VTabs(
  isScrollable: true,
  tabs: List.generate(
    10,
    (i) => VTab(label: Text('Tab ${i + 1}'), content: Text('Content $i')),
  ),
)
```

## Custom styling

```dart
VTabs(
  backgroundColor: Colors.grey.shade100,
  selectedColor: Colors.blue,
  unselectedColor: Colors.grey,
  padding: EdgeInsets.symmetric(horizontal: 16),
  tabPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  tabs: [...],
)
```

See also:

- [VTab], for individual tab items
- [VBottomNav], for bottom navigation
- [VAppBar], for top app bar with tabs in bottom slot

### Constructors

#### `VTabs`

Creates tabs whose selected tab is filled with the card color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `tabs` | `List<VTab>` |  | yes | Tabs to show, in order. |
| `initialIndex` | `int` | `0` |  | Index selected first, clamped to the tab range. |
| `onChanged` | `void Function(int)?` |  |  | Called with the new index when the selection changes by tap or key. |
| `isScrollable` | `bool` | `false` |  | Whether the tab bar scrolls instead of sharing the width evenly. |
| `orientation` | `Axis` | `Axis.horizontal` |  | Direction of the tab bar; vertical puts a column at the start. |
| `backgroundColor` | `Color?` |  |  | Fill color of the tab bar. |
| `selectedColor` | `Color?` |  |  | Color of the selected tab's fill or text, depending on the variant. |
| `unselectedColor` | `Color?` |  |  | Text color of the unselected tabs. |
| `indicatorColor` | `Color?` |  |  | Color of the underline in [VTabs.underline]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the tab bar. |
| `tabPadding` | `EdgeInsetsGeometry?` |  |  | Space inside each tab. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the tab bar. |
| `indicatorBorderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the selected tab's fill. |
| `indicatorBorder` | `BoxBorder?` |  |  | Border drawn around the selected tab. |
| `style` | `VTabsStyle?` |  |  | Overrides for colors, padding, label text styles and the underline. |

#### `VTabs.pills`

Creates tabs whose selected tab is a primary-colored pill.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `tabs` | `List<VTab>` |  | yes | Tabs to show, in order. |
| `initialIndex` | `int` | `0` |  | Index selected first, clamped to the tab range. |
| `onChanged` | `void Function(int)?` |  |  | Called with the new index when the selection changes by tap or key. |
| `isScrollable` | `bool` | `false` |  | Whether the tab bar scrolls instead of sharing the width evenly. |
| `orientation` | `Axis` | `Axis.horizontal` |  | Direction of the tab bar; vertical puts a column at the start. |
| `backgroundColor` | `Color?` |  |  | Fill color of the tab bar. |
| `selectedColor` | `Color?` |  |  | Color of the selected tab's fill or text, depending on the variant. |
| `unselectedColor` | `Color?` |  |  | Text color of the unselected tabs. |
| `indicatorColor` | `Color?` |  |  | Color of the underline in [VTabs.underline]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the tab bar. |
| `tabPadding` | `EdgeInsetsGeometry?` |  |  | Space inside each tab. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the tab bar. |
| `indicatorBorderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the selected tab's fill. |
| `indicatorBorder` | `BoxBorder?` |  |  | Border drawn around the selected tab. |
| `style` | `VTabsStyle?` |  |  | Overrides for colors, padding, label text styles and the underline. |

#### `VTabs.underline`

Creates tabs whose selected tab has an underline.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `tabs` | `List<VTab>` |  | yes | Tabs to show, in order. |
| `initialIndex` | `int` | `0` |  | Index selected first, clamped to the tab range. |
| `onChanged` | `void Function(int)?` |  |  | Called with the new index when the selection changes by tap or key. |
| `isScrollable` | `bool` | `false` |  | Whether the tab bar scrolls instead of sharing the width evenly. |
| `orientation` | `Axis` | `Axis.horizontal` |  | Direction of the tab bar; vertical puts a column at the start. |
| `backgroundColor` | `Color?` |  |  | Fill color of the tab bar. |
| `selectedColor` | `Color?` |  |  | Color of the selected tab's fill or text, depending on the variant. |
| `unselectedColor` | `Color?` |  |  | Text color of the unselected tabs. |
| `indicatorColor` | `Color?` |  |  | Color of the underline in [VTabs.underline]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the tab bar. |
| `tabPadding` | `EdgeInsetsGeometry?` |  |  | Space inside each tab. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the tab bar. |
| `indicatorBorderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius of the selected tab's fill. |
| `indicatorBorder` | `BoxBorder?` |  |  | Border drawn around the selected tab. |
| `style` | `VTabsStyle?` |  |  | Overrides for colors, padding, label text styles and the underline. |

## VTab

An item displayed in a [VTabs] widget.

One tab of a [VTabs]: a label, an optional icon and the content it shows.

## Basic Usage

```dart
VTab(
  key: 'profile',
  label: Text('Profile'),
  icon: Icon(Icons.person),
  content: ProfileView(),
)
```

### Constructors

#### `VTab`

Creates a tab.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Name of the tab, usually a [Text].<br>A plain [Text] picks up the theme's label style and the tab color. |
| `content` | `Widget` |  | yes | Widget shown below or beside the tab bar while this tab is selected. |
| `icon` | `Widget?` |  |  | Icon shown before the label. |
| `enabled` | `bool` | `true` |  | Whether the tab can be selected; a disabled tab is dimmed and skipped. |

## VTabsStyle

Style override for [VTabs].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VTabsStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `activeColor` | `Color?` |  |  | Selected tab color: its text, or its fill on [VTabs.pills].<br>Wins over the color of [selectedTextStyle]. |
| `inactiveColor` | `Color?` |  |  | Text color of the tabs that are not selected.<br>Wins over the color of [textStyle]. |
| `indicatorColor` | `Color?` |  |  | Underline color of [VTabs.underline]. |
| `indicatorHeight` | `double?` |  |  | Underline thickness of [VTabs.underline]; 2 when null. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Label text style of every tab, merged over the default label style.<br>The default is the theme's label medium style in the tab color, semibold on the selected tab. Only the fields this sets change, so setting a weight here also changes the selected tab unless [selectedTextStyle] sets one. |
| `selectedTextStyle` | `TextStyle?` |  |  | Label text style of the selected tab, merged over [textStyle]. |

### Members

| Member | Description |
|---|---|
| `VTabsStyle copyWith({Color? backgroundColor, Color? activeColor, Color? inactiveColor, Color? indicatorColor, double? indicatorHeight, EdgeInsets? padding, TextStyle? textStyle, TextStyle? selectedTextStyle})` | Creates a copy with only the specified properties changed. |
