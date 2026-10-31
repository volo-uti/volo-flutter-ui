import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_resizable_style.dart';

/// Floating-point comparison tolerance.
const double _kSizeEpsilon = 0.0001;

/// Split layout with panels resized by drag or arrow keys.
///
/// Lay out [VResizablePanel]s with a [VResizableHandle] between each pair.
/// Panel sizes are ratios that always sum to 1. [onLayoutChanged] reports all
/// ratios after a drag or key press, and each panel reports its own through
/// [VResizablePanel.onSizeChanged].
///
/// **Basic Usage:**
///
/// ```dart
/// VResizablePanelGroup(
///   direction: Axis.horizontal,
///   children: [
///     VResizablePanel(
///       defaultSize: 0.3,
///       child: Sidebar(),
///     ),
///     VResizableHandle(),
///     VResizablePanel(
///       defaultSize: 0.7,
///       child: MainContent(),
///     ),
///   ],
/// )
/// ```
///
/// **Vertical Layout:**
///
/// ```dart
/// VResizablePanelGroup(
///   direction: Axis.vertical,
///   children: [
///     VResizablePanel(defaultSize: 0.6, child: Editor()),
///     VResizableHandle(),
///     VResizablePanel(defaultSize: 0.4, child: Terminal()),
///   ],
/// )
/// ```
///
/// **With Constraints:**
///
/// ```dart
/// VResizablePanelGroup(
///   children: [
///     VResizablePanel(
///       defaultSize: 0.25,
///       minSize: 0.15,
///       maxSize: 0.4,
///       child: Sidebar(),
///     ),
///     VResizableHandle(),
///     VResizablePanel(
///       defaultSize: 0.75,
///       minSize: 0.6,
///       child: Content(),
///     ),
///   ],
/// )
/// ```
class VResizablePanelGroup extends StatefulWidget {
  /// Creates a resizable panel group.
  const VResizablePanelGroup({
    required this.children,
    super.key,
    this.direction = Axis.horizontal,
    this.onLayoutChanged,
    this.style,
  });

  /// [VResizablePanel]s separated by [VResizableHandle]s, in order.
  final List<Widget> children;

  /// Axis the panels are laid out along.
  final Axis direction;

  /// Called with every panel ratio after a drag ends or a key press resizes.
  final ValueChanged<List<double>>? onLayoutChanged;

  /// Overrides the theme style, for example the handle size and colors.
  final VResizableStyle? style;

  @override
  State<VResizablePanelGroup> createState() => _VResizablePanelGroupState();
}

