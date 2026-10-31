# v_component_overrides

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VComponentOverrides

Component style overrides set on the theme.

Allows customizing default styles for all instances of a component
via [VThemeData.componentOverrides].

This is Level 3 in the style cascade:
1. Token defaults (DTCG generated)
2. Custom tokens (VThemeData token fields)
3. Component overrides (this class)
4. Instance style (widget `style` parameter)

**Usage:**

```dart
VThemeData.light().copyWith(
  componentOverrides: VComponentOverrides([
    VButtonStyle(backgroundColor: Colors.red),
    VAvatarStyle(borderRadius: BorderRadius.circular(8)),
  ]),
)
```

### Constructors

#### `VComponentOverrides`

Creates overrides from a list of [VComponentStyle] instances.

Duplicate types are not expected — if present, the last entry wins.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `styles` | `List<VComponentStyle>` | `const []` |  |  |

### Members

| Member | Description |
|---|---|
| `static VComponentOverrides empty` | Empty overrides (no customization). |
| `T? get<T extends VComponentStyle>()` | Retrieves the style override for [T], or `null` if none is set. |
| `VComponentOverrides merge(VComponentOverrides? other)` | Deep-merges [other] on top of this.<br>When both sides contain a style for the same component type, the individual style properties are merged via [VComponentStyle.merge] (non-null in [other] wins). When only one side contains it, that value is used. |
