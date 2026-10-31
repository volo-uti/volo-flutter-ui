import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_accordion_style.dart';

/// {@template v_accordion_item}
/// One collapsible section of a [VAccordion]: header slots plus hidden content.
///
/// ```dart
/// VAccordionItem(
///   leading: Icon(Icons.info),
///   title: Text('Shipping'),
///   subtitle: Text('Delivery times and fees'),
///   content: Text('Orders ship within two business days.'),
/// )
/// ```
/// {@endtemplate}
class VAccordionItem {
  /// Creates an accordion item.
  const VAccordionItem({
    required this.title,
    required this.content,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.id,
  });

  /// Header title, usually a [Text].
  final Widget title;

  /// Smaller line shown below [title].
  final Widget? subtitle;

  /// Leading icon.
  ///
  /// A widget displayed to the left of the title.
  final Widget? leading;

  /// Expandable content.
  ///
  /// The widget displayed when the item is expanded.
  final Widget content;

  /// Whether the header reacts to taps.
  ///
  /// When `false`, taps are ignored and the item is drawn at 50% opacity.
  final bool enabled;

  /// Identity that keeps this item's expanded state when the list changes.
  ///
  /// Give each item a unique id when items are inserted, removed or reordered.
  /// Without one, the state follows the item's position in the list.
  final Object? id;
}

/// {@template v_accordion}
/// Stack of collapsible sections where tapping a header shows or hides its content.
///
/// ```dart
/// VAccordion(
///   onExpansionChanged: (expanded) => debugPrint('open: $expanded'),
///   children: [
///     VAccordionItem(
///       title: Text('Section 1'),
///       content: Text('Content of the first section.'),
///     ),
///     VAccordionItem(
///       title: Text('Section 2'),
///       content: Text('Content of the second section.'),
///     ),
///   ],
/// )
/// ```
///
/// **Variants:**
///
/// - [VAccordion] - Default. Separated by dividers
/// - [VAccordion.separated] - Separated. Each item as an individual card
/// - [VAccordion.bordered] - Bordered. Wrapped with an outer border
///
/// **Multiple Expanded:**
///
/// ```dart
/// VAccordion(
///   allowMultiple: true,
///   initialExpanded: [0, 1],
///   children: [
///     VAccordionItem(title: Text('Section 1'), content: Text('Content 1')),
///     VAccordionItem(title: Text('Section 2'), content: Text('Content 2')),
///     VAccordionItem(title: Text('Section 3'), content: Text('Content 3')),
///   ],
/// )
/// ```
///
/// **Separated Style:**
///
/// ```dart
/// VAccordion.separated(
///   children: [
///     VAccordionItem(
///       leading: Icon(Icons.person),
///       title: Text('Profile Settings'),
///       subtitle: Text('Manage name, email, etc.'),
///       content: ProfileSettingsContent(),
///     ),
///     VAccordionItem(
///       leading: Icon(Icons.notifications),
///       title: Text('Notification Settings'),
///       subtitle: Text('Manage push notifications'),
///       content: NotificationSettingsContent(),
///     ),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VAccordionItem], individual items used in the accordion
/// - [VCard], a container for grouping related content
/// {@endtemplate}
class VAccordion extends StatefulWidget {
  /// {@macro v_accordion}
  ///
  /// Creates a default accordion. Items are separated by dividers.
  const VAccordion({
    required this.children,
    super.key,
    this.allowMultiple = false,
    this.initialExpanded,
    this.onExpansionChanged,
    this.divider = true,
    this.style,
  }) : _variant = _VAccordionVariant.normal;

  /// Separated accordion.
  ///
  /// Each item is displayed as an individual card.
  /// Visual separation is provided by spacing between items.
  const VAccordion.separated({
    required this.children,
    super.key,
    this.allowMultiple = false,
    this.initialExpanded,
    this.onExpansionChanged,
    this.style,
  }) : _variant = _VAccordionVariant.separated,
       divider = false;

  /// Bordered accordion.
  ///
  /// Wrapped with an outer border giving a grouped appearance.
  const VAccordion.bordered({
    required this.children,
    super.key,
    this.allowMultiple = false,
    this.initialExpanded,
    this.onExpansionChanged,
    this.divider = true,
    this.style,
  }) : _variant = _VAccordionVariant.bordered;

