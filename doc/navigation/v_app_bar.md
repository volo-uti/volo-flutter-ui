# VAppBar

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAppBar

Top bar with a title, leading widget and actions, with a back button.

{@category Navigation}

## Overview

[VAppBar] sits at the top of a screen. When it is inside a [Navigator] that
can pop, it shows a back button on its own.

## Basic Usage

```dart
VAppBar(
  title: Text('My App'),
  actions: [
    VIconButton(
      icon: Icon(Icons.search),
      onPressed: () => print('Search'),
    ),
  ],
)
```

## Variants

- [VAppBar.new] - Default app bar with optional elevation
- [VAppBar.transparent] - Transparent background with no elevation
- [VAppBar.elevated] - App bar with shadow (elevation: 4)
- [VAppBar.centered] - Title centered horizontally

## App bar with leading widget

```dart
VAppBar(
  leading: VIconButton(
    icon: Icon(Icons.menu),
    onPressed: () => Scaffold.of(context).openDrawer(),
  ),
  title: Text('Dashboard'),
)
```

## Transparent app bar for overlay content

```dart
VAppBar.transparent(
  title: Text('Profile'),
  foregroundColor: Colors.white,
  actions: [
    VIconButton(icon: Icon(Icons.settings), onPressed: () {}),
  ],
)
```

See also:

- [VBottomNav], for bottom navigation
- [VDrawer], for side navigation panel

### Constructors

#### `VAppBar`

Creates an app bar with an optional shadow.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget?` |  |  | Title shown after the leading widget, usually a [Text].<br>A plain [Text] picks up the theme's title style and the foreground color. |
| `leading` | `Widget?` |  |  | Widget before the title, replacing the automatic back button. |
| `actions` | `List<Widget>?` |  |  | Widgets shown after the title, usually icon buttons. |
| `bottom` | `PreferredSizeWidget?` |  |  | Widget under the bar, such as a tab bar, that adds to [preferredSize]. |
| `automaticallyImplyLeading` | `bool` | `true` |  | Whether to show a back button when [leading] is null and the route can pop. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `foregroundColor` | `Color?` |  |  | Color of the title text, defaulting to the theme foreground. |
| `elevation` | `double?` |  |  | Whether the bar casts a shadow, when above 0. |
| `centerTitle` | `bool?` |  |  | Whether to center the title, defaulting to false except for [VAppBar.centered]. |
| `style` | `VAppBarStyle?` |  |  | Overrides for colors, padding and title style. |

#### `VAppBar.transparent`

Transparent app bar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget?` |  |  | Title shown after the leading widget, usually a [Text].<br>A plain [Text] picks up the theme's title style and the foreground color. |
| `leading` | `Widget?` |  |  | Widget before the title, replacing the automatic back button. |
| `actions` | `List<Widget>?` |  |  | Widgets shown after the title, usually icon buttons. |
| `bottom` | `PreferredSizeWidget?` |  |  | Widget under the bar, such as a tab bar, that adds to [preferredSize]. |
| `automaticallyImplyLeading` | `bool` | `true` |  | Whether to show a back button when [leading] is null and the route can pop. |
| `foregroundColor` | `Color?` |  |  | Color of the title text, defaulting to the theme foreground. |
| `centerTitle` | `bool?` |  |  | Whether to center the title, defaulting to false except for [VAppBar.centered]. |
| `style` | `VAppBarStyle?` |  |  | Overrides for colors, padding and title style. |

#### `VAppBar.elevated`

Elevated app bar with shadow.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget?` |  |  | Title shown after the leading widget, usually a [Text].<br>A plain [Text] picks up the theme's title style and the foreground color. |
| `leading` | `Widget?` |  |  | Widget before the title, replacing the automatic back button. |
| `actions` | `List<Widget>?` |  |  | Widgets shown after the title, usually icon buttons. |
| `bottom` | `PreferredSizeWidget?` |  |  | Widget under the bar, such as a tab bar, that adds to [preferredSize]. |
| `automaticallyImplyLeading` | `bool` | `true` |  | Whether to show a back button when [leading] is null and the route can pop. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `foregroundColor` | `Color?` |  |  | Color of the title text, defaulting to the theme foreground. |
| `centerTitle` | `bool?` |  |  | Whether to center the title, defaulting to false except for [VAppBar.centered]. |
| `style` | `VAppBarStyle?` |  |  | Overrides for colors, padding and title style. |

#### `VAppBar.centered`

Centered title app bar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget?` |  |  | Title shown after the leading widget, usually a [Text].<br>A plain [Text] picks up the theme's title style and the foreground color. |
| `leading` | `Widget?` |  |  | Widget before the title, replacing the automatic back button. |
| `actions` | `List<Widget>?` |  |  | Widgets shown after the title, usually icon buttons. |
| `bottom` | `PreferredSizeWidget?` |  |  | Widget under the bar, such as a tab bar, that adds to [preferredSize]. |
| `automaticallyImplyLeading` | `bool` | `true` |  | Whether to show a back button when [leading] is null and the route can pop. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `foregroundColor` | `Color?` |  |  | Color of the title text, defaulting to the theme foreground. |
| `elevation` | `double?` |  |  | Whether the bar casts a shadow, when above 0. |
| `style` | `VAppBarStyle?` |  |  | Overrides for colors, padding and title style. |

## VAppBarStyle

Style override for [VAppBar].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAppBarStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text / icon foreground color. |
| `borderColor` | `Color?` |  |  | Bottom border color. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `titleStyle` | `TextStyle?` |  |  | Title text style. |

### Members

| Member | Description |
|---|---|
| `VAppBarStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, double? elevation, EdgeInsets? padding, TextStyle? titleStyle})` | Creates a copy with only the specified properties changed. |
