# v_icons

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VIcons

Vector icons drawn in code, no asset files.

Provides CustomPaint-based icons that do not depend on MaterialIcons font.
All icons scale to the given `size` and are drawn on a 24-unit grid with a
stroke of `size / 12`, round caps and round joins.

The `color` comes first from the argument, then from the nearest
[IconTheme] (so an icon inside a `VButton` or a `VBottomNav` item follows
that widget's foreground and selected colors), then from the theme's
foreground color.

```dart
VIcons.close(size: 16, color: theme.colors.foreground)
VIcons.settings() // IconTheme color, else the theme foreground
```

### Members

| Member | Description |
|---|---|
| `static Widget chevronLeft({Color? color, double size = 24})` | Left chevron (<). |
| `static Widget chevronRight({Color? color, double size = 24})` | Right chevron (>). |
| `static Widget chevronUp({Color? color, double size = 24})` | Up chevron (^). |
| `static Widget chevronDown({Color? color, double size = 24})` | Down chevron (v). |
| `static Widget arrowBack({Color? color, double size = 24})` | Back arrow with stem. |
| `static Widget arrowUp({Color? color, double size = 24})` | Upward arrow with stem. |
| `static Widget arrowDown({Color? color, double size = 24})` | Downward arrow with stem. |
| `static Widget firstPage({Color? color, double size = 24})` | First page (\|<). |
| `static Widget lastPage({Color? color, double size = 24})` | Last page (>\|). |
| `static Widget arrowDropDown({Color? color, double size = 24})` | Solid triangle pointing down, for a dropdown trigger. |
| `static Widget openInNew({Color? color, double size = 24})` | Square with an arrow leaving its corner, for a link that opens elsewhere. |
| `static Widget close({Color? color, double size = 24})` | Close / dismiss (X). |
| `static Widget check({Color? color, double size = 24})` | Checkmark. |
| `static Widget search({Color? color, double size = 24})` | Search / magnifying glass. |
| `static Widget refresh({Color? color, double size = 24})` | Refresh / reload. |
| `static Widget edit({Color? color, double size = 24})` | Edit / pencil. |
| `static Widget settings({Color? color, double size = 24})` | Gear, for settings. |
| `static Widget location({Color? color, double size = 24})` | Crosshair around a dot, for "my location". |
| `static Widget playCircle({Color? color, double size = 24})` | Play triangle in an outlined circle. |
| `static Widget info({Color? color, double size = 24})` | Info circle (outlined). |
| `static Widget checkCircle({Color? color, double size = 24})` | Success check in filled circle. |
| `static Widget error({Color? color, double size = 24})` | Error X in filled circle. |
| `static Widget warning({Color? color, double size = 24})` | Warning triangle with exclamation. |
| `static Widget priorityHigh({Color? color, double size = 24})` | Priority high (exclamation mark). |
| `static Widget person({Color? color, double size = 24})` | Person silhouette. |
| `static Widget calendar({Color? color, double size = 24})` | Calendar. |
| `static Widget visibility({Color? color, double size = 24})` | Eye open (visibility). |
| `static Widget visibilityOff({Color? color, double size = 24})` | Eye closed (visibility off). |
| `static Widget camera({Color? color, double size = 24})` | Camera body with a lens. |
| `static Widget list({Color? color, double size = 24})` | Bulleted list. |
| `static Widget cloud({Color? color, double size = 24})` | Cloud outline. |
| `static Widget clock({Color? color, double size = 24})` | Clock face with hands. |
