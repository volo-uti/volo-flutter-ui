# v_component_style

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VComponentStyle

Interface for component style override classes.

Enables [VComponentOverrides] to store and deep-merge any component style
in a type-safe Map without enumerating every class.

Every concrete style class (e.g. [VButtonStyle], [VAvatarStyle]) must
implement this interface.

### Constructors

#### `VComponentStyle`

### Members

| Member | Description |
|---|---|
| `VComponentStyle merge(VComponentStyle? other)` | Merges [other] on top of this style. Non-null values in [other] win.<br>Subclasses narrow the parameter type via `covariant`. |
