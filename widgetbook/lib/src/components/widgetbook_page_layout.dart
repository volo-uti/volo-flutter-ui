part of 'widgetbook_components.dart';

/// Widgetbook page layout.
///
/// Provides the base layout for all UseCases.
/// Displays a title, description, and child widgets in a scrollable form.
class WidgetbookPageLayout extends StatelessWidget {
  const WidgetbookPageLayout({
    required this.title,
    required this.children,
    this.description,
    this.childrenSpacing = 24,
    super.key,
  });

  /// Page title.
  final String title;

  /// Page description (optional).
  final String? description;

  /// List of child widgets.
  final List<Widget> children;

  /// Spacing between child widgets.
  final double childrenSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return ColoredBox(
      color: theme.colors.background,
      child: DefaultTextStyle(
        style: theme.typography.bodyMedium.copyWith(
          color: theme.colors.foreground,
        ),
        child: SafeArea(
          // ListView instead of SingleChildScrollView to avoid
          // LayoutBuilder intrinsic dimension conflict in Widgetbook.
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            children: [
              WidgetbookTitle(title: title, description: description),
              SizedBox(height: childrenSpacing),
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) SizedBox(height: childrenSpacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
