# Uses FVM when it is installed; override with `make FLUTTER=flutter DART=dart`.
FVM     := $(shell command -v fvm 2>/dev/null)
FLUTTER ?= $(if $(FVM),fvm flutter,flutter)
DART    ?= $(if $(FVM),fvm dart,dart)
# Packages checked by analyze. The example sits outside the pub workspace.
PACKAGES := . example widgetbook
FORMAT_DIRS := lib test bin tool example widgetbook

.PHONY: setup test fmt analyze tokens index check

setup:
	$(if $(FVM),fvm install,)
	$(FLUTTER) pub get
	cd example && $(FLUTTER) pub get
	@if command -v lefthook >/dev/null 2>&1; then lefthook install; else echo "lefthook not found, skipping git hooks"; fi

# Runs `flutter test` in every package that has a test/ folder.
test:
	@set -e; for d in $(patsubst %/test,%,$(wildcard ./test ./widgetbook/test)); do \
		echo "== flutter test ($$d)"; (cd $$d && $(FLUTTER) test); \
	done

fmt:
	$(DART) format $(FORMAT_DIRS)

analyze:
	@set -e; for d in $(PACKAGES); do \
		echo "== flutter analyze ($$d)"; (cd $$d && $(FLUTTER) analyze --no-pub); \
	done
	@echo "== dart analyze (tool)"; $(DART) analyze --fatal-infos tool

# Regenerates lib/src/theme/v_*.generated.dart from the DTCG token JSON.
tokens:
	$(DART) run tool/gen_tokens.dart

# Regenerates the AGENTS.md index block, doc/index.txt and the per-widget docs
# in doc/ from the `///` comments.
index:
	$(DART) run tool/agent_index.dart
	$(DART) run tool/component_docs.dart

# Fails when a generated file is stale, a style field is never read, or
# Material widgets slipped into the widgetbook or into volo_flutter_ui.
check:
	$(DART) format --output=none --set-exit-if-changed $(FORMAT_DIRS)
	$(DART) run tool/gen_tokens.dart --check
	$(DART) run tool/agent_index.dart --check
	$(DART) run tool/component_docs.dart --check
	$(DART) run tool/style_fields.dart --check
	$(DART) run bin/raw_widgets.dart widgetbook/lib
	@if grep -rnE "package:flutter/(material|cupertino)\.dart" lib; then \
		echo "volo_flutter_ui must not import Material or Cupertino"; exit 1; \
	fi
	$(MAKE) analyze
	$(MAKE) test
