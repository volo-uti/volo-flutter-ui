# volo_flutter_ui

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

> **Flutter UI beyond Material.** Token-driven components for mobile and desktop apps.

A composable UI component library free from Material Design constraints. Build any brand identity with 9 design token types and a full set of components.

## Features

- **Zero Material Dependencies** -- Built on Flutter SDK only, no Material widget dependency. Full design freedom.
- **9 Design Token Systems** -- Colors, Typography, Spacing, Sizes, Radius, Shadows, Borders, Gradients, Animations. One token source drives the entire UI.
- **Components** -- Components across 6 categories: Inputs, Data Display, Feedback, Surfaces, Navigation, Layout.
- **Mobile and Desktop** -- iOS, Android, macOS, Windows, Linux. Tokens are generated from one DTCG JSON source (`make tokens`).
- **Accessible by Default** -- Semantic labels, keyboard navigation, focus management built into every component.

## Quick Start

### 1. Add dependency

```yaml
dependencies:
  volo_flutter_ui:
    git:
      url: https://github.com/volo-uti/volo-flutter-ui.git
      ref: v0.1.1 # a release tag
```

The package is distributed through GitHub, not pub.dev: a release tag (`v<version>`, equal to `version` in `pubspec.yaml`) is the version a product depends on.

```bash
flutter pub get
```

### 2. Wrap with VTheme

```dart
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() => runApp(
  VTheme(
    data: VThemeData.light(),
    child: WidgetsApp(
      color: const Color(0xFF000000),
      builder: (context, _) => const MyHomePage(),
    ),
  ),
);
```

### 3. Use components

```dart
VButton(
  onPressed: () {},
  child: Text('Click me'),
)

VTextField(
  name: 'email',
  label: 'Email',
  placeholder: 'you@example.com',
)

VAlert.success(
  title: Text('Saved'),
  description: Text('Your changes have been saved.'),
)
```

## Adding it to a product

Run the index step below before you plan or write any UI. It is what tells a coding agent which widgets already exist, so it does not rebuild them.

1. Add the dependency and import it.

   ```yaml
   dependencies:
     volo_flutter_ui:
       git:
         url: https://github.com/volo-uti/volo-flutter-ui.git
         ref: v0.1.1 # a release tag
   ```

2. Wrap the app root in `VApp` (or `VTheme` + `WidgetsApp`). `VApp` wraps `VTheme` and follows the system brightness. When a router (go_router and the like) builds the pages, use `VApp.router` with its router config.

   ```dart
   void main() => runApp(const VApp(home: MyHomePage()));

   // With a router config
   void main() => runApp(VApp.router(routerConfig: router));
   ```

   If the app keeps its own `MaterialApp` (or `MaterialApp.router`) for reasons other than routing, with its own `themeMode`, keep that as the one owner of light and dark: wrap the routes in `VTheme` from its `builder`, so V widgets follow the theme it resolved. A `VTheme` with fixed data above the app stays light when the app switches to dark.

   ```dart
   MaterialApp.router(
     theme: lightTheme,
     darkTheme: darkTheme,
     themeMode: themeMode,
     routerConfig: router,
     builder: (context, child) => VTheme(
       data: Theme.of(context).brightness == Brightness.dark
           ? VThemeData.dark()
           : VThemeData.light(),
       child: child!,
     ),
   )
   ```

3. Write the index once so coding agents can find the existing widgets. A `volo-flutter-ui-index` block appears in the product's `AGENTS.md`.

   ```bash
   dart run volo_flutter_ui:agent_index
   ```

   After upgrading the package, run the same command to refresh it. Add `--check` to the product's own checks.

   ```bash
   dart run volo_flutter_ui:agent_index --check
   ```

4. Add a check to the product so raw Material widgets (`ElevatedButton`, `TextButton`, `IconButton` ...) do not slip in. It fails and names the widget to use instead.

   ```bash
   dart run volo_flutter_ui:raw_widgets lib/features
   ```

   You can pass several folders in a row (`raw_widgets lib/features lib/shared`). Start with the feature folders where new code goes. Replace raw widgets in the existing app shell (`lib/app` and the like) with V widgets when you first adopt the package, and leave the shell out of the check until then.

Each widget has a doc with a parameter table under the package's `doc/` folder (the paths in the index are relative to that folder).

## When something is missing

If a widget almost fits, try its style parameters first. If one detail still cannot be done, write only that detail by hand in the product, mark it `// TODO(library: <what is missing>)` with what you tried, and open an issue in this repository. Do not copy or rebuild the whole widget. When the package gets the detail, upgrade it and delete the marker. Search for `TODO(library:` to see what is still open.

## Components

| Category | Key Components |
|----------|----------------|
| **Inputs** | VButton, VTextField, VSelect, VCheckbox, VRadio, VSwitch, VSlider, VCalendar, VDatePicker, VAutocomplete, VForm, VFormField |
| **Data Display** | VAvatar, VBadge, VChip, VTable, VTooltip, VListTile, VCheckListTile, VSwitchListTile, VDismissible, VDivider, VHoverCard |
| **Feedback** | VDialog, VAlertDialog, VAlert, VToast, VSnackbar, VProgress, VSkeleton, VEmptyState, VBackdrop |
| **Surfaces** | VCard, VSheet, VAccordion, VPopover |
| **Navigation** | VAppBar, VBottomNav, VTabs, VBreadcrumb, VPagination, VPageIndicator, VStepper, VDrawer, VMenu, VCommand |
| **Layout** | VScaffold, VGrid, VStack, VBox, VCarousel, VScrollArea, VSection, VResizable |

## Theming

volo_flutter_ui uses an `InheritedWidget`-based theme system with 9 design token types. No Material `ThemeData` required.

