# v_debug

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDebugCategory

Component group used to filter [VDebug] output.

### Values

| Value | Description |
|---|---|
| `input` | Input components (VTextField, VCheckbox, VSelect, etc.). |
| `navigation` | Navigation components (VTabs, VBottomNav, etc.). |
| `feedback` | Feedback components (VDialog, VSnackbar, etc.). |

## VDebug

Opt-in debug log of component events.

Prints only in debug builds.

**Basic Usage:**

```dart
void main() {
  VDebug.enabled = true;
  runApp(MyApp());
}
```

**Category Filtering:**

```dart
// Log only input components
VDebug.categories = {VDebugCategory.input};

// Log all categories (default)
VDebug.categories = {};
```

**Output Example:**

```
[14:30:45.123] [DEBUG] VTextField[email] >>> changed => test@example.com
[14:30:46.456] [DEBUG] VCheckbox[remember] >>> changed => true
```

### Members

| Member | Description |
|---|---|
| `static bool enabled` | Global debug enabled flag (default: false). |
| `static Set<VDebugCategory> categories` | Categories to enable (empty means all enabled). |
| `static void log({required VDebugCategory category, required String component, required String action, String? name, Object? value})` | Print a debug log.<br>[category] Log category. [component] Component name (e.g. 'VTextField'). [name] Component identifier (optional). [action] Action (e.g. 'changed', 'selected'). [value] Value (optional). |