  final _VAccordionVariant _variant;

  /// List of items.
  ///
  /// A list of [VAccordionItem] instances.
  final List<VAccordionItem> children;

  /// Allow multiple expanded.
  ///
  /// When `true`, multiple items can be expanded simultaneously.
  /// When `false`, expanding one item automatically collapses the others.
  final bool allowMultiple;

  /// Initially expanded indices.
  ///
  /// A list of item indices that should be expanded on first render. Indices
  /// past the end of [children] are ignored, and when [allowMultiple] is
  /// `false` only the first index in the list is used.
  final List<int>? initialExpanded;

  /// Whether to show dividers between items.
  ///
  /// Ignored for [VAccordion.separated].
  final bool divider;

  /// Called with the sorted indices of all expanded items after a header is tapped.
  final ValueChanged<List<int>>? onExpansionChanged;

  /// Style override.
  final VAccordionStyle? style;

  @override
  State<VAccordion> createState() => _VAccordionState();
}

enum _VAccordionVariant { normal, separated, bordered }

class _VAccordionState extends State<VAccordion> {
  // Expanded items, by identity: the item's id, or its position when it has
  // none. Keeping identities (not bare indices) lets the state follow an item
  // when the list is reordered or an earlier item is removed.
  late Set<Object> _expanded;

  Object _identityOf(int index) {
    final id = widget.children[index].id;
    return id == null ? (null, index) : (id, null);
  }

  @override
  void initState() {
    super.initState();
    assert(
      widget.initialExpanded == null ||
          widget.initialExpanded!.isEmpty ||
          widget.initialExpanded!.every((i) => i >= 0),
      'VAccordion: initialExpanded indices must be non-negative',
    );
    _expanded = <Object>{};
    for (final index in widget.initialExpanded ?? const <int>[]) {
      if (index < 0 || index >= widget.children.length) continue;
      _expanded.add(_identityOf(index));
      // Single mode opens one item, so the first valid index wins.
      if (!widget.allowMultiple) break;
    }
  }

  @override
  void didUpdateWidget(VAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    final present = <Object>{
      for (var i = 0; i < widget.children.length; i++) _identityOf(i),
    };
    // Drop state of items that are gone, then enforce single mode.
    _expanded = _expanded.where(present.contains).toSet();
    if (!widget.allowMultiple && _expanded.length > 1) {
      final first = <Object>[
        for (var i = 0; i < widget.children.length; i++)
          if (_expanded.contains(_identityOf(i))) _identityOf(i),
      ].first;
      _expanded = {first};
    }
  }

  bool _isExpanded(int index) => _expanded.contains(_identityOf(index));

  // WHY: A set of identities supports allowMultiple mode. When allowMultiple
  // is false, clear() before add() ensures mutual exclusion (classic
  // accordion behavior).
  void _toggle(int index) {
    final item = widget.children[index];
    if (!item.enabled) return;

    final identity = _identityOf(index);
    setState(() {
      if (_expanded.contains(identity)) {
        _expanded.remove(identity);
      } else {
        if (!widget.allowMultiple) {
          _expanded.clear();
        }
        _expanded.add(identity);
      }
    });
    widget.onExpansionChanged?.call([
      for (var i = 0; i < widget.children.length; i++)
        if (_isExpanded(i)) i,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VAccordionStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    final borderColor = resolvedStyle?.borderColor ?? colors.border;
    final bgColor = resolvedStyle?.backgroundColor ?? colors.card;
    final borderRadius = resolvedStyle?.borderRadius ?? theme.radius.mdRadius;

    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      final item = widget.children[i];
      final isExpanded = _isExpanded(i);

      Widget itemWidget = _VAccordionItemWidget(
        // A keyed item keeps its animation state when the list is reordered.
        key: item.id == null ? null : ValueKey<Object>(item.id!),
        item: item,
        isExpanded: isExpanded,
        onToggle: () => _toggle(i),
        resolvedStyle: resolvedStyle,
      );

      if (widget._variant == _VAccordionVariant.separated) {
        itemWidget = Container(
          margin: i > 0 ? EdgeInsets.only(top: theme.spacing.sm) : null,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
          ),
          child: ClipRRect(borderRadius: borderRadius, child: itemWidget),
        );
      }

      items.add(itemWidget);

      if (widget.divider &&
          i < widget.children.length - 1 &&
          widget._variant != _VAccordionVariant.separated) {
        items.add(Container(height: 1, color: borderColor));
      }
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );

    if (widget._variant == _VAccordionVariant.bordered) {
      content = Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: borderRadius,
        ),
        child: ClipRRect(borderRadius: borderRadius, child: content),
      );
    }

    return FocusTraversalGroup(child: content);
  }
}

