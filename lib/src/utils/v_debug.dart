import 'package:flutter/foundation.dart';

/// Component group used to filter [VDebug] output.
enum VDebugCategory {
  /// Input components (VTextField, VCheckbox, VSelect, etc.).
  input,

  /// Navigation components (VTabs, VBottomNav, etc.).
  navigation,

  /// Feedback components (VDialog, VSnackbar, etc.).
  feedback,
}

/// Opt-in debug log of component events.
///
/// Prints only in debug builds.
///
/// **Basic Usage:**
///
/// ```dart
/// void main() {
///   VDebug.enabled = true;
///   runApp(MyApp());
/// }
/// ```
///
/// **Category Filtering:**
///
/// ```dart
/// // Log only input components
/// VDebug.categories = {VDebugCategory.input};
///
/// // Log all categories (default)
/// VDebug.categories = {};
/// ```
///
/// **Output Example:**
///
/// ```
/// [14:30:45.123] [DEBUG] VTextField[email] >>> changed => test@example.com
/// [14:30:46.456] [DEBUG] VCheckbox[remember] >>> changed => true
/// ```
class VDebug {
  VDebug._();

  /// Global debug enabled flag (default: false).
  static bool enabled = false;

  /// Categories to enable (empty means all enabled).
  static Set<VDebugCategory> categories = {};

  /// Print a debug log.
  ///
  /// [category] Log category.
  /// [component] Component name (e.g. 'VTextField').
  /// [name] Component identifier (optional).
  /// [action] Action (e.g. 'changed', 'selected').
  /// [value] Value (optional).
  static void log({
    required VDebugCategory category,
    required String component,
    required String action,
    String? name,
    Object? value,
  }) {
    if (!enabled) return;
    if (!kDebugMode) return;
    if (categories.isNotEmpty && !categories.contains(category)) return;

    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    final nameStr = name != null ? '[$name]' : '';
    final valueStr = value != null ? ' => $value' : '';

    debugPrint('[$time] [DEBUG] $component$nameStr >>> $action$valueStr');
  }
}
