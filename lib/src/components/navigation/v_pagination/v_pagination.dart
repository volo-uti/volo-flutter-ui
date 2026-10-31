import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_pagination_style.dart';

/// Builds the "page x of y" text of [VPagination.simple].
typedef VPaginationPageTextBuilder = String Function(int current, int total);

/// Button and text size of a [VPagination].
enum VPaginationSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// Page navigation with numbered buttons, ellipsis and previous/next controls.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VPagination] collapses long page ranges into ellipses and offers a
/// [VPagination.simple] and a [VPagination.minimal] form.
///
/// ## Basic Usage
///
/// ```dart
/// VPagination(
///   currentPage: _currentPage,
///   totalPages: 20,
///   onPageChanged: (page) => setState(() => _currentPage = page),
/// )
/// ```
///
/// ## Variants
///
/// - [VPagination.new] - Full pagination with page numbers and first/last buttons
/// - [VPagination.simple] - Previous/Next buttons with page indicator text
/// - [VPagination.minimal] - Only Previous/Next buttons
///
/// ## Simple pagination
///
/// ```dart
/// VPagination.simple(
///   currentPage: 5,
///   totalPages: 20,
///   onPageChanged: (page) => loadPage(page),
/// )
/// // Displays: < Previous   Page 5 of 20   Next >
/// ```
///
/// ## Minimal pagination
///
/// ```dart
/// VPagination.minimal(
///   currentPage: 1,
///   totalPages: 10,
///   onPageChanged: (page) => loadPage(page),
/// )
/// // Displays: < Previous   Next >
/// ```
///
/// ## Customized pagination
///
/// Control the number of visible page numbers:
///
/// ```dart
/// VPagination(
///   currentPage: 10,
///   totalPages: 50,
///   siblingCount: 2,    // Pages shown around current
///   boundaryCount: 1,   // Pages shown at start/end
///   showFirstLast: true,
///   onPageChanged: (page) => loadPage(page),
/// )
/// // Displays: |< < 1 ... 8 9 10 11 12 ... 50 > >|
/// ```
///
/// ## Different sizes
///
/// ```dart
/// VPagination(
///   size: VPaginationSize.sm,  // sm, md, or lg
///   currentPage: 1,
///   totalPages: 10,
///   onPageChanged: (page) {},
/// )
/// ```
///
/// See also:
///
/// - [VTabs], for tab-based navigation
/// - [VBottomNav], for bottom navigation
class VPagination extends StatelessWidget {
  /// Full pagination with numbered buttons and first/last controls.
  const VPagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.siblingCount = 1,
    this.boundaryCount = 1,
    this.showFirstLast = true,
    this.size = VPaginationSize.md,
    this.enabled = true,
    this.style,
  }) : assert(totalPages >= 1, 'VPagination: totalPages must be at least 1'),
       assert(
         currentPage >= 1 && currentPage <= totalPages,
         'VPagination: currentPage must be between 1 and totalPages',
       ),
       _variant = _VPaginationVariant.defaultPagination,
       previousText = null,
       nextText = null,
       pageTextBuilder = null;

  /// Previous and next buttons around a "page x of y" text.
  const VPagination.simple({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.size = VPaginationSize.md,
    this.previousText,
    this.nextText,
    this.pageTextBuilder,
    this.enabled = true,
    this.style,
  }) : assert(totalPages >= 1, 'VPagination: totalPages must be at least 1'),
       assert(
         currentPage >= 1 && currentPage <= totalPages,
         'VPagination: currentPage must be between 1 and totalPages',
       ),
       _variant = _VPaginationVariant.simple,
       siblingCount = 0,
       boundaryCount = 0,
       showFirstLast = false;

  /// Only previous and next buttons.
  const VPagination.minimal({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.size = VPaginationSize.md,
    this.previousText,
    this.nextText,
    this.enabled = true,
    this.style,
  }) : assert(totalPages >= 1, 'VPagination: totalPages must be at least 1'),
       assert(
         currentPage >= 1 && currentPage <= totalPages,
         'VPagination: currentPage must be between 1 and totalPages',
       ),
       _variant = _VPaginationVariant.minimal,
       siblingCount = 0,
       boundaryCount = 0,
       showFirstLast = false,
       pageTextBuilder = null;

  final _VPaginationVariant _variant;

  /// Selected page, counted from 1.
  final int currentPage;

  /// Number of pages, at least 1.
  final int totalPages;

  /// Called with the page number the user picks.
  final ValueChanged<int> onPageChanged;

  /// Number of page buttons shown on each side of the current page.
  final int siblingCount;

  /// Number of page buttons always shown at the start and the end.
  final int boundaryCount;

  /// Whether the jump-to-first and jump-to-last buttons are shown.
  final bool showFirstLast;

  /// Button and text size.
  final VPaginationSize size;

  /// Whether the buttons react to input; false dims and blocks all of them.
  final bool enabled;

  /// Label of the previous button; the localized text when null.
  final String? previousText;

  /// Label of the next button; the localized text when null.
  final String? nextText;

  /// Builds the "page x of y" text of [VPagination.simple].
  ///
  /// Defaults to the localized "Page $current of $total".
  final VPaginationPageTextBuilder? pageTextBuilder;

  /// Overrides the theme's [VPaginationStyle] for this pagination.
  final VPaginationStyle? style;

  int get _effectiveCurrentPage => currentPage.clamp(1, _effectiveTotalPages);
  int get _effectiveTotalPages => totalPages <= 0 ? 1 : totalPages;

  double _buttonSizeOf(BuildContext context) {
    final theme = VTheme.of(context);
    return switch (size) {
      VPaginationSize.sm => theme.sizes.xs.height,
      VPaginationSize.md => theme.sizes.sm.height,
      VPaginationSize.lg => theme.sizes.md.height,
    };
  }

  double _fontSizeOf(BuildContext context) {
    final theme = VTheme.of(context);
    return switch (size) {
      VPaginationSize.sm => theme.sizes.xs.fontSize,
      VPaginationSize.md => theme.sizes.sm.fontSize,
      VPaginationSize.lg => theme.sizes.md.fontSize,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    Widget result;
    switch (_variant) {
      case _VPaginationVariant.simple:
        result = _buildSimple(context, colors, typography);
      case _VPaginationVariant.minimal:
        result = _buildMinimal(context, colors, typography);
      case _VPaginationVariant.defaultPagination:
        result = _buildDefault(context, colors, typography);
    }

    if (!enabled) {
      result = IgnorePointer(child: Opacity(opacity: 0.5, child: result));
    }

    return FocusTraversalGroup(child: result);
  }

  Widget _buildDefault(
    BuildContext context,
    VColors colors,
    VTypography typography,
  ) {
    final pages = _calculatePages();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showFirstLast)
          _buildButton(
            context,
            colors,
            typography,
            semanticLabel: VoloLocalizations.of(context).paginationFirst,
            iconBuilder: (color, iconSize) =>
                VIcons.firstPage(color: color, size: iconSize),
            onTap: _effectiveCurrentPage > 1 ? () => onPageChanged(1) : null,
          ),
        _buildButton(
          context,
          colors,
          typography,
          semanticLabel: VoloLocalizations.of(context).paginationPrevious,
          iconBuilder: (color, iconSize) =>
              VIcons.chevronLeft(color: color, size: iconSize),
          onTap: _effectiveCurrentPage > 1
              ? () => onPageChanged(_effectiveCurrentPage - 1)
              : null,
        ),
        ...pages.map((page) {
          if (page == -1) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: VTheme.of(context).spacing.xs,
              ),
              child: Text(
                '...',
                style: typography.bodyMedium.copyWith(
                  fontSize: _fontSizeOf(context),
                  color: colors.mutedForeground,
                ),
              ),
            );
          }
          return _buildButton(
            context,
            colors,
            typography,
            label: '$page',
            isSelected: page == _effectiveCurrentPage,
            onTap: () => onPageChanged(page),
          );
        }),
        _buildButton(
          context,
          colors,
          typography,
          semanticLabel: VoloLocalizations.of(context).paginationNext,
          iconBuilder: (color, iconSize) =>
              VIcons.chevronRight(color: color, size: iconSize),
          onTap: _effectiveCurrentPage < _effectiveTotalPages
              ? () => onPageChanged(_effectiveCurrentPage + 1)
              : null,
        ),
        if (showFirstLast)
          _buildButton(
            context,
            colors,
            typography,
            semanticLabel: VoloLocalizations.of(context).paginationLast,
            iconBuilder: (color, iconSize) =>
                VIcons.lastPage(color: color, size: iconSize),
            onTap: _effectiveCurrentPage < _effectiveTotalPages
                ? () => onPageChanged(_effectiveTotalPages)
                : null,
          ),
      ],
    );
  }

  Widget _buildSimple(
    BuildContext context,
    VColors colors,
    VTypography typography,
  ) {
    final l10n = VoloLocalizations.of(context);
    final effectivePrevious = previousText ?? l10n.paginationPrevious;
    final effectiveNext = nextText ?? l10n.paginationNext;
    final pageText =
        pageTextBuilder?.call(_effectiveCurrentPage, _effectiveTotalPages) ??
        l10n.pageOf(_effectiveCurrentPage, _effectiveTotalPages);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextButton(
          context,
          colors,
          typography,
          '< $effectivePrevious',
          semanticLabel: effectivePrevious,
          onTap: _effectiveCurrentPage > 1
              ? () => onPageChanged(_effectiveCurrentPage - 1)
              : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: VTheme.of(context).spacing.lg,
          ),
          child: Text(
            pageText,
            style: typography.bodyMedium.copyWith(
              fontSize: _fontSizeOf(context),
              color: colors.foreground,
            ),
          ),
        ),
        _buildTextButton(
          context,
          colors,
          typography,
          '$effectiveNext >',
          semanticLabel: effectiveNext,
          onTap: _effectiveCurrentPage < _effectiveTotalPages
              ? () => onPageChanged(_effectiveCurrentPage + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildMinimal(
    BuildContext context,
    VColors colors,
    VTypography typography,
  ) {
    final l10n = VoloLocalizations.of(context);
    final effectivePrevious = previousText ?? l10n.paginationPrevious;
    final effectiveNext = nextText ?? l10n.paginationNext;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextButton(
          context,
          colors,
          typography,
          '< $effectivePrevious',
          semanticLabel: effectivePrevious,
          onTap: _effectiveCurrentPage > 1
              ? () => onPageChanged(_effectiveCurrentPage - 1)
              : null,
        ),
        SizedBox(width: VTheme.of(context).spacing.lg),
        _buildTextButton(
          context,
          colors,
          typography,
          '$effectiveNext >',
          semanticLabel: effectiveNext,
          onTap: _effectiveCurrentPage < _effectiveTotalPages
              ? () => onPageChanged(_effectiveCurrentPage + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    VColors colors,
    VTypography typography, {
    String? label,
    String? semanticLabel,
    Widget Function(Color color, double iconSize)? iconBuilder,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    final theme = VTheme.of(context);

    // Resolve style for button-level overrides
    final btnThemeStyle = theme.componentOverrides.get<VPaginationStyle>();
    final btnResolvedStyle = btnThemeStyle?.merge(style) ?? style;
    final activeBg = btnResolvedStyle?.activeBackgroundColor ?? colors.primary;
    final activeFg =
        btnResolvedStyle?.activeForegroundColor ?? colors.primaryForeground;
    final normalFg = btnResolvedStyle?.foregroundColor ?? colors.foreground;
    final effectiveBorderRadius =
        btnResolvedStyle?.borderRadius ?? theme.radius.smRadius;

    // WCAG 2.5.8: Minimum touch target 24x24
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xxs),
      child: Focus(
        onKeyEvent: (node, event) => _activateOnKey(event, onTap),
        child: Builder(
          builder: (context) {
            final isFocused = Focus.of(context).hasFocus;
            // WHY: The label carries the visible text, so the child is
            // excluded; otherwise a screen reader reads "3" twice.
            return Semantics(
              button: true,
              enabled: !isDisabled,
              selected: isSelected,
              label: label ?? semanticLabel,
              onTap: onTap,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  child: Container(
                    width: _buttonSizeOf(context),
                    height: _buttonSizeOf(context),
                    decoration: BoxDecoration(
                      color: isSelected ? activeBg : null,
                      borderRadius: effectiveBorderRadius,
                      // Focus ring (WCAG 2.4.7)
                      border: isFocused && !isDisabled
                          ? Border.all(color: colors.ring, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: iconBuilder != null
                          ? iconBuilder(
                              isDisabled
                                  ? colors.mutedForeground.withValues(
                                      alpha: 0.5,
                                    )
                                  : normalFg,
                              switch (size) {
                                VPaginationSize.sm => theme.sizes.xs.iconSize,
                                VPaginationSize.md => theme.sizes.sm.iconSize,
                                VPaginationSize.lg => theme.sizes.md.iconSize,
                              },
                            )
                          : Text(
                              label ?? '',
                              style: typography.labelMedium.copyWith(
                                fontSize: _fontSizeOf(context),
                                color: isSelected ? activeFg : normalFg,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    VColors colors,
    VTypography typography,
    String label, {
    String? semanticLabel,
    VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    final theme = VTheme.of(context);

    return Focus(
      onKeyEvent: (node, event) => _activateOnKey(event, onTap),
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return Semantics(
            button: true,
            enabled: !isDisabled,
            label: semanticLabel ?? label,
            onTap: onTap,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.xs,
                  vertical: theme.spacing.xxs,
                ),
                decoration: isFocused && !isDisabled
                    ? BoxDecoration(
                        borderRadius: theme.radius.smRadius,
                        border: Border.all(color: colors.ring, width: 2),
                      )
                    : null,
                child: Text(
                  label,
                  style: typography.labelMedium.copyWith(
                    fontSize: _fontSizeOf(context),
                    color: isDisabled
                        ? colors.mutedForeground.withValues(alpha: 0.5)
                        : colors.primary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Enter and Space activate a focused button, like a tap.
  KeyEventResult _activateOnKey(KeyEvent event, VoidCallback? onTap) {
    if (onTap != null &&
        event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      onTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // WHY: Ellipsis algorithm (siblingCount + boundaryCount) — renders
  // "1 ... 4 5 [6] 7 8 ... 20" instead of all 20 buttons. The -1
  // sentinel value represents an ellipsis position in the returned list.
  List<int> _calculatePages() {
    final total = _effectiveTotalPages;
    final current = _effectiveCurrentPage;

    if (total <= (siblingCount * 2) + (boundaryCount * 2) + 3) {
      return List.generate(total, (i) => i + 1);
    }

    final pages = <int>[];

    // Start boundary
    for (var i = 1; i <= boundaryCount; i++) {
      pages.add(i);
    }

    // Left ellipsis
    final leftSiblingStart = current - siblingCount;
    if (leftSiblingStart > boundaryCount + 2) {
      pages.add(-1);
    } else if (leftSiblingStart > boundaryCount + 1) {
      pages.add(boundaryCount + 1);
    }

    // Siblings
    for (var i = leftSiblingStart; i <= current + siblingCount; i++) {
      if (i > boundaryCount && i < total - boundaryCount + 1) {
        pages.add(i);
      }
    }

    // Right ellipsis
    final rightSiblingEnd = current + siblingCount;
    if (rightSiblingEnd < total - boundaryCount - 1) {
      pages.add(-1);
    } else if (rightSiblingEnd < total - boundaryCount) {
      pages.add(total - boundaryCount);
    }

    // End boundary
    for (var i = total - boundaryCount + 1; i <= total; i++) {
      pages.add(i);
    }

    // WHY: The list is built in display order; sorting would push every -1
    // ellipsis sentinel to the end. Only drop repeated page numbers.
    final seen = <int>{};
    return [
      for (final page in pages)
        if (page == -1 || seen.add(page)) page,
    ];
  }
}

enum _VPaginationVariant { defaultPagination, simple, minimal }
