import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// WHY: Mixin instead of base class — widgets already extend State<T> and
// Dart has no multiple inheritance. Mixin composition lets VSelect, VMenu,
// VAutocomplete etc. share keyboard nav without a forced class hierarchy.
// DEPENDS: Consuming widget must provide itemCount, isItemEnabled, and
// onItemActivated. FocusNode must be attached to the host widget tree.
/// Arrow, Home, End, Enter and Escape navigation for lists.
mixin KeyboardNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Number of navigable items.
  int get itemCount;

  /// Whether the item at [index] can take focus; all items by default.
  bool isItemEnabled(int index) => true;

  /// Called when Enter or Space activates the focused item at [index].
  void onItemActivated(int index);

  /// Called when Escape is pressed; does nothing by default.
  void onEscapePressed() {}

  /// Axis along which the arrow keys move focus.
  Axis get navigationAxis => Axis.vertical;

  /// Whether focus wraps from the last item to the first and back.
  bool get wrapAround => true;

  int _focusedIndex = -1;

  /// Index of the focused item, or -1 when none is focused.
  int get focusedIndex => _focusedIndex;

  /// Moves focus to [value] and rebuilds the host state.
  set focusedIndex(int value) {
    if (_focusedIndex != value) {
      setState(() => _focusedIndex = value);
    }
  }

  /// Moves focus to the next enabled item.
  void focusNext() {
    if (itemCount == 0) return;
    var next = _focusedIndex;
    for (var i = 0; i < itemCount; i++) {
      next = wrapAround
          ? (next + 1) % itemCount
          : (next + 1).clamp(0, itemCount - 1);
      if (isItemEnabled(next)) {
        focusedIndex = next;
        return;
      }
      if (!wrapAround && next == itemCount - 1) return;
    }
  }

  /// Moves focus to the previous enabled item.
  void focusPrevious() {
    if (itemCount == 0) return;
    // WHY: From "nothing focused" (-1) the first step must land on the last
    // item, so start one past the end.
    var prev = _focusedIndex < 0 ? itemCount : _focusedIndex;
    for (var i = 0; i < itemCount; i++) {
      prev = wrapAround
          ? (prev - 1 + itemCount) % itemCount
          : (prev - 1).clamp(0, itemCount - 1);
      if (isItemEnabled(prev)) {
        focusedIndex = prev;
        return;
      }
      if (!wrapAround && prev == 0) return;
    }
  }

  /// Moves focus to the first enabled item.
  void focusFirst() {
    for (var i = 0; i < itemCount; i++) {
      if (isItemEnabled(i)) {
        focusedIndex = i;
        return;
      }
    }
  }

  /// Moves focus to the last enabled item.
  void focusLast() {
    for (var i = itemCount - 1; i >= 0; i--) {
      if (isItemEnabled(i)) {
        focusedIndex = i;
        return;
      }
    }
  }

  // WHY: Handle both KeyDownEvent and KeyRepeatEvent — holding an arrow key
  // should continuously scroll through items (standard OS behavior).
  // KeyUpEvent is intentionally ignored to prevent double-firing.
  /// Handles arrow, Home, End, Enter, Space and Escape key events.
  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final isVertical = navigationAxis == Axis.vertical;
    final nextKey = isVertical
        ? LogicalKeyboardKey.arrowDown
        : LogicalKeyboardKey.arrowRight;
    final prevKey = isVertical
        ? LogicalKeyboardKey.arrowUp
        : LogicalKeyboardKey.arrowLeft;

    if (event.logicalKey == nextKey) {
      focusNext();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == prevKey) {
      focusPrevious();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      focusFirst();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      focusLast();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_focusedIndex >= 0 &&
          _focusedIndex < itemCount &&
          isItemEnabled(_focusedIndex)) {
        onItemActivated(_focusedIndex);
        return KeyEventResult.handled;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      onEscapePressed();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
