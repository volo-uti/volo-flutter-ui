import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_section_style.dart';

/// {@template v_section}
/// Rows grouped under a header, with optional footer.
///
/// [header] and [footer] are widgets; a plain [Text] there takes the section
/// title and caption styles. [VSection.card] puts the group on a card and
/// [VSection.inset] indents the rows.
///
/// ## Basic Usage:
///
/// ```dart
/// VSection(
///   header: Text('Settings'),
///   children: [
///     VListTile(title: Text('Profile')),
///     VListTile(title: Text('Notifications')),
///   ],
/// )
/// ```
///
/// ## Variants:
///
/// - [VSection.new] - Default transparent section
/// - [VSection.card] - Card style section
/// - [VSection.inset] - Indented section
///
/// ## Card Section:
///
/// ```dart
/// VSection.card(
///   header: VSectionHeader(
///     title: Text('Account Settings'),
///     trailing: TextButton(
///       onPressed: () {},
///       child: Text('More'),
///     ),
///   ),
///   divider: true,
///   children: [
///     VListTile(title: Text('Profile')),
///     VListTile(title: Text('Privacy')),
///     VListTile(title: Text('Notifications')),
///   ],
/// )
/// ```
///
/// ## With Footer:
///
/// ```dart
/// VSection(
///   header: Text('Terms'),
///   footer: Text('By using this app, you agree to our terms.'),
///   children: [
///     VSwitchListTile(
///       title: Text('Accept Terms'),
///       value: true,
///       onChanged: (v) {},
///     ),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VSectionHeader], section header widget
/// - [VSectionFooter], section footer widget
/// - [VBox], single child container
/// {@endtemplate}
class VSection extends StatelessWidget {
  /// {@macro v_section}
  ///
  /// Section with a transparent background.
  const VSection({
    required this.children,
    super.key,
    this.header,
    this.footer,
    this.padding,
    this.margin,
    this.divider = false,
    this.backgroundColor,
    this.borderRadius,
    this.style,
  }) : _showCard = false,
       _insetPadding = false;

  /// Card style section.
  ///
  /// Section drawn on a card background with rounded corners.
  ///
  /// ```dart
  /// VSection.card(
  ///   header: Text('Settings'),
  ///   children: settingItems,
  /// )
  /// ```
  const VSection.card({
    required this.children,
    super.key,
    this.header,
    this.footer,
    this.padding,
    this.margin,
    this.divider = false,
    this.backgroundColor,
    this.borderRadius,
    this.style,
  }) : _showCard = true,
       _insetPadding = false;

  /// Section whose rows are indented by an extra horizontal padding.
  ///
  /// ```dart
  /// VSection.inset(
  ///   header: Text('Details'),
  ///   children: detailItems,
  /// )
  /// ```
  const VSection.inset({
    required this.children,
    super.key,
    this.header,
    this.footer,
    this.padding,
    this.margin,
    this.divider = false,
    this.backgroundColor,
    this.borderRadius,
    this.style,
  }) : _showCard = false,
       _insetPadding = true;

  /// Rows of the section, laid out top to bottom.
  final List<Widget> children;

  /// Widget shown above the rows, in the section title style.
  final Widget? header;

  /// Widget shown below the rows, in the muted caption style.
  final Widget? footer;

  /// Space between the section edge and its content.
  final EdgeInsetsGeometry? padding;

  /// Space around the section.
  final EdgeInsetsGeometry? margin;

  /// Whether a thin line is drawn between neighbouring [children].
  final bool divider;

  /// Background color; the card variant defaults to the card color.
  final Color? backgroundColor;

  /// Corner radius; the card variant defaults to `theme.radius.card`.
  final BorderRadiusGeometry? borderRadius;

  /// Overrides the theme style, for example the title style and padding.
  final VSectionStyle? style;

  final bool _showCard;
  final bool _insetPadding;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Precedence: instance style > constructor argument > theme override >
    // variant default.
    final themeStyle = theme.componentOverrides.get<VSectionStyle>();
    final instanceStyle = style;

    // Determine padding
    final effectivePadding =
        instanceStyle?.padding ??
        padding ??
        themeStyle?.padding ??
        (_showCard
            ? EdgeInsets.all(theme.spacing.lg)
            : EdgeInsets.symmetric(horizontal: theme.spacing.lg));