class _VResizablePanelGroupState extends State<VResizablePanelGroup> {
  final List<double> _sizes = [];
  final List<_PanelConfig> _panelConfigs = [];
  int _draggingHandleIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializePanels();
  }

  List<VResizablePanel> get _panels =>
      widget.children.whereType<VResizablePanel>().toList();

  @override
  void didUpdateWidget(VResizablePanelGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldPanels = oldWidget.children.whereType<VResizablePanel>().toList();
    final panels = _panels;
    final sameShape =
        oldPanels.length == panels.length &&
        oldWidget.children.length == widget.children.length;
    final sameDefaults =
        sameShape &&
        [
          for (var i = 0; i < panels.length; i++)
            oldPanels[i].defaultSize == panels[i].defaultSize,
        ].every((same) => same);
    if (!sameDefaults) {
      // A different panel count or default size starts the layout over.
      _initializePanels();
      return;
    }
    // Limits and collapse settings may change without disturbing the layout.
    for (var i = 0; i < panels.length; i++) {
      _panelConfigs[i] = _PanelConfig.of(panels[i])
        ..previousSize = _panelConfigs[i].previousSize
        ..collapsed = _panelConfigs[i].collapsed;
    }
  }

  void _initializePanels() {
    _sizes.clear();
    _panelConfigs.clear();

    for (final child in _panels) {
      _sizes.add(child.defaultSize);
      _panelConfigs.add(_PanelConfig.of(child));
    }

    // Normalize sizes if they don't sum to 1
    final total = _sizes.fold<double>(0, (sum, size) => sum + size);
    if (total > 0 && (total - 1).abs() > _kSizeEpsilon) {
      for (var i = 0; i < _sizes.length; i++) {
        _sizes[i] = _sizes[i] / total;
      }
    }
  }

  void _handleDragStart(int handleIndex) {
    setState(() {
      _draggingHandleIndex = handleIndex;
    });
  }

  void _handleDragUpdate(int handleIndex, double delta, double availableSize) {
    if (handleIndex < 0 || handleIndex >= _sizes.length - 1) return;
    if (availableSize <= 0) return;

    final leftIndex = handleIndex;
    final rightIndex = handleIndex + 1;
    final deltaRatio = delta / availableSize;
    final left = _panelConfigs[leftIndex];
    final right = _panelConfigs[rightIndex];
    final sizeLeft = _sizes[leftIndex];
    final sizeRight = _sizes[rightIndex];

    // WHY: Clamp the move itself, not each size on its own. The two panels
    // trade space, so a limit on either one stops the drag; clamping the sizes
    // separately broke the neighbour's limit. A panel that already violates a
    // limit may stay put (the range always contains 0) but not move further
    // out.
    final lowest = math.min(
      0,
      math.max(left.minSize - sizeLeft, sizeRight - right.maxSize),
    );
    final highest = math.max(
      0,
      math.min(left.maxSize - sizeLeft, sizeRight - right.minSize),
    );
    final move = deltaRatio.clamp(lowest, highest).toDouble();

    // Only update if there's actual change
    if (move.abs() <= _kSizeEpsilon / 100) return;

    setState(() {
      _sizes[leftIndex] = sizeLeft + move;
      _sizes[rightIndex] = sizeRight - move;
    });

    _notifySizeChanged({leftIndex, rightIndex});
  }

  void _notifySizeChanged(Set<int> indices) {
    final panels = _panels;
    for (final i in indices) {
      panels[i].onSizeChanged?.call(_sizes[i]);
    }
  }

  void _handleDragEnd() {
    setState(() {
      _draggingHandleIndex = -1;
    });
    widget.onLayoutChanged?.call(List.from(_sizes));
  }

  /// Toggles the collapsible panel next to handle [handleIndex]: the panel on
  /// its left first, otherwise the one on its right.
  void _handleCollapse(int handleIndex) {
    final leftIndex = handleIndex;
    final rightIndex = handleIndex + 1;
    if (leftIndex < 0 || rightIndex >= _panelConfigs.length) return;

    final int panelIndex;
    if (_panelConfigs[leftIndex].collapsible) {
      panelIndex = leftIndex;
    } else if (_panelConfigs[rightIndex].collapsible) {
      panelIndex = rightIndex;
    } else {
      return;
    }
    final neighbourIndex = panelIndex == leftIndex ? rightIndex : leftIndex;

    final config = _panelConfigs[panelIndex];
    final neighbourConfig = _panelConfigs[neighbourIndex];
    final panel = _panels[panelIndex];
    final isCollapsed =
        config.collapsed &&
        (_sizes[panelIndex] - config.collapsedSize).abs() <= 0.001;

    setState(() {
      // The neighbour gives and takes the space, so the total stays constant.
      if (isCollapsed) {
        final previous = config.previousSize;
        final wanted =
            previous != null && previous > config.collapsedSize + 0.001
            ? previous
            : 0.2;
        final spare = _sizes[neighbourIndex] - neighbourConfig.minSize;
        final room = spare > 0 ? spare : _sizes[neighbourIndex] / 2;
        final grow = math.min(wanted - _sizes[panelIndex], room);
        if (grow > 0) {
          _sizes[panelIndex] += grow;
          _sizes[neighbourIndex] -= grow;
        }
        config.collapsed = false;
      } else {
        config.previousSize = _sizes[panelIndex];
        final freed = _sizes[panelIndex] - config.collapsedSize;
        _sizes[panelIndex] = config.collapsedSize;
        _sizes[neighbourIndex] += freed;
        config.collapsed = true;
      }
    });

    if (isCollapsed) {
      panel.onExpand?.call();
    } else {
      panel.onCollapse?.call();
    }
    _notifySizeChanged({panelIndex, neighbourIndex});
    widget.onLayoutChanged?.call(List.from(_sizes));
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VResizableStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final handleSize = resolvedStyle?.handleSize ?? 4.0;
        final handleCount = widget.children
            .whereType<VResizableHandle>()
            .length;
        final availableSize = totalSize - handleCount * handleSize;

        return _ResizableGroupScope(
          direction: widget.direction,
          sizes: _sizes,
          panelConfigs: _panelConfigs,
          draggingHandleIndex: _draggingHandleIndex,
          availableSize: availableSize,
          resolvedStyle: resolvedStyle,
          onDragStart: _handleDragStart,
          onDragUpdate: _handleDragUpdate,
          onDragEnd: _handleDragEnd,
          onCollapse: _handleCollapse,
          child: widget.direction == Axis.horizontal
              ? Row(children: _buildChildren(availableSize))
              : Column(children: _buildChildren(availableSize)),
        );
      },
    );
  }

  List<Widget> _buildChildren(double availableSize) {
    final result = <Widget>[];
    var panelIndex = 0;
    var handleIndex = 0;

    for (final child in widget.children) {
      if (child is VResizablePanel) {
        final size = _sizes[panelIndex] * availableSize;
        result.add(
          SizedBox(
            width: widget.direction == Axis.horizontal ? size : null,
            height: widget.direction == Axis.vertical ? size : null,
            child: child,
          ),
        );
        panelIndex++;
      } else if (child is VResizableHandle) {
        result.add(_ResizableHandleWrapper(index: handleIndex, child: child));
        handleIndex++;
      } else {
        result.add(child);
      }
    }

    return result;
  }
}

