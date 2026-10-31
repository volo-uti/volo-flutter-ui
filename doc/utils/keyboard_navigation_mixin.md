# keyboard_navigation_mixin

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## KeyboardNavigationMixin

Arrow, Home, End, Enter and Escape navigation for lists.

### Members

| Member | Description |
|---|---|
| `int get itemCount` | Number of navigable items. |
| `Axis get navigationAxis` | Axis along which the arrow keys move focus. |
| `bool get wrapAround` | Whether focus wraps from the last item to the first and back. |
| `int get focusedIndex` | Index of the focused item, or -1 when none is focused. |
| `bool isItemEnabled(int index)` | Whether the item at [index] can take focus; all items by default. |
| `void onItemActivated(int index)` | Called when Enter or Space activates the focused item at [index]. |
| `void onEscapePressed()` | Called when Escape is pressed; does nothing by default. |
| `void focusNext()` | Moves focus to the next enabled item. |
| `void focusPrevious()` | Moves focus to the previous enabled item. |
| `void focusFirst()` | Moves focus to the first enabled item. |
| `void focusLast()` | Moves focus to the last enabled item. |
| `KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event)` | Handles arrow, Home, End, Enter, Space and Escape key events. |
