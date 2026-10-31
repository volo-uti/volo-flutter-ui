import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/l10n/volo_localizations.dart';
import 'package:volo_flutter_ui/src/l10n/volo_localizations_en.dart';
import 'v_animations.dart';
import 'v_borders.dart';
import 'v_colors.dart';
import 'v_gradients.dart';
import 'v_radius.dart';
import 'v_shadows.dart';
import 'v_sizes.dart';
import 'v_spacing.dart';
import 'v_theme_data.dart';
import 'v_typography.dart';

// WHY: InheritedWidget instead of Provider/Riverpod — pub.dev libraries
// should not impose state management dependencies on consumers. InheritedWidget
// is framework-native, zero-dependency, and guarantees O(1) ancestor lookup.
/// Provides [VThemeData] and localizations to descendants.
///
/// Read the data with [VTheme.of] and [VTheme.maybeOf].
/// ```dart
/// VTheme(
///   data: VThemeData.light(),
///   child: MyApp(),
/// )
/// ```
class VTheme extends InheritedWidget {
  /// Creates a theme that applies [data] to [child].
  const VTheme({
    required this.data,
    required super.child,
    super.key,
    this.localizations = const VoloLocalizationsEn(),
  });

  /// Theme data that descendants read through [VTheme.of].
  final VThemeData data;

  /// Strings that widgets show or announce, English by default.
  final VoloLocalizations localizations;

  /// Retrieves the current theme data.
  ///
  /// Throws an assert error if no VTheme is found.
  static VThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    assert(theme != null, 'No VTheme found in context');
    return theme!;
  }

  /// Retrieves the current theme data (nullable).
  ///
  /// Returns null if no VTheme is found.
  static VThemeData? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<VTheme>();
    return widget?.data;
  }

  /// Merges overrides into the nearest ancestor [VTheme].
  ///
  /// Reads the current theme via [VTheme.of], applies [overrides],
  /// and wraps [child] with a new [VTheme] containing the result.
  ///
  /// ```dart
  /// VTheme.merge(
  ///   overrides: (parent) => parent.copyWith(
  ///     colors: parent.colors.copyWith(primary: Color(0xFF00FF00)),
  ///   ),
  ///   child: MySection(),
  /// )
  /// ```
  // WHY: Builder pattern defers context lookup — the parent theme is read
  // at build time, not call time, so this works even when called outside
  // a VTheme subtree (e.g. in a factory method).
  static Widget merge({
    required VThemeData Function(VThemeData parent) overrides,
    required Widget child,
  }) => Builder(
    builder: (context) {
      final parent = VTheme.of(context);
      return VTheme(
        data: overrides(parent),
        localizations: VoloLocalizations.of(context),
        child: child,
      );
    },
  );

  // PERF: Full equality check on VThemeData avoids unnecessary subtree
  // rebuilds when the same data object is provided (e.g. setState without
  // actually changing the theme).
  @override
  bool updateShouldNotify(VTheme oldWidget) =>
      data != oldWidget.data || localizations != oldWidget.localizations;
}

// WHY: Extension methods provide dot-shorthand (context.vColors) to reduce
// boilerplate while keeping VTheme.of(context) as the canonical API.
/// Shortcuts such as `context.vColors` for reading the theme.
///
/// ```dart
/// final theme = context.vTheme;
/// final colors = context.vTheme.colors;
/// ```
extension VThemeExtension on BuildContext {
  /// Current theme data.
  VThemeData get vTheme => VTheme.of(this);

  /// Current theme colors (shortcut access).
  ///
  /// ```dart
  /// final bg = context.vColors.background;
  /// ```
  VColors get vColors => VTheme.of(this).colors;

  /// Current theme typography (shortcut access).
  ///
  /// ```dart
  /// final style = context.vTypography.bodyMedium;
  /// ```
  VTypography get vTypography => VTheme.of(this).typography;

  /// Current theme sizes (shortcut access).
  ///
  /// ```dart
  /// final radius = context.vSizes.md;
  /// ```
  VSizes get vSizes => VTheme.of(this).sizes;

  /// Current theme shadows (shortcut access).
  ///
  /// ```dart
  /// final shadow = context.vShadows.md;
  /// ```
  VShadows get vShadows => VTheme.of(this).shadows;

  /// Current theme spacing (shortcut access).
  ///
  /// ```dart
  /// final gap = context.vSpacing.md;
  /// ```
  VSpacing get vSpacing => VTheme.of(this).spacing;

  /// Current theme radius (shortcut access).
  ///
  /// ```dart
  /// final r = context.vRadius.md;
  /// ```
  VRadius get vRadius => VTheme.of(this).radius;

  /// Current theme animations (shortcut access).
  ///
  /// ```dart
  /// final dur = context.vAnimations.fast;
  /// ```
  VAnimations get vAnimations => VTheme.of(this).animations;

  /// Current theme borders (shortcut access).
  ///
  /// ```dart
  /// final border = context.vBorders.defaultBorder;
  /// ```
  VBorders get vBorders => VTheme.of(this).borders;

  /// Current theme gradients (shortcut access).
  ///
  /// ```dart
  /// final grad = context.vGradients.brand;
  /// ```
  VGradients get vGradients => VTheme.of(this).gradients;

  /// Current localizations (shortcut access).
  ///
  /// ```dart
  /// final text = context.vLocalizations.noData;
  /// ```
  VoloLocalizations get vLocalizations {
    final widget = dependOnInheritedWidgetOfExactType<VTheme>();
    assert(widget != null, 'No VTheme found in context');
    return widget!.localizations;
  }
}