class _PanelConfig {
  _PanelConfig({
    required this.minSize,
    required this.maxSize,
    required this.collapsible,
    required this.collapsedSize,
  });

  factory _PanelConfig.of(VResizablePanel panel) => _PanelConfig(
    minSize: panel.minSize,
    maxSize: panel.maxSize,
    collapsible: panel.collapsible,
    collapsedSize: panel.collapsedSize,
  );

  final double minSize;
  final double maxSize;
  final bool collapsible;
  final double collapsedSize;

  /// Stored size before collapse (set at runtime).
  double? previousSize;

  /// Whether the panel was collapsed by a toggle and not resized since.
  bool collapsed = false;
}

/// Moves handle [handle] by [delta] pixels; panels share [availableSize].
typedef _HandleDragUpdate =
    void Function(int handle, double delta, double availableSize);

class _ResizableGroupScope extends InheritedWidget {
  const _ResizableGroupScope({
    required this.direction,
    required this.sizes,
    required this.panelConfigs,
    required this.draggingHandleIndex,
    required this.availableSize,
    required this.resolvedStyle,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onCollapse,
    required super.child,
  });

  final Axis direction;
  final List<double> sizes;
  final List<_PanelConfig> panelConfigs;
  final int draggingHandleIndex;
  final double availableSize;
  final VResizableStyle? resolvedStyle;
  final ValueChanged<int> onDragStart;
  final _HandleDragUpdate onDragUpdate;
  final VoidCallback onDragEnd;
  final ValueChanged<int> onCollapse;

  static _ResizableGroupScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ResizableGroupScope>();

  @override
  bool updateShouldNotify(_ResizableGroupScope oldWidget) =>
      direction != oldWidget.direction ||
      sizes != oldWidget.sizes ||
      draggingHandleIndex != oldWidget.draggingHandleIndex ||
      availableSize != oldWidget.availableSize ||
      resolvedStyle != oldWidget.resolvedStyle;
}

/// One panel of a [VResizablePanelGroup] with a size ratio and limits.
///
/// ```dart
/// VResizablePanel(
///   defaultSize: 0.3,
///   minSize: 0.2,
///   collapsible: true,
///   onSizeChanged: (ratio) => debugPrint('sidebar $ratio'),
///   child: Sidebar(),
/// )
/// ```
class VResizablePanel extends StatelessWidget {
  /// Creates a resizable panel.
  const VResizablePanel({
    required this.child,
    required this.defaultSize,
    super.key,
    this.minSize = 0.0,
    this.maxSize = 1.0,
    this.collapsible = false,
    this.collapsedSize = 0.0,
    this.onCollapse,
    this.onExpand,
    this.onSizeChanged,
  });

  /// Content of the panel, clipped to its bounds.
  final Widget child;

  /// Initial share of the group between 0 and 1; shares are normalised to sum 1.
  final double defaultSize;

  /// Smallest share the panel can be dragged to.
  final double minSize;

  /// Largest share the panel can be dragged to.
  final double maxSize;

  /// Whether double-tapping the neighbouring handle collapses and expands it.
  final bool collapsible;

  /// Share the panel keeps while collapsed.
  final double collapsedSize;

  /// Called when the panel is collapsed.
  final VoidCallback? onCollapse;

  /// Called when the panel is expanded again.
  final VoidCallback? onExpand;

  /// Called with the new share while a handle next to the panel moves.
  final ValueChanged<double>? onSizeChanged;

  @override
  Widget build(BuildContext context) => ClipRect(child: child);
}

class _ResizableHandleWrapper extends StatelessWidget {
  const _ResizableHandleWrapper({required this.index, required this.child});

  final int index;
  final VResizableHandle child;

  @override
  Widget build(BuildContext context) {
    final scope = _ResizableGroupScope.of(context);
    if (scope == null) return child;

    return _ResizableHandleWithState(
      index: index,
      direction: scope.direction,
      enabled: child.enabled,
      withHandle: child.withHandle,
      onDragStart: () => scope.onDragStart(index),
      onDragUpdate: (delta) =>
          scope.onDragUpdate(index, delta, scope.availableSize),
      onDragEnd: scope.onDragEnd,
      onDoubleTap: () => scope.onCollapse(index),
    );
  }
}

