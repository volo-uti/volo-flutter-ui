import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_empty_state_style.dart';

/// Centered message for an empty list or screen.
///
/// Stacks an optional icon, a title, an optional description and an optional
/// action, centered in the space it gets. When that space has a fixed height
/// that is too short, for example with large text, the content scrolls
/// instead of overflowing; inside a scroll view it takes its natural height.
/// The title is a heading for screen readers.
///
/// An icon without its own color takes the muted foreground color through
/// [IconTheme], so a `VIcons` icon needs only a size.
///
/// ```dart
/// VEmptyState(
///   icon: VIcons.list(size: 48),
///   title: 'No entries yet',
///   description: 'Entries you save appear here.',
///   action: VButton(onPressed: addEntry, child: const Text('Add entry')),
/// )
/// ```
class VEmptyState extends StatelessWidget {
  /// Creates an empty state with a [title] and an optional icon, text and action.
  const VEmptyState({
    required this.title,
    super.key,
    this.icon,
    this.description,
    this.action,
    this.style,
  });

  /// Picture above the title, usually a `VIcons` icon.
  final Widget? icon;

  /// Short heading that says what is empty; screen readers read it as a heading.
  final String title;

  /// Text below the title that says why it is empty or what to do next.
  final String? description;

  /// Widget below the text, usually one `VButton` for the next step.
  final Widget? action;

  /// Style override.
  ///
  /// The instance style wins over the theme's [VEmptyStateStyle] override,
  /// which wins over the token defaults.
  final VEmptyStateStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VEmptyStateStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final spacing = theme.spacing;
    final typography = theme.typography;

    final titleStyle = typography.titleMedium
        .copyWith(color: colors.foreground)
        .merge(resolvedStyle?.titleStyle);
    final descriptionStyle = typography.bodyMedium
        .copyWith(color: colors.mutedForeground)
        .merge(resolvedStyle?.descriptionStyle);

    final content = Padding(
      padding: resolvedStyle?.padding ?? EdgeInsets.all(spacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme.merge(
              data: IconThemeData(
                color: resolvedStyle?.iconColor ?? colors.mutedForeground,
              ),
              child: icon!,
            ),
            SizedBox(height: spacing.lg),
          ],
          Semantics(
            header: true,
            child: Text(title, style: titleStyle, textAlign: TextAlign.center),
          ),
          if (description != null) ...[
            SizedBox(height: spacing.sm),
            Text(
              description!,
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[SizedBox(height: spacing.xl), action!],
        ],
      ),
    );

    // WHY: A fixed height (an Expanded list area) centers the content and
    // scrolls it when large text makes it taller; an unbounded height (inside
    // a ListView) has nothing to center in, so the content keeps its height.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedHeight) return Center(child: content);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        );
      },
    );
  }
}
