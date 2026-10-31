import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/keyboard_navigation_mixin.dart';
import 'v_menu_style.dart';

/// Corner of its trigger where a [VMenu] opens.
enum VMenuPosition {
  /// Bottom start (default).
  bottomStart,

  /// Bottom end.
  bottomEnd,

  /// Top start.
  topStart,

  /// Top end.
  topEnd,
}

/// One selectable row of a [VMenu], with a child, icons and a tap callback.
///
/// ```dart
/// VMenuItem(
///   leading: Icon(Icons.delete),
///   destructive: true,
///   onTap: () => deleteItem(),
///   child: Text('Delete'),
/// )
/// ```
class VMenuItem {
  const VMenuItem({
    required this.child,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.destructive = false,
  });

  /// Content of the row, usually a [Text] that takes the menu text style.
  final Widget child;

  /// Widget before the child, such as an icon.
  final Widget? leading;

  /// Widget after the child, such as a shortcut hint.
  final Widget? trailing;

  /// Called when the row is tapped or activated with the keyboard.
  final VoidCallback? onTap;

  /// Whether the row reacts to input; false dims it and skips it on arrows.
  final bool enabled;

  /// Whether the row is drawn in the destructive color.
  final bool destructive;
}

/// Thin line that separates groups of [VMenuItem] rows in a [VMenu].
///
/// ```dart
/// VMenu(
///   trigger: VIconButton(icon: Icon(Icons.more_vert)),
///   items: [
///     VMenuItem(onTap: () {}, child: Text('Copy')),
///     VMenuDivider(),
///     VMenuItem(destructive: true, onTap: () {}, child: Text('Delete')),
///   ],
/// )
/// ```
class VMenuDivider extends VMenuItem {
  const VMenuDivider() : super(child: const SizedBox.shrink());
}

/// Popup menu of actions that opens below or above its trigger widget.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VMenu] shows a context menu when the trigger widget is tapped.
/// It supports icons, dividers, disabled items, and destructive actions.
///
/// ## Basic Usage
///
/// ```dart
/// VMenu(
///   trigger: VIconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
///   items: [
///     VMenuItem(onTap: () => edit(), child: Text('Edit')),
///     VMenuItem(onTap: () => share(), child: Text('Share')),
///     VMenuDivider(),
///     VMenuItem(
///       destructive: true,
///       onTap: () => delete(),
///       child: Text('Delete'),
///     ),
///   ],
/// )
/// ```
///
/// ## Menu with icons
///
/// ```dart
/// VMenu(
///   trigger: VButton(child: Text('Options'), onPressed: () {}),
///   items: [
///     VMenuItem(
///       leading: Icon(Icons.copy),
///       trailing: Text('Ctrl+C'),
///       onTap: () => copy(),
///       child: Text('Copy'),
///     ),
///     VMenuItem(
///       leading: Icon(Icons.paste),
///       trailing: Text('Ctrl+V'),
///       onTap: () => paste(),
///       child: Text('Paste'),
///     ),
///   ],
/// )
/// ```
///
/// ## Menu with disabled items
///
/// ```dart
/// VMenu(
///   trigger: VIconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
///   items: [
///     VMenuItem(onTap: () => undo(), child: Text('Undo')),
///     VMenuItem(enabled: false, onTap: () {}, child: Text('Redo')),
///   ],
/// )
/// ```
///
/// ## Positioned menu
///
/// Use [position] to control where the menu appears:
///
/// ```dart
/// VMenu(
///   position: VMenuPosition.topEnd,
///   trigger: VButton(child: Text('Menu'), onPressed: () {}),
///   items: [
///     VMenuItem(onTap: () {}, child: Text('Option 1')),
///     VMenuItem(onTap: () {}, child: Text('Option 2')),
///   ],
/// )
/// ```
///
/// Available positions: [VMenuPosition.bottomStart], [VMenuPosition.bottomEnd],
/// [VMenuPosition.topStart], [VMenuPosition.topEnd]
///
/// See also:
///
/// - [VMenuItem], for individual menu items
/// - [VMenuDivider], for separating menu sections
/// - [VDrawer], for full navigation panel
class VMenu extends StatefulWidget {
  const VMenu({
    required this.items,
    required this.trigger,
    super.key,
    this.position = VMenuPosition.bottomStart,
    this.closeOnSelect = true,
    this.style,
  });

  /// Rows of the menu, in order; use [VMenuDivider] to separate groups.
  final List<VMenuItem> items;

