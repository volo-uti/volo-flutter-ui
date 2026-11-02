import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_dismissible_style.dart';

/// Swipe-to-delete row with a screen reader action.
///
/// Wraps [Dismissible] with token defaults; the swipe can also archive or
/// do anything else that removes the row. The default [background] shows
/// [dismissLabel] on the destructive color, on the side the swipe uncovers.
///
/// Screen reader users cannot swipe, so the row also offers a custom action
/// named [dismissLabel]. It runs [confirmDismiss] and [onDismissed] as a swipe
/// in [direction] would; [DismissDirection.horizontal] reports
/// [DismissDirection.endToStart] and [DismissDirection.vertical] reports
/// [DismissDirection.up].
///
/// Like [Dismissible], it needs a [key] that is unique among the rows, and
/// [onDismissed] must remove the row from the tree.
///
/// ```dart
/// VDismissible(
///   key: ValueKey(entry.id),
///   onDismissed: (_) => setState(() => entries.remove(entry)),
///   child: VListTile(title: Text(entry.title)),
/// )
/// ```
class VDismissible extends StatelessWidget {
  /// Creates a row that a swipe or a screen reader action removes.
  const VDismissible({
    required Key super.key,
    required this.child,
    this.onDismissed,
    this.confirmDismiss,
    this.direction = DismissDirection.endToStart,
    this.background,
    this.dismissLabel,
    this.style,
  });

  /// The row, usually a `VListTile`.
  final Widget child;

  /// Called once the row is dismissed; remove the row from the list here.
  final DismissDirectionCallback? onDismissed;

  /// Asked before the row is dismissed; completing with false keeps the row.
  final ConfirmDismissCallback? confirmDismiss;

  /// Directions a swipe can dismiss the row in; [DismissDirection.none] turns
  /// both the swipe and the screen reader action off.
  final DismissDirection direction;

  /// Shown behind the row while it is swiped, on both sides.
  ///
  /// Wins over [style]. When null, [dismissLabel] is shown on the style's
  /// background color, then the theme override's, then the destructive color.
  final Widget? background;

  /// Name of the screen reader action and text of the default background.
  ///
  /// Defaults to [VoloLocalizations.dismissibleActionLabel] ("Delete").
  final String? dismissLabel;

  /// Style override.
  ///
  /// The instance style wins over the theme's [VDismissibleStyle] override,
  /// which wins over the token defaults.
  final VDismissibleStyle? style;

  // The direction a screen reader action reports, as if swiped that way.
  DismissDirection? get _actionDirection => switch (direction) {
    DismissDirection.horizontal => DismissDirection.endToStart,
    DismissDirection.vertical => DismissDirection.up,
    DismissDirection.none => null,
    _ => direction,
  };

  Future<void> _dismissByAction(
    BuildContext context,
    DismissDirection direction,
  ) async {
    final confirm = confirmDismiss;
    if (confirm != null) {
      final confirmed = await confirm(direction);
      if (confirmed != true || !context.mounted) return;
    }
    onDismissed?.call(direction);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VDismissibleStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final label =
        dismissLabel ?? VoloLocalizations.of(context).dismissibleActionLabel;

    final isVertical =
        direction == DismissDirection.up ||
        direction == DismissDirection.down ||
        direction == DismissDirection.vertical;
    final padding =
        resolvedStyle?.padding ??
        (isVertical
            ? EdgeInsets.symmetric(vertical: theme.spacing.lg)
            : EdgeInsets.symmetric(horizontal: theme.spacing.lg));

    // The label is decoration: the screen reader action carries the name.
    Widget labelOn(AlignmentGeometry alignment) => ExcludeSemantics(
      child: ColoredBox(
        color: resolvedStyle?.backgroundColor ?? theme.colors.destructive,
        child: Padding(
          padding: padding,
          child: Align(
            alignment: alignment,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.labelLarge.copyWith(
                color:
                    resolvedStyle?.foregroundColor ??
                    theme.colors.destructiveForeground,
              ),
            ),
          ),
        ),
      ),
    );

    // Dismissible shows `background` for startToEnd and down, and
    // `secondaryBackground` for endToStart and up.
    final backgrounds = background != null
        ? (background, null)
        : switch (direction) {
            DismissDirection.startToEnd => (
              labelOn(AlignmentDirectional.centerStart),
              null,
            ),
            DismissDirection.endToStart => (
              labelOn(AlignmentDirectional.centerEnd),
              null,
            ),
            DismissDirection.horizontal => (
              labelOn(AlignmentDirectional.centerStart),
              labelOn(AlignmentDirectional.centerEnd),
            ),
            DismissDirection.down => (labelOn(Alignment.topCenter), null),
            DismissDirection.up => (labelOn(Alignment.bottomCenter), null),
            DismissDirection.vertical => (
              labelOn(Alignment.topCenter),
              labelOn(Alignment.bottomCenter),
            ),
            DismissDirection.none => (null, null),
          };

    final actionDirection = _actionDirection;
    final hasAction =
        actionDirection != null &&
        (onDismissed != null || confirmDismiss != null);

    // WHY: container — the row gets its own node, so the action sits with
    // the row's label and tap instead of merging into a neighbor's node.
    return Semantics(
      container: true,
      customSemanticsActions: hasAction
          ? {
              CustomSemanticsAction(label: label): () =>
                  unawaited(_dismissByAction(context, actionDirection)),
            }
          : null,
      child: Dismissible(
        key: ValueKey<Key?>(key),
        direction: direction,
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
        background: backgrounds.$1,
        secondaryBackground: backgrounds.$2,
        movementDuration: theme.animations.fast,
        resizeDuration: theme.animations.normal,
        child: child,
      ),
    );
  }
}
