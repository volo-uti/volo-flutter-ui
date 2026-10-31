# VPagination

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VPagination

Page navigation with numbered buttons, ellipsis and previous/next controls.

{@category Navigation}

## Overview

[VPagination] collapses long page ranges into ellipses and offers a
[VPagination.simple] and a [VPagination.minimal] form.

## Basic Usage

```dart
VPagination(
  currentPage: _currentPage,
  totalPages: 20,
  onPageChanged: (page) => setState(() => _currentPage = page),
)
```

## Variants

- [VPagination.new] - Full pagination with page numbers and first/last buttons
- [VPagination.simple] - Previous/Next buttons with page indicator text
- [VPagination.minimal] - Only Previous/Next buttons

## Simple pagination

```dart
VPagination.simple(
  currentPage: 5,
  totalPages: 20,
  onPageChanged: (page) => loadPage(page),
)
// Displays: < Previous   Page 5 of 20   Next >
```

## Minimal pagination

```dart
VPagination.minimal(
  currentPage: 1,
  totalPages: 10,
  onPageChanged: (page) => loadPage(page),
)
// Displays: < Previous   Next >
```

## Customized pagination

Control the number of visible page numbers:

```dart
VPagination(
  currentPage: 10,
  totalPages: 50,
  siblingCount: 2,    // Pages shown around current
  boundaryCount: 1,   // Pages shown at start/end
  showFirstLast: true,
  onPageChanged: (page) => loadPage(page),
)
// Displays: |< < 1 ... 8 9 10 11 12 ... 50 > >|
```

## Different sizes

```dart
VPagination(
  size: VPaginationSize.sm,  // sm, md, or lg
  currentPage: 1,
  totalPages: 10,
  onPageChanged: (page) {},
)
```

See also:

- [VTabs], for tab-based navigation
- [VBottomNav], for bottom navigation

### Constructors

#### `VPagination`

Full pagination with numbered buttons and first/last controls.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `currentPage` | `int` |  | yes | Selected page, counted from 1. |
| `totalPages` | `int` |  | yes | Number of pages, at least 1. |
| `onPageChanged` | `void Function(int)` |  | yes | Called with the page number the user picks. |
| `siblingCount` | `int` | `1` |  | Number of page buttons shown on each side of the current page. |
| `boundaryCount` | `int` | `1` |  | Number of page buttons always shown at the start and the end. |
| `showFirstLast` | `bool` | `true` |  | Whether the jump-to-first and jump-to-last buttons are shown. |
| `size` | `VPaginationSize` | `VPaginationSize.md` |  | Button and text size. |
| `enabled` | `bool` | `true` |  | Whether the buttons react to input; false dims and blocks all of them. |
| `style` | `VPaginationStyle?` |  |  | Overrides the theme's [VPaginationStyle] for this pagination. |

#### `VPagination.simple`

Previous and next buttons around a "page x of y" text.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `currentPage` | `int` |  | yes | Selected page, counted from 1. |
| `totalPages` | `int` |  | yes | Number of pages, at least 1. |
| `onPageChanged` | `void Function(int)` |  | yes | Called with the page number the user picks. |
| `size` | `VPaginationSize` | `VPaginationSize.md` |  | Button and text size. |
| `previousText` | `String?` |  |  | Label of the previous button; the localized text when null. |
| `nextText` | `String?` |  |  | Label of the next button; the localized text when null. |
| `pageTextBuilder` | `String Function(int, int)?` |  |  | Builds the "page x of y" text of [VPagination.simple].<br>Defaults to the localized "Page $current of $total". |
| `enabled` | `bool` | `true` |  | Whether the buttons react to input; false dims and blocks all of them. |
| `style` | `VPaginationStyle?` |  |  | Overrides the theme's [VPaginationStyle] for this pagination. |

#### `VPagination.minimal`

Only previous and next buttons.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `currentPage` | `int` |  | yes | Selected page, counted from 1. |
| `totalPages` | `int` |  | yes | Number of pages, at least 1. |
| `onPageChanged` | `void Function(int)` |  | yes | Called with the page number the user picks. |
| `size` | `VPaginationSize` | `VPaginationSize.md` |  | Button and text size. |
| `previousText` | `String?` |  |  | Label of the previous button; the localized text when null. |
| `nextText` | `String?` |  |  | Label of the next button; the localized text when null. |
| `enabled` | `bool` | `true` |  | Whether the buttons react to input; false dims and blocks all of them. |
| `style` | `VPaginationStyle?` |  |  | Overrides the theme's [VPaginationStyle] for this pagination. |

## VPaginationPageTextBuilder

Builds the "page x of y" text of [VPagination.simple].

```dart
typedef VPaginationPageTextBuilder = String Function(int, int);
```

## VPaginationSize

Button and text size of a [VPagination].

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VPaginationStyle

Style override for [VPagination].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VPaginationStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `activeBackgroundColor` | `Color?` |  |  | Active page background color. |
| `activeForegroundColor` | `Color?` |  |  | Active page foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VPaginationStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? activeBackgroundColor, Color? activeForegroundColor, Color? borderColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
