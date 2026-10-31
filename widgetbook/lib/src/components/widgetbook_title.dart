part of 'widgetbook_components.dart';

/// Widgetbook title.
///
/// Displays the page title and description.
class WidgetbookTitle extends StatelessWidget {
  const WidgetbookTitle({required this.title, this.description, super.key});

  /// Title.
  final String title;

  /// Description (optional).
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.typography.headlineLarge.copyWith(
            color: theme.colors.foreground,
          ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            description!,
            style: theme.typography.bodyLarge.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
        const SizedBox(height: 16),
        VDivider(color: theme.colors.border),
      ],
    );
  }
}
