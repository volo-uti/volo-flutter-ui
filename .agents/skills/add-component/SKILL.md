---
name: add-component
description: Use when adding a new widget (a component starting with V) to volo_flutter_ui. Follows the order of file layout, category barrel export, tests, Widgetbook use cases and index update.
---

# Add a widget

Paths are relative to the repository root (the Widgetbook app is `widgetbook/`).

1. Look in the `AGENTS.md` index first for an existing widget that fits. If there is none, say what you searched for, then build.
2. Write `lib/src/components/<category>/v_x/v_x.dart` and `v_x_style.dart`. Give every public declaration a `///` first sentence of at most 90 characters (the index and docs are built from it). Read colors from the tokens (`VTheme`) and never import `material.dart` or `cupertino.dart`.
3. Export `v_x.dart` and `v_x_style.dart` from the category barrel `lib/src/components/<category>/<category>.dart`.
4. Write the test `test/components/<category>/v_x_test.dart`. Wrap it in `VTheme(data: VThemeData.light(), child: Directionality(...))`. Model it on an existing test in the same category.
5. In `widgetbook/lib/use_cases/NN_<category>/v_x.dart`, create `vXComponent()` with three use cases: Playground, Showcase and Sample. Model it on an existing file in the same category.
6. In `widgetbook/lib/main.dart`, add the import and register `vXComponent()` in that category's component list.
7. If the widget replaces a raw Material widget, add a line to `rawWidgets` in `lib/src/tooling/raw_widgets.dart`.
8. From the repository root, run `make index` to rewrite the index and docs, and finish with `make check`.

Never edit `*.generated.dart` or `doc/` by hand.