### Light & Dark

```dart
// Light theme (default)
VTheme(data: VThemeData.light(), child: ...)

// Dark theme
VTheme(data: VThemeData.dark(), child: ...)
```

### Custom Theme

```dart
VTheme(
  data: VThemeData(
    brightness: Brightness.light,
    colors: VColors.light.copyWith(primary: Color(0xFF6750A4)),
    typography: VTypography.defaults,
    spacing: VSpacing.defaults,
    radius: VRadius.defaults,
    shadows: VShadows.light,
    animations: VAnimations.defaults,
    sizes: VSizes.defaults,
    borders: VBorders.light,
    gradients: VGradients.defaults,
  ),
  child: ...,
)
```

### Accessing Tokens

```dart
// Via VTheme.of
final theme = VTheme.of(context);
theme.colors.primary;
theme.spacing.md;
theme.radius.lg;

// Via extension shortcuts
context.vColors.primary;
context.vSpacing.md;
context.vRadius.lg;
context.vTypography.bodyMedium;
context.vShadows.md;
context.vAnimations.fast;
```

### Design Tokens

| Token | Class | Description |
|-------|-------|-------------|
| Colors | `VColors` | 32 color properties (primary, secondary, success, warning, error, info, etc.) |
| Typography | `VTypography` | 15 text styles (Display/Headline/Title/Body/Label x 3 sizes) |
| Spacing | `VSpacing` | 11 spacing values (xxs 2px to sixXL 64px) |
| Sizes | `VSizes` | 5 component sizes (xs/sm/md/lg/xl) with height, padding, fontSize |
| Radius | `VRadius` | 8 border radius values (none 0px to full 9999px) |
| Shadows | `VShadows` | 6 shadow levels (xs to glow), separate Light/Dark values |
| Borders | `VBorders` | 3 border styles (default, strong, subtle) |
| Gradients | `VGradients` | 2 gradient types (brand, surface) |
| Animations | `VAnimations` | 8 durations (instant to extraSlow) + 5 curves |

### Borders and padding

Widgets that draw their border in the decoration, such as `VBox`, `VCard`, `VChip`, `VBadge` and the `VMenu` panel, add the border width to the padding, as a Flutter `Container` does. A 1px border with `EdgeInsets.all(16)` puts the content 17px from the outer edge, and a wider border set in a style grows the widget by the extra width on each side. To keep the outer size and the content position, take the border width off the padding.

## Platform Support

| Platform | Minimum Version |
|----------|:--------------:|
| iOS | 12+ |
| Android | API 21+ |
| macOS | 10.14+ |
| Windows | 10+ |
| Linux | Ubuntu 18.04+ |

> **Note:** Flutter web is not a supported target.

## Icon System

volo_flutter_ui provides a zero-dependency vector icon system via `VIcons`. All icons are rendered with `CustomPainter` -- no icon fonts required.

```dart
VIcons.close(size: 16, color: context.vColors.foreground)
VIcons.chevronRight(size: 20, color: context.vColors.mutedForeground)
VIcons.check(size: 24, color: context.vColors.primary)
```

Without `color`, an icon takes the color of the nearest `IconTheme`, then the theme's foreground color. Widgets that set an `IconTheme` for their icons, such as `VButton` and `VBottomNav`, color a `VIcons` icon the same way, so `VBottomNavItem(icon: VIcons.camera(), ...)` follows the selected and unselected colors.

## Documentation

- [Component docs](doc/) -- One page per widget, generated from the dartdoc comments
- [GitHub](https://github.com/volo-uti/volo-flutter-ui) -- Source code and issues

## Development

Requirements: [FVM](https://fvm.app) (the Flutter version is in `.fvmrc`) and Dart SDK 3.11.0 or newer.

```bash
dart pub global activate fvm   # install FVM
make setup                     # install Flutter, fetch dependencies, install the git hook
make check                     # gate: format, tokens, index, docs, raw widgets, analyze, tests
make tokens                    # rewrite theme/*.generated.dart from the token JSON
make index                     # rewrite the AGENTS.md index blocks and doc/
cd widgetbook && fvm flutter run -d macos   # run the Widgetbook catalog
```

Tests run locally: `make check` is enforced by a `pre-push` hook that `make setup` installs when [lefthook](https://lefthook.dev/) is available. Remote workflows only publish and deploy; none of them runs `make check`. On Windows, use WSL2 and run everything, including `make setup`, inside it.

## Deployment

| Target | Trigger | Pipeline |
|--------|---------|----------|
| GitHub release (volo_flutter_ui) | `v*` tag push | `.github/workflows/release.yml` |
| GitHub Pages (Widgetbook) | `main` push | `.github/workflows/widgetbook-deploy.yml` |

Each workflow posts a start and a finish message (success, failure or cancelled) to Slack with a bot token (`chat.postMessage`). Set the `SLACK_BOT_TOKEN` secret and the `SLACK_CICD_CHANNEL` variable; if either is missing, the notification is skipped silently. The release uses the workflow's own `GITHUB_TOKEN` and needs no secret of yours.

## Contributing

Contributions are welcome. Read the [Contributing Guide](CONTRIBUTING.md) first; it covers setup, the `make check` gate and the pull request process. Everyone taking part follows the [Code of Conduct](CODE_OF_CONDUCT.md).

## Security

Please report vulnerabilities privately through the repository's Security tab, as described in the [Security Policy](SECURITY.md). Do not open a public issue.

## Principles

[PRINCIPLES.md](PRINCIPLES.md) explains why the repository is built this way and which tool enforces each rule.

## License

[MIT](LICENSE) &copy; [volo-uti](https://github.com/volo-uti)
