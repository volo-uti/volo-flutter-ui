import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _PaginationVariant { full, simple, minimal }

WidgetbookComponent vPaginationComponent() => WidgetbookComponent(
  name: 'VPagination',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _paginationPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _PaginationShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _PaginationSample(),
    ),
  ],
);

Widget _paginationPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_PaginationVariant>(
    label: 'variant',
    options: _PaginationVariant.values,
    initialOption: _PaginationVariant.full,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VPaginationSize>(
    label: 'size',
    options: VPaginationSize.values,
    initialOption: VPaginationSize.md,
    labelBuilder: (v) => v.name,
  );
  final totalPages = k.int.slider(
    label: 'totalPages',
    initialValue: 10,
    min: 1,
    max: 100,
  );
  final siblingCount = k.int.slider(label: 'siblingCount', initialValue: 1);
  final boundaryCount = k.int.slider(label: 'boundaryCount', initialValue: 1);
  final showFirstLast = k.boolean(label: 'showFirstLast', initialValue: true);
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final previousText = k.stringOrNull(label: 'previousText');
  final nextText = k.stringOrNull(label: 'nextText');

  return WidgetbookPlayground(
    child: Center(
      child: _InteractivePagination(
        // Rebuild with a fresh page when the page count changes.
        key: ValueKey(totalPages),
        variant: variant.name,
        totalPages: totalPages,
        size: size,
        siblingCount: siblingCount,
        boundaryCount: boundaryCount,
        showFirstLast: showFirstLast,
        enabled: enabled,
        previousText: previousText,
        nextText: nextText,
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _PaginationShowcase extends StatelessWidget {
  const _PaginationShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VPagination',
    description:
        'Page navigation component with ellipsis support for large datasets.',
    children: [
      const WidgetbookSection(
        title: 'Page Count',
        children: [
          WidgetbookSubsection(
            title: 'few pages',
            labels: ['count={5}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 5,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'many pages',
            labels: ['count={20}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 5,
                ),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Sibling Count',
        children: [
          WidgetbookSubsection(
            title: 'siblingCount=0',
            labels: ['siblingCount={0}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 10,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'siblingCount=1 (default)',
            labels: ['siblingCount={1}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 10,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'siblingCount=2',
            labels: ['siblingCount={2}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 10,
                  siblingCount: 2,
                ),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Boundary Count',
        children: [
          WidgetbookSubsection(
            title: 'boundaryCount=1 (default)',
            labels: ['boundaryCount={1}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 10,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'boundaryCount=2',
            labels: ['boundaryCount={2}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  totalPages: 20,
                  initialPage: 10,
                  boundaryCount: 2,
                ),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'first page',
            labels: ['defaultPage={1}'],
            children: [
              Center(child: _InteractivePagination(variant: 'default')),
            ],
          ),
          WidgetbookSubsection(
            title: 'last page',
            labels: ['defaultPage={10}'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  initialPage: 10,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [
              Center(
                child: _InteractivePagination(
                  variant: 'default',
                  initialPage: 5,
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
      ),

      // Usage Guidelines
      _buildUsageGuidelines(context),
    ],
  );

  Widget _buildUsageGuidelines(BuildContext context) {
    final theme = VTheme.of(context);
    return WidgetbookSection(
      title: 'Usage Guidelines',
      children: [
        Table(
          columnWidths: const {0: FixedColumnWidth(120), 1: FlexColumnWidth()},
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: theme.colors.muted,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              children: [
                _tableHeader(theme, 'Category'),
                _tableHeader(theme, 'Guideline'),
              ],
            ),
            _guidelineRow(
              theme,
              'When to use',
              'Navigate through paginated data lists or search results',
            ),
            _guidelineRow(
              theme,
              'Sibling count',
              'Controls how many pages are shown around the current page',
            ),
            _guidelineRow(
              theme,
              'Boundary count',
              'Controls how many pages are shown at the start and end',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Use during loading or when pagination is temporarily unavailable',
            ),
            _guidelineRow(
              theme,
              'Controlled',
              'Use page + onChange for server-side pagination',
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(VThemeData theme, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Text(
      text,
      style: theme.typography.labelMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colors.foreground,
      ),
    ),
  );

  TableRow _guidelineRow(VThemeData theme, String category, String guideline) =>
      TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colors.border)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category,
              style: theme.typography.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              guideline,
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        ],
      );
}

// =============================================================================
// Sample
// =============================================================================

class _PaginationSample extends StatelessWidget {
  const _PaginationSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VPagination Samples',
    description: 'Copy-paste code examples for common pagination patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic pagination',
        code: '''VPagination(
  currentPage: _currentPage,
  totalPages: 10,
  onPageChanged: (page) => setState(() => _currentPage = page),
)''',
        preview: Center(child: _InteractivePagination(variant: 'default')),
      ),
      WidgetbookCodeBlock(
        title: 'Controlled pagination',
        code: '''VPagination(
  currentPage: page,
  totalPages: 20,
  onPageChanged: (p) => setState(() => page = p),
)''',
        preview: Center(
          child: _InteractivePagination(
            variant: 'default',
            totalPages: 20,
            initialPage: 5,
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom sibling count',
        code: '''VPagination(
  currentPage: _currentPage,
  totalPages: 20,
  siblingCount: 2,
  onPageChanged: (page) => setState(() => _currentPage = page),
)''',
        preview: Center(
          child: _InteractivePagination(
            variant: 'default',
            totalPages: 20,
            initialPage: 10,
            siblingCount: 2,
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom boundary count',
        code: '''VPagination(
  currentPage: _currentPage,
  totalPages: 20,
  boundaryCount: 2,
  onPageChanged: (page) => setState(() => _currentPage = page),
)''',
        preview: Center(
          child: _InteractivePagination(
            variant: 'default',
            totalPages: 20,
            initialPage: 10,
            boundaryCount: 2,
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Disabled pagination',
        code: '''VPagination(
  currentPage: 5,
  totalPages: 10,
  enabled: false,
  onPageChanged: (page) {},
)''',
        preview: Center(
          child: _InteractivePagination(
            variant: 'default',
            initialPage: 5,
            enabled: false,
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Small size pagination',
        code: '''VPagination(
  currentPage: _currentPage,
  totalPages: 10,
  size: VPaginationSize.sm,
  onPageChanged: (page) => setState(() => _currentPage = page),
)''',
        preview: Center(
          child: _InteractivePagination(
            variant: 'default',
            size: VPaginationSize.sm,
          ),
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InteractivePagination extends StatefulWidget {
  const _InteractivePagination({
    required this.variant,
    this.totalPages = 10,
    this.initialPage = 1,
    this.size = VPaginationSize.md,
    this.siblingCount = 1,
    this.boundaryCount = 1,
    this.showFirstLast = true,
    this.enabled = true,
    this.previousText,
    this.nextText,
    super.key,
  });

  final String variant;
  final int totalPages;
  final int initialPage;
  final VPaginationSize size;
  final int siblingCount;
  final int boundaryCount;
  final bool showFirstLast;
  final bool enabled;
  final String? previousText;
  final String? nextText;

  @override
  State<_InteractivePagination> createState() => _InteractivePaginationState();
}

class _InteractivePaginationState extends State<_InteractivePagination> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case 'simple':
        return VPagination.simple(
          currentPage: _currentPage,
          totalPages: widget.totalPages,
          onPageChanged: (page) => setState(() => _currentPage = page),
          size: widget.size,
          enabled: widget.enabled,
          previousText: widget.previousText,
          nextText: widget.nextText,
        );
      case 'minimal':
        return VPagination.minimal(
          currentPage: _currentPage,
          totalPages: widget.totalPages,
          onPageChanged: (page) => setState(() => _currentPage = page),
          size: widget.size,
          enabled: widget.enabled,
          previousText: widget.previousText,
          nextText: widget.nextText,
        );
      default:
        return VPagination(
          currentPage: _currentPage,
          totalPages: widget.totalPages,
          onPageChanged: (page) => setState(() => _currentPage = page),
          size: widget.size,
          siblingCount: widget.siblingCount,
          boundaryCount: widget.boundaryCount,
          showFirstLast: widget.showFirstLast,
          enabled: widget.enabled,
        );
    }
  }
}