    // Additional inner padding (inset variant)
    final contentPadding = _insetPadding
        ? EdgeInsets.symmetric(horizontal: theme.spacing.lg)
        : EdgeInsets.zero;

    // Determine background color
    final effectiveBackgroundColor =
        instanceStyle?.backgroundColor ??
        backgroundColor ??
        themeStyle?.backgroundColor ??
        (_showCard ? theme.colors.card : null);

    // Determine border radius
    final effectiveBorderRadius =
        borderRadius ??
        (_showCard ? BorderRadius.circular(theme.radius.card) : null);

    // Determine title style
    final effectiveTitleStyle =
        instanceStyle?.titleStyle ??
        themeStyle?.titleStyle ??
        theme.typography.titleSmall.copyWith(color: theme.colors.foreground);

    // Insert dividers between children
    final contentChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      contentChildren.add(children[i]);

      if (divider && i < children.length - 1) {
        contentChildren.add(
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            color: theme.colors.border,
          ),
        );
      }
    }

    // Content area
    final content = Padding(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: contentChildren,
      ),
    );

    // Plain Text in header/footer takes the section text styles.
    final headerWidget = header == null
        ? null
        : DefaultTextStyle.merge(style: effectiveTitleStyle, child: header!);
    final footerWidget = footer == null
        ? null
        : DefaultTextStyle.merge(
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
            child: footer!,
          );

    // Section container
    final section = Container(
      margin: margin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerWidget != null) ...[
            headerWidget,
            SizedBox(height: theme.spacing.sm),
          ],
          content,
          if (footerWidget != null) ...[
            SizedBox(height: theme.spacing.sm),
            footerWidget,
          ],
        ],
      ),
    );

    return Semantics(container: true, child: section);
  }
}

/// {@template v_section_header}
/// Section heading with a title, an optional subtitle and a trailing action.
///
/// [title] and [subtitle] are widgets; a plain [Text] takes the section title
/// and caption styles. Use it as [VSection.header].
///
/// ## Basic Usage:
///
/// ```dart
/// VSectionHeader(
///   title: Text('Settings'),
///   subtitle: Text('Modify app settings'),
/// )
/// ```
///
/// ## With Trailing Action:
///
/// ```dart
/// VSectionHeader(
///   title: Text('Recent Activity'),
///   trailing: TextButton(
///     onPressed: () {},
///     child: Text('See All'),
///   ),
/// )
/// ```
///
/// See also:
///
/// - [VSection], section container widget
/// - [VSectionFooter], section footer widget
/// {@endtemplate}
class VSectionHeader extends StatelessWidget {
  /// {@macro v_section_header}
  const VSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  /// Main heading, in the section title style.
  final Widget title;

  /// Line below [title], in the muted caption style.
  final Widget? subtitle;

  /// Widget at the end of the row, such as a "See All" button.
  final Widget? trailing;

  /// Space around the header; none by default.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                  style: theme.typography.titleSmall.copyWith(
                    color: theme.colors.foreground,
                  ),
                  child: title,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: theme.spacing.xxs),
                  DefaultTextStyle.merge(
                    style: theme.typography.bodySmall.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// {@template v_section_footer}
/// Muted caption under a section, for hints and legal text.
///
/// [child] is a widget; a plain [Text] takes the caption style. Use it as
/// [VSection.footer].
///
/// ## Basic Usage:
///
/// ```dart
/// VSectionFooter(
///   child: Text('Additional information here'),
/// )
/// ```
///
/// ## With Custom Widget:
///
/// ```dart
/// VSectionFooter(
///   child: Row(
///     children: [
///       Icon(Icons.info, size: 16),
///       SizedBox(width: 8),
///       Text('Learn more about this feature'),
///     ],
///   ),
/// )
/// ```
///
/// See also:
///
/// - [VSection], section container widget
/// - [VSectionHeader], section header widget
/// {@endtemplate}
class VSectionFooter extends StatelessWidget {
  /// {@macro v_section_footer}
  const VSectionFooter({required this.child, super.key, this.padding});

  /// Caption content, in the muted caption style.
  final Widget child;

  /// Space around the footer; none by default.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DefaultTextStyle.merge(
        style: theme.typography.bodySmall.copyWith(
          color: theme.colors.mutedForeground,
        ),
        child: child,
      ),
    );
  }
}
