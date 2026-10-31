# Contributing

Thank you for your interest in contributing! This repository is the `volo_flutter_ui` package, with a Widgetbook catalog beside it.

By taking part you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md). The reasons behind the design are in [PRINCIPLES.md](PRINCIPLES.md). [AGENTS.md](AGENTS.md) holds the full rules that humans and coding agents follow here.

## Development setup

Tool versions come from the manifests, not from this document: the Flutter version is in `.fvmrc` and the Dart SDK range is in each `pubspec.yaml`.

1. Install [FVM](https://fvm.app/) (`dart pub global activate fvm`).
2. Run `make setup`. It installs the Flutter version from `.fvmrc` and fetches dependencies for the package, the catalog and the example app.
3. Run `make check` to confirm that your setup works.

`make check` is the one gate. It checks formatting, generated tokens, the generated index and docs, raw Material widgets, static analysis and tests. There is no test CI: run it before you push. If [lefthook](https://lefthook.dev/) is installed, `make setup` installs a `pre-push` hook that runs it for you. On Windows, work inside WSL2.

Other commands:

```bash
make fmt      # format Dart files
make test     # run the tests of every package
make tokens   # rewrite theme/*.generated.dart from the token JSON
make index    # rewrite the AGENTS.md index block and doc/
```

To browse the components, run the catalog: `cd widgetbook && fvm flutter run -d macos`.

## Project structure

```
lib/              # UI components (distributed through GitHub as volo_flutter_ui)
test/             # Widget tests
doc/              # Generated index and per-widget docs (shipped with the package)
bin/              # Commands shipped to products
example/          # Minimal app that uses the package
widgetbook/       # Component catalog
tool/             # Generators for tokens, the index and the per-widget docs
```

## Coding conventions

The short version; see [AGENTS.md](AGENTS.md) for all of it.

- Components carry the `V` prefix (`VButton`, `VTextField`). One folder per widget: `v_button/v_button.dart` and `v_button/v_button_style.dart`.
- Names follow Material: `enabled`, `onChanged`, `onPressed` for buttons, `onTap` for tiles and chips, `value` for on/off state.
- Every public declaration has a `///` doc comment. Its first sentence is at most 90 characters, because the generated index is built from it.
- `volo_flutter_ui` imports only the Flutter widgets layer. It never imports `material.dart` or `cupertino.dart`.
- Take every visual value from the `VTheme` tokens: no hard-coded colors, spacing or radii.
- Single quotes, trailing commas, type annotations on public APIs.
- Generated files (`*.generated.dart`, `doc/`) are never edited by hand. Rewrite them with `make tokens` and `make index`.
- Wrap widget tests in `VTheme`.

## Adding a component

1. Implement it in `lib/src/components/<category>/v_x/` (`v_x.dart` and `v_x_style.dart`).
2. Add tests in `test/components/<category>/v_x_test.dart`.
3. Add a Widgetbook use case in `widgetbook/lib/use_cases/`.
4. Export it from the category barrel file.
5. If it replaces a raw Material widget, add a line to `rawWidgets` in `lib/src/tooling/raw_widgets.dart`.
6. Run `make index`, then `make check`.

## Pull requests

1. Fork the repository and create a branch from the default branch.
2. Make your change, with tests.
3. Run `make index` if you changed a public API or its doc comment, then make sure `make check` passes.
4. Commit with [Conventional Commits](https://www.conventionalcommits.org/) in English: `<type>(<scope>): <subject>`.
5. Open a pull request and fill in the template. Write in English.

## Reporting bugs and security problems

Open an [issue](https://github.com/volo-uti/volo-flutter-ui/issues/new/choose) for bugs and feature requests. Report security problems privately as described in [SECURITY.md](SECURITY.md); do not open a public issue for them.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
