import 'package:flutter/scheduler.dart';
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

/// Opens and closes a [VMenu] from code outside its trigger.
///
/// Pass it to [VMenu.controller]. [show], [hide] and [toggle] work like a tap
/// on the trigger, and listeners hear every open and close, whether it comes
/// from code, a tap, a key, an item or a tap outside the menu. A menu that is
/// removed while open leaves its controller closed without notifying.
///
/// ```dart
/// final controller = VMenuController();
///
/// VMenu(controller: controller, trigger: trigger, items: items);
///
/// // Open the menu from elsewhere, such as a keyboard shortcut.
/// controller.show();
/// ```
class VMenuController extends ChangeNotifier {
  bool _isOpen = false;

  /// Whether the menu is open.
  bool get isOpen => _isOpen;

  /// Opens the menu; does nothing if it is already open.
  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Closes the menu; does nothing if it is already closed.
  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  /// Opens the menu if it is closed and closes it if it is open.
  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
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
/// ## Menu opened from code
///
/// ```dart
/// final controller = VMenuController();
///
/// VMenu(
///   controller: controller,
///   trigger: VIconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
///   items: [VMenuItem(onTap: () {}, child: Text('Rename'))],
/// )
///
/// // Elsewhere:
/// controller.show();
/// ```
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
    this.controller,
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

  /// Opens and closes the menu from outside its trigger.
  ///
  /// When null, the menu keeps its own open state. Taps, keys, items and taps
  /// outside the menu update the controller as well.
  final VMenuController? controller;

  /// Overrides the theme's [VMenuStyle] for this menu, such as its panel look.
  final VMenuStyle? style;

  @override
  State<VMenu> createState() => _VMenuState();
}

class _VMenuState extends State<VMenu> with KeyboardNavigationMixin<VMenu> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _triggerFocus = FocusNode(debugLabel: 'VMenu trigger');
  final FocusNode _menuFocus = FocusNode(debugLabel: 'VMenu panel');
  OverlayEntry? _overlayEntry;
  VMenuController? _internalController;
  late VMenuController _controller;
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

  VMenuController get _effectiveController =>
      widget.controller ?? (_internalController ??= VMenuController());

  bool get _isOpen => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    _controller = _effectiveController..addListener(_handleControllerChange);
    // A controller that is already open opens the menu once it can be shown.
    if (_controller.isOpen) _syncMenuAfterFrame();
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
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChange);
      // The old controller no longer drives an open menu.
      _controller._isOpen = false;
      _controller = _effectiveController..addListener(_handleControllerChange);
      _syncMenuAfterFrame();
    }
  }

  void _toggleMenu() => _controller.toggle();

  void _closeMenu() => _controller.hide();

  void _handleControllerChange() {
    // WHY: An overlay entry cannot be inserted or removed while the tree
    // builds, so a change made during a build waits for the frame.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      _syncMenuAfterFrame();
    } else {
      _syncMenu();
    }
  }

  void _syncMenuAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncMenu();
    });
  }

  void _syncMenu() {
    if (_controller.isOpen && _overlayEntry == null) {
      _showMenu();
    } else if (!_controller.isOpen && _overlayEntry != null) {
      _hideMenu();
    }
  }

  void _showMenu() {
    focusedIndex = -1;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
    // WHY: autofocus is ignored while the trigger holds focus, as it does
    // after Enter or a previous close, so the panel asks for focus itself and
    // then marks the first enabled item.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _overlayEntry == null) return;
      _menuFocus.requestFocus();
      focusFirst();
      _overlayEntry?.markNeedsBuild();
    });
  }

  void _hideMenu() {
    final menuHadFocus = _menuFocus.hasFocus;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => focusedIndex = -1);
    // Hand focus back to the trigger so a keyboard user is not stranded.
    if (menuHadFocus) _triggerFocus.requestFocus();
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
                focusNode: _menuFocus,
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
    _controller.removeListener(_handleControllerChange);
    // WHY: The tree is locked while it unmounts, so listeners cannot be told;
    // the controller is left closed so a later show() opens a new menu.
    _controller._isOpen = false;
    _internalController?.dispose();
    _overlayEntry?.remove();
    _menuFocus.dispose();
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
      _controller.show();
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
          constraints: BoxConstraints(minWidth: resolvedStyle?.minWidth ?? 180),
          margin: EdgeInsets.only(top: theme.spacing.xs),
          padding: menuPadding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor,
              width: resolvedStyle?.borderWidth ?? 1,
            ),
            boxShadow: resolvedStyle?.shadows ?? theme.shadows.lg,
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
