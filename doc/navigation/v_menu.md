# VMenu

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VMenu

Popup menu of actions that opens below or above its trigger widget.

{@category Navigation}

## Overview

[VMenu] shows a context menu when the trigger widget is tapped.
It supports icons, dividers, disabled items, and destructive actions.

## Basic Usage

```dart
VMenu(
  trigger: VIconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  items: [
    VMenuItem(onTap: () => edit(), child: Text('Edit')),
    VMenuItem(onTap: () => share(), child: Text('Share')),
    VMenuDivider(),
    VMenuItem(
      destructive: true,
      onTap: () => delete(),
      child: Text('Delete'),
    ),
  ],
)
```

## Menu with icons

```dart
VMenu(
  trigger: VButton(child: Text('Options'), onPressed: () {}),
  items: [
    VMenuItem(
      leading: Icon(Icons.copy),
      trailing: Text('Ctrl+C'),
      onTap: () => copy(),
      child: Text('Copy'),
    ),
    VMenuItem(
      leading: Icon(Icons.paste),
      trailing: Text('Ctrl+V'),
      onTap: () => paste(),
      child: Text('Paste'),
    ),
  ],
)
```

## Menu with disabled items

```dart
VMenu(
  trigger: VIconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
  items: [
    VMenuItem(onTap: () => undo(), child: Text('Undo')),
    VMenuItem(enabled: false, onTap: () {}, child: Text('Redo')),
  ],
)
```

## Positioned menu

Use [position] to control where the menu appears:

```dart
VMenu(
  position: VMenuPosition.topEnd,
  trigger: VButton(child: Text('Menu'), onPressed: () {}),
  items: [
    VMenuItem(onTap: () {}, child: Text('Option 1')),
    VMenuItem(onTap: () {}, child: Text('Option 2')),
  ],
)
```

Available positions: [VMenuPosition.bottomStart], [VMenuPosition.bottomEnd],
[VMenuPosition.topStart], [VMenuPosition.topEnd]

See also:

- [VMenuItem], for individual menu items
- [VMenuDivider], for separating menu sections
- [VDrawer], for full navigation panel

### Constructors

#### `VMenu`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VMenuItem>` |  | yes | Rows of the menu, in order; use [VMenuDivider] to separate groups. |
| `trigger` | `Widget` |  | yes | Widget that opens the menu when tapped. |
| `position` | `VMenuPosition` | `VMenuPosition.bottomStart` |  | Where the menu opens relative to the trigger. |
| `closeOnSelect` | `bool` | `true` |  | Whether the menu closes after an item is activated. |
| `style` | `VMenuStyle?` |  |  | Overrides the theme's [VMenuStyle] for this menu. |

## VMenuPosition

Corner of its trigger where a [VMenu] opens.

### Values

| Value | Description |
|---|---|
| `bottomStart` | Bottom start (default). |
| `bottomEnd` | Bottom end. |
| `topStart` | Top start. |
| `topEnd` | Top end. |

## VMenuItem

One selectable row of a [VMenu], with a child, icons and a tap callback.

```dart
VMenuItem(
  leading: Icon(Icons.delete),
  destructive: true,
  onTap: () => deleteItem(),
  child: Text('Delete'),
)
```

### Constructors

#### `VMenuItem`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the row, usually a [Text] that takes the menu text style. |
| `leading` | `Widget?` |  |  | Widget before the child, such as an icon. |
| `trailing` | `Widget?` |  |  | Widget after the child, such as a shortcut hint. |
| `onTap` | `void Function()?` |  |  | Called when the row is tapped or activated with the keyboard. |
| `enabled` | `bool` | `true` |  | Whether the row reacts to input; false dims it and skips it on arrows. |
| `destructive` | `bool` | `false` |  | Whether the row is drawn in the destructive color. |

## VMenuDivider

Thin line that separates groups of [VMenuItem] rows in a [VMenu].

```dart
VMenu(
  trigger: VIconButton(icon: Icon(Icons.more_vert)),
  items: [
    VMenuItem(onTap: () {}, child: Text('Copy')),
    VMenuDivider(),
    VMenuItem(destructive: true, onTap: () {}, child: Text('Delete')),
  ],
)
```

### Constructors

#### `VMenuDivider`

## VMenuStyle

Style override for [VMenu].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VMenuStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Menu container padding. |
| `itemPadding` | `EdgeInsets?` |  |  | Individual item padding. |

### Members

| Member | Description |
|---|---|
| `VMenuStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, double? elevation, EdgeInsets? padding, EdgeInsets? itemPadding})` | Creates a copy with only the specified properties changed. |
