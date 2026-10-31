// WHY: Interface (not abstract class) — Dart 3 interface classes cannot be
// extended, only implemented. This enforces that each style class is a
// standalone value object with its own merge logic, not an inheritance chain.
//
// WHY: All fields are nullable — null means "defer to theme default".
// This enables the 4-level cascade (generated → token → override → instance)
// where each level only specifies what it wants to change.
/// Interface for component style override classes.
///
/// Enables [VComponentOverrides] to store and deep-merge any component style
/// in a type-safe Map without enumerating every class.
///
/// Every concrete style class (e.g. [VButtonStyle], [VAvatarStyle]) must
/// implement this interface.
abstract interface class VComponentStyle {
  // WHY: merge(covariant) instead of operator+ — merge semantics are
  // non-commutative ("other wins on conflict"), which + would not convey.
  // The covariant parameter lets subclasses accept only their own type.
  /// Merges [other] on top of this style. Non-null values in [other] win.
  ///
  /// Subclasses narrow the parameter type via `covariant`.
  VComponentStyle merge(covariant VComponentStyle? other);
}
