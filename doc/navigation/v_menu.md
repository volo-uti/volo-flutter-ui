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

## Menu opened from code

```dart
final controller = VMenuController();

VMenu(
  controller: controller,
  trigger: VIconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  items: [VMenuItem(onTap: () {}, child: Text('Rename'))],
)

// Elsewhere:
controller.show();
```

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
| `controller` | `VMenuController?` |  |  | Opens and closes the menu from outside its trigger.<br>When null, the menu keeps its own open state. Taps, keys, items and taps outside the menu update the controller as well. |
| `style` | `VMenuStyle?` |  |  | Overrides the theme's [VMenuStyle] for this menu, such as its panel look. |

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

## VMenuController

Opens and closes a [VMenu] from code outside its trigger.

Pass it to [VMenu.controller]. [show], [hide] and [toggle] work like a tap
on the trigger, and listeners hear every open and close, whether it comes
from code, a tap, a key, an item or a tap outside the menu. A menu that is
removed while open leaves its controller closed without notifying.

```dart
final controller = VMenuController();

VMenu(controller: controller, trigger: trigger, items: items);

// Open the menu from elsewhere, such as a keyboard shortcut.
controller.show();
```

### Constructors

#### `VMenuController`

### Members

| Member | Description |
|---|---|
| `bool get isOpen` | Whether the menu is open. |
| `void show()` | Opens the menu; does nothing if it is already open. |
| `void hide()` | Closes the menu; does nothing if it is already closed. |
| `void toggle()` | Opens the menu if it is closed and closes it if it is open. |

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
| `padding` | `EdgeInsets?` |  |  | Menu container padding. |
| `itemPadding` | `EdgeInsets?` |  |  | Individual item padding. |
| `minWidth` | `double?` |  |  | Minimum width of the menu panel; 180 when null.<br>The panel still grows to fit its widest row. An instance style wins over the theme override. |
| `borderWidth` | `double?` |  |  | Width of the panel border; 1 when null.<br>An instance style wins over the theme override. |
| `shadows` | `List<BoxShadow>?` |  |  | Shadows under the panel; the theme's large shadow when null.<br>An empty list draws no shadow. An instance style wins over the theme override. |

### Members

| Member | Description |
|---|---|
| `VMenuStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, EdgeInsets? itemPadding, double? minWidth, double? borderWidth, List<BoxShadow>? shadows})` | Creates a copy with only the specified properties changed. |
