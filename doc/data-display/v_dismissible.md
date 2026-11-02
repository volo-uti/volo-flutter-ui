# VDismissible

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDismissible

Swipe-to-delete row with a screen reader action.

Wraps [Dismissible] with token defaults; the swipe can also archive or
do anything else that removes the row. The default [background] shows
[dismissLabel] on the destructive color, on the side the swipe uncovers.

Screen reader users cannot swipe, so the row also offers a custom action
named [dismissLabel]. It runs [confirmDismiss] and [onDismissed] as a swipe
in [direction] would; [DismissDirection.horizontal] reports
[DismissDirection.endToStart] and [DismissDirection.vertical] reports
[DismissDirection.up].

Like [Dismissible], it needs a [key] that is unique among the rows, and
[onDismissed] must remove the row from the tree.

```dart
VDismissible(
  key: ValueKey(entry.id),
  onDismissed: (_) => setState(() => entries.remove(entry)),
  child: VListTile(title: Text(entry.title)),
)
```

### Constructors

#### `VDismissible`

Creates a row that a swipe or a screen reader action removes.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | The row, usually a `VListTile`. |
| `onDismissed` | `void Function(DismissDirection)?` |  |  | Called once the row is dismissed; remove the row from the list here. |
| `confirmDismiss` | `Future<bool?> Function(DismissDirection)?` |  |  | Asked before the row is dismissed; completing with false keeps the row. |
| `direction` | `DismissDirection` | `DismissDirection.endToStart` |  | Directions a swipe can dismiss the row in; [DismissDirection.none] turns both the swipe and the screen reader action off. |
| `background` | `Widget?` |  |  | Shown behind the row while it is swiped, on both sides.<br>Wins over [style]. When null, [dismissLabel] is shown on the style's background color, then the theme override's, then the destructive color. |
| `dismissLabel` | `String?` |  |  | Name of the screen reader action and text of the default background.<br>Defaults to [VoloLocalizations.dismissibleActionLabel] ("Delete"). |
| `style` | `VDismissibleStyle?` |  |  | Style override.<br>The instance style wins over the theme's [VDismissibleStyle] override, which wins over the token defaults. |

## VDismissibleStyle

Style override for [VDismissible].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VDismissibleStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Fill of the default background; defaults to the destructive color. |
| `foregroundColor` | `Color?` |  |  | Text color of the default background; defaults to destructiveForeground. |
| `padding` | `EdgeInsets?` |  |  | Space between the edge and the label of the default background. |

### Members

| Member | Description |
|---|---|
| `VDismissibleStyle copyWith({Color? backgroundColor, Color? foregroundColor, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