  /// Widget that opens the menu when tapped.
  final Widget trigger;

  /// Where the menu opens relative to the trigger.
  final VMenuPosition position;

  /// Whether the menu closes after an item is activated.
  final bool closeOnSelect;

  /// Overrides the theme's [VMenuStyle] for this menu.
  final VMenuStyle? style;

  @override
  State<VMenu> createState() => _VMenuState();
}

class _VMenuState extends State<VMenu> with KeyboardNavigationMixin<VMenu> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _triggerFocus = FocusNode(debugLabel: 'VMenu trigger');
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _triggerFocused = false;
  VThemeData? _capturedTheme;
  VMenuStyle? _capturedResolvedStyle;

  // KeyboardNavigationMixin: selectable items (excluding dividers)
  List<int> get _selectableIndices {
    final indices = <int>[];
    for (var i = 0; i < widget.items.length; i++) {
      if (widget.items[i] is! VMenuDivider) {
        indices.add(i);
      }
    }
    return indices;
  }

  @override
  int get itemCount => _selectableIndices.length;

  @override
  bool isItemEnabled(int index) {
    if (index < 0 || index >= _selectableIndices.length) return false;
    return widget.items[_selectableIndices[index]].enabled;
  }

  @override
  void onItemActivated(int index) {
    if (index < 0 || index >= _selectableIndices.length) return;
    final item = widget.items[_selectableIndices[index]];
    _onItemTap(item);
  }

  @override
  void onEscapePressed() {
    _closeMenu();
  }

  /// Maps focusedIndex (mixin) to the actual item index in widget.items.
  int get _actualFocusedItemIndex {
    if (focusedIndex < 0 || focusedIndex >= _selectableIndices.length) {
      return -1;
    }
    return _selectableIndices[focusedIndex];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _capturedTheme = VTheme.maybeOf(context);
    _updateResolvedStyle();
  }

  void _updateResolvedStyle() {
    final themeStyle = _capturedTheme?.componentOverrides.get<VMenuStyle>();
    _capturedResolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
  }

  @override
  void didUpdateWidget(VMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style != oldWidget.style) {
      _updateResolvedStyle();
    }
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    focusedIndex = -1;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    // Focus first enabled item after open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusFirst();
      _overlayEntry?.markNeedsBuild();
    });
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
      focusedIndex = -1;
    });
    // Hand focus back to the trigger so a keyboard user is not stranded.
    _triggerFocus.requestFocus();
  }

  void _onItemTap(VMenuItem item) {
    item.onTap?.call();
    if (widget.closeOnSelect) {
      _closeMenu();
    }
  }

  @override
  set focusedIndex(int value) {
    super.focusedIndex = value;
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final textDirection = Directionality.of(context);
    return OverlayEntry(
      builder: (context) => _buildOverlay(context, textDirection),
    );
  }

  Widget _buildOverlay(BuildContext context, TextDirection textDirection) =>
      Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: VColors.transparent),
            ),
          ),
          // Menu
          CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: _getTargetAnchor().resolve(textDirection),
            followerAnchor: _getFollowerAnchor().resolve(textDirection),
            child: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: Focus(
                autofocus: true,
                onKeyEvent: handleKeyEvent,
                child: _MenuContent(
                  items: widget.items,
                  onItemTap: _onItemTap,
                  themeData: _capturedTheme,
                  focusedItemIndex: _actualFocusedItemIndex,
                  resolvedStyle: _capturedResolvedStyle,
                ),
              ),
            ),
          ),
        ],
      );

  AlignmentDirectional _getTargetAnchor() => switch (widget.position) {
    VMenuPosition.bottomStart => AlignmentDirectional.bottomStart,
    VMenuPosition.bottomEnd => AlignmentDirectional.bottomEnd,
    VMenuPosition.topStart => AlignmentDirectional.topStart,
    VMenuPosition.topEnd => AlignmentDirectional.topEnd,
  };

  AlignmentDirectional _getFollowerAnchor() => switch (widget.position) {
    VMenuPosition.bottomStart => AlignmentDirectional.topStart,
    VMenuPosition.bottomEnd => AlignmentDirectional.topEnd,
    VMenuPosition.topStart => AlignmentDirectional.bottomStart,
    VMenuPosition.topEnd => AlignmentDirectional.bottomEnd,
  };

  @override
  void dispose() {
    _overlayEntry?.remove();
    _triggerFocus.dispose();
    super.dispose();
  }

  // Enter, Space and Arrow Down open a closed menu from the keyboard.
  KeyEventResult _handleTriggerKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _isOpen) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _openMenu();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.maybeOf(context);
    final showRing =
        _triggerFocused &&
        theme != null &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // WHY: The trigger is visual only: its own tap and focus are switched off
    // so the menu owns activation, for the pointer, the keyboard and the
    // screen reader alike (one labelled button that opens the menu).
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: _triggerFocus,
        onKeyEvent: _handleTriggerKey,
        onFocusChange: (focused) => setState(() => _triggerFocused = focused),
        child: MergeSemantics(
          child: Semantics(
            button: true,
            expanded: _isOpen,
            onTap: _toggleMenu,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: theme?.radius.smRadius,
                border: showRing
                    ? Border.all(color: theme.colors.ring, width: 2)
                    : null,
              ),
              child: Stack(
                children: [
                  // Trigger widget (visual only, taps ignored)
                  ExcludeFocus(child: IgnorePointer(child: widget.trigger)),
                  // Tap handler on top
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: GestureDetector(
                        onTap: _toggleMenu,
                        behavior: HitTestBehavior.opaque,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent({
    required this.items,
    required this.onItemTap,
    this.themeData,
    this.focusedItemIndex = -1,
    this.resolvedStyle,
  });

  final List<VMenuItem> items;
  final ValueChanged<VMenuItem> onItemTap;
  final VThemeData? themeData;
  final int focusedItemIndex;
  final VMenuStyle? resolvedStyle;

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();
    final colors = theme.colors;
    final typography = theme.typography;

    final bgColor = resolvedStyle?.backgroundColor ?? colors.popover;
    final borderColor = resolvedStyle?.borderColor ?? colors.border;
    final borderRadius = resolvedStyle?.borderRadius ?? theme.radius.mdRadius;
    final menuPadding =
        resolvedStyle?.padding ??
        EdgeInsets.symmetric(vertical: theme.spacing.xs);

    return DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
        color: resolvedStyle?.foregroundColor ?? colors.popoverForeground,
      ),
      child: IntrinsicWidth(
        child: Container(
          constraints: const BoxConstraints(minWidth: 180),
          margin: EdgeInsets.only(top: theme.spacing.xs),
          padding: menuPadding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
            boxShadow: theme.shadows.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(items.length, (index) {
              final item = items[index];
              if (item is VMenuDivider) {
                return Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: theme.spacing.xs),
                  color: colors.border,
                );
              }

              return _MenuItemWidget(
                item: item,
                colors: colors,
                typography: typography,
                onTap: () => onItemTap(item),
                isFocused: index == focusedItemIndex,
                itemPadding: resolvedStyle?.itemPadding,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MenuItemWidget extends StatefulWidget {
  const _MenuItemWidget({
    required this.item,
    required this.colors,
    required this.typography,
    required this.onTap,
    this.isFocused = false,
    this.itemPadding,
  });

  final VMenuItem item;
  final VColors colors;
  final VTypography typography;
  final VoidCallback onTap;
  final bool isFocused;
  final EdgeInsets? itemPadding;

  @override
  State<_MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  bool _isHovered = false;

  bool get _isEnabled => widget.item.enabled;

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = widget.colors;
    final typography = widget.typography;
    final item = widget.item;

    final textColor = !_isEnabled
        ? colors.mutedForeground.withValues(alpha: 0.5)
        : item.destructive
        ? colors.destructive
        : colors.popoverForeground;

    final labelStyle = typography.bodyMedium.copyWith(color: textColor);

    // Background color on hover or keyboard focus
    final backgroundColor = (_isHovered || widget.isFocused) && _isEnabled
        ? colors.accent
        : VColors.transparent;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      child: MouseRegion(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        cursor: _isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: _isEnabled ? widget.onTap : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: theme.animations.fast,
            padding:
                widget.itemPadding ??
                EdgeInsets.symmetric(
                  horizontal: theme.spacing.sm,
                  vertical: theme.spacing.xs,
                ),
            color: backgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.leading != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: theme.spacing.md),
                    child: IconTheme(
                      data: IconThemeData(
                        color: textColor,
                        size: theme.sizes.sm.iconSize,
                      ),
                      child: item.leading!,
                    ),
                  ),
                DefaultTextStyle.merge(style: labelStyle, child: item.child),
                if (item.trailing != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: theme.spacing.md,
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: textColor,
                        size: theme.sizes.sm.iconSize,
                      ),
                      child: item.trailing!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