class _ResizableHandleWithState extends StatefulWidget {
  const _ResizableHandleWithState({
    required this.index,
    required this.direction,
    required this.enabled,
    required this.withHandle,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDoubleTap,
  });

  final int index;
  final Axis direction;
  final bool enabled;
  final bool withHandle;
  final VoidCallback onDragStart;
  final ValueChanged<double> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onDoubleTap;

  @override
  State<_ResizableHandleWithState> createState() =>
      _ResizableHandleWithStateState();
}

class _ResizableHandleWithStateState extends State<_ResizableHandleWithState> {
  bool _isHovered = false;
  bool _isDragging = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  /// Keyboard resize step in pixels.
  static const double _keyboardStep = 10;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Handle keyboard events for resizing (WCAG 2.2 SC 2.5.7).
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!widget.enabled) return KeyEventResult.ignored;

    final isHorizontal = widget.direction == Axis.horizontal;

    final key = event.logicalKey;
    final double delta;
    if (key ==
        (isHorizontal
            ? LogicalKeyboardKey.arrowLeft
            : LogicalKeyboardKey.arrowUp)) {
      delta = -_keyboardStep;
    } else if (key ==
        (isHorizontal
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.arrowDown)) {
      delta = _keyboardStep;
    } else {
      return KeyEventResult.ignored;
    }

    widget.onDragUpdate(delta);
    // A key press is a complete resize, so report the layout like a drag end.
    widget.onDragEnd();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final scope = _ResizableGroupScope.of(context);
    final resolvedStyle = scope?.resolvedStyle;
    final isHorizontal = widget.direction == Axis.horizontal;

    final effectiveHandleColor =
        resolvedStyle?.handleColor ?? theme.colors.border;
    final effectiveBorderColor =
        resolvedStyle?.borderColor ?? theme.colors.ring;
    final effectiveHandleSize = resolvedStyle?.handleSize ?? 4.0;

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: MouseRegion(
        cursor: !widget.enabled
            ? SystemMouseCursors.basic
            : (isHorizontal
                  ? SystemMouseCursors.resizeColumn
                  : SystemMouseCursors.resizeRow),
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onDoubleTap: !widget.enabled ? null : widget.onDoubleTap,
          onHorizontalDragStart: widget.enabled && isHorizontal
              ? (_) => _onDragStart()
              : null,
          onHorizontalDragUpdate: widget.enabled && isHorizontal
              ? (details) => widget.onDragUpdate(details.delta.dx)
              : null,
          onHorizontalDragEnd: widget.enabled && isHorizontal
              ? (_) => _onDragEnd()
              : null,
          onVerticalDragStart: widget.enabled && !isHorizontal
              ? (_) => _onDragStart()
              : null,
          onVerticalDragUpdate: widget.enabled && !isHorizontal
              ? (details) => widget.onDragUpdate(details.delta.dy)
              : null,
          onVerticalDragEnd: widget.enabled && !isHorizontal
              ? (_) => _onDragEnd()
              : null,
          child: Container(
            width: isHorizontal ? effectiveHandleSize : double.infinity,
            height: isHorizontal ? double.infinity : effectiveHandleSize,
            decoration: BoxDecoration(
              color: (_isHovered || _isDragging || _isFocused) && widget.enabled
                  ? theme.colors.muted
                  : null,
              border: _isFocused && widget.enabled
                  ? Border.all(color: effectiveBorderColor)
                  : null,
            ),
            child: widget.withHandle
                ? Center(
                    child: Container(
                      width: isHorizontal ? effectiveHandleSize : 16,
                      height: isHorizontal ? 16 : effectiveHandleSize,
                      decoration: BoxDecoration(
                        color: effectiveHandleColor,
                        borderRadius: theme.radius.xsRadius,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void _onDragStart() {
    setState(() => _isDragging = true);
    widget.onDragStart();
  }

  void _onDragEnd() {
    setState(() => _isDragging = false);
    widget.onDragEnd();
  }
}

/// Draggable divider between two [VResizablePanel]s in a group.
///
/// Drag it, press the arrow keys while it has focus, or double-tap it to
/// collapse a collapsible panel. It renders nothing outside a
/// [VResizablePanelGroup].
///
/// ```dart
/// VResizableHandle(withHandle: false, enabled: !locked)
/// ```
class VResizableHandle extends StatelessWidget {
  /// Creates a resize handle.
  const VResizableHandle({
    super.key,
    this.withHandle = true,
    this.enabled = true,
  });

  /// Whether a small grip is drawn in the middle of the handle.
  final bool withHandle;

  /// Whether the handle reacts to drag, keys and double-tap.
  final bool enabled;

  @override
  Widget build(BuildContext context) =>
      // This is just a placeholder; actual rendering is handled by _ResizableHandleWrapper
      const SizedBox.shrink();
}