class _VAccordionItemWidget extends StatefulWidget {
  const _VAccordionItemWidget({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    super.key,
    this.resolvedStyle,
  });

  final VAccordionItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VAccordionStyle? resolvedStyle;

  @override
  State<_VAccordionItemWidget> createState() => _VAccordionItemWidgetState();
}

// WHY: Custom expand/collapse animation instead of AnimatedCrossFade —
// AnimatedCrossFade allocates two child widgets and cross-fades between them,
// wasting layout work. ClipRect + heightFactor only measures one child and
// clips the overflow, which is cheaper for content-heavy accordion panels.
class _VAccordionItemWidgetState extends State<_VAccordionItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _rotation;
  late Animation<double> _opacity;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeOut));
    _rotation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = _controller.drive(CurveTween(curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
  }

  @override
  void didUpdateWidget(_VAccordionItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final item = widget.item;
    final style = widget.resolvedStyle;

    final fgColor = style?.foregroundColor ?? colors.foreground;
    final iconColor = style?.iconColor ?? colors.mutedForeground;
    final headerPadding =
        style?.headerPadding ??
        EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.lg,
        );
    final contentPadding =
        style?.padding ??
        EdgeInsets.fromLTRB(
          theme.spacing.sm,
          0,
          theme.spacing.sm,
          theme.spacing.lg,
        );

    final titleWidget = DefaultTextStyle.merge(
      style: typography.bodyLarge.copyWith(color: fgColor),
      child: item.title,
    );

    final subtitleWidget = item.subtitle == null
        ? null
        : DefaultTextStyle.merge(
            style: typography.bodyMedium.copyWith(
              color: colors.mutedForeground,
            ),
            child: item.subtitle!,
          );

    return Opacity(
      opacity: item.enabled ? 1.0 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Focus(
            // A disabled header takes no focus, as it takes no taps.
            canRequestFocus: item.enabled,
            skipTraversal: !item.enabled,
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            onKeyEvent: (node, event) {
              // Enter and Space toggle a focused header like a tap.
              if (item.enabled &&
                  node.hasPrimaryFocus &&
                  event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                      event.logicalKey == LogicalKeyboardKey.space)) {
                widget.onToggle();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: Semantics(
              button: true,
              enabled: item.enabled,
              expanded: widget.isExpanded,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: item.enabled ? widget.onToggle : null,
                child: Container(
                  constraints: BoxConstraints(minHeight: theme.sizes.lg.height),
                  padding: headerPadding,
                  decoration: _isFocused && item.enabled
                      ? BoxDecoration(
                          borderRadius: theme.radius.smRadius,
                          border: Border.all(color: colors.ring, width: 2),
                        )
                      : null,
                  child: Row(
                    children: [
                      if (item.leading != null)
                        Padding(
                          padding: EdgeInsets.only(right: theme.spacing.md),
                          child: item.leading,
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleWidget,
                            if (subtitleWidget != null)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: theme.spacing.xxs,
                                ),
                                child: subtitleWidget,
                              ),
                          ],
                        ),
                      ),
                      RotationTransition(
                        turns: _rotation,
                        child: VIcons.chevronDown(
                          color: iconColor,
                          size: theme.sizes.md.iconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // PERF: Content child is passed as AnimatedBuilder.child — this
          // ensures the content widget tree is built once and reused across
          // animation frames, avoiding unnecessary rebuilds during expand/collapse.
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                // Collapsed content stays mounted but must not take focus or
                // be read out once it is closed.
                child: ExcludeFocus(
                  excluding: !widget.isExpanded,
                  child: ExcludeSemantics(
                    excluding: !widget.isExpanded && _controller.isDismissed,
                    child: Opacity(opacity: _opacity.value, child: child),
                  ),
                ),
              ),
              child: Padding(padding: contentPadding, child: item.content),
            ),
          ),
        ],
      ),
    );
  }
}
