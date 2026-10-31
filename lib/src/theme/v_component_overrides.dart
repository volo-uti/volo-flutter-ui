import 'package:flutter/widgets.dart';

import 'v_component_style.dart';

/// Component style overrides set on the theme.
///
/// Allows customizing default styles for all instances of a component
/// via [VThemeData.componentOverrides].
///
/// This is Level 3 in the style cascade:
/// 1. Token defaults (DTCG generated)
/// 2. Custom tokens (VThemeData token fields)
/// 3. Component overrides (this class)
/// 4. Instance style (widget `style` parameter)
///
/// **Usage:**
///
/// ```dart
/// VThemeData.light().copyWith(
///   componentOverrides: VComponentOverrides([
///     VButtonStyle(backgroundColor: Colors.red),
///     VAvatarStyle(borderRadius: BorderRadius.circular(8)),
///   ]),
/// )
/// ```
@immutable
class VComponentOverrides {
  /// Creates overrides from a list of [VComponentStyle] instances.
  ///
  /// Duplicate types are not expected — if present, the last entry wins.
  const VComponentOverrides([List<VComponentStyle> styles = const []])
    : _styles = styles;

  const VComponentOverrides._(this._styles);

  final List<VComponentStyle> _styles;

  /// Empty overrides (no customization).
  static const VComponentOverrides empty = VComponentOverrides();

  // PERF: Linear scan over _styles list is acceptable because the number
  // of component-level overrides is typically < 10. A Map<Type, ...> would
  // require runtimeType keys which break const constructors.
  /// Retrieves the style override for [T], or `null` if none is set.
  T? get<T extends VComponentStyle>() {
    for (final style in _styles) {
      if (style is T) return style;
    }
    return null;
  }

  /// Deep-merges [other] on top of this.
  ///
  /// When both sides contain a style for the same component type,
  /// the individual style properties are merged via [VComponentStyle.merge]
  /// (non-null in [other] wins).
  /// When only one side contains it, that value is used.
  // WHY: Deep-merge per component type rather than shallow list concat —
  // when both parent and child themes customize VButtonStyle, we want
  // field-level merge (child fills gaps from parent), not replacement.
  VComponentOverrides merge(VComponentOverrides? other) {
    if (other == null) return this;
    final merged = Map<Type, VComponentStyle>.fromEntries(
      _styles.map((s) => MapEntry(s.runtimeType, s)),
    );
    for (final style in other._styles) {
      final existing = merged[style.runtimeType];
      merged[style.runtimeType] = existing != null
          ? existing.merge(style)
          : style;
    }
    return VComponentOverrides._(merged.values.toList());
  }

  Map<Type, VComponentStyle> get _byType => {
    for (final s in _styles) s.runtimeType: s,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VComponentOverrides) return false;
    final thisMap = _byType;
    final otherMap = other._byType;
    if (thisMap.length != otherMap.length) return false;
    return thisMap.entries.every(
      (e) => otherMap.containsKey(e.key) && otherMap[e.key] == e.value,
    );
  }

  @override
  int get hashCode => Object.hashAllUnordered(
    _byType.entries.map((e) => Object.hash(e.key, e.value)),
  );
}
