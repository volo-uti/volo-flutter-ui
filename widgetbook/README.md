# volo_flutter_ui Widgetbook

Interactive component catalog for [volo_flutter_ui](..).

**Deployment**: published to GitHub Pages on every `main` push (`.github/workflows/widgetbook-deploy.yml`).

## Run locally

```bash
# macOS
fvm flutter run -d macos

# Chrome
fvm flutter run -d chrome
```

## Structure

```
widgetbook/
├── lib/
│   ├── main.dart
│   ├── src/
│   │   ├── components/       # Component use case registration
│   │   └── foundation/       # Design token use cases (9 types)
│   └── use_cases/             # Use cases by category
│       ├── 01_inputs/
│       ├── 02_data_display/
│       ├── 03_feedback/
│       ├── 04_surfaces/
│       ├── 05_navigation/
│       └── 06_layout/
```

## Add a use case

1. Create `lib/use_cases/{category}/v_{component}.dart`
2. Register its component in `lib/main.dart`
