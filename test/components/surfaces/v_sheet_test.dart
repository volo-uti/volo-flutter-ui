import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VBottomSheet', () {
    testWidgets('creates bottom sheet', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBottomSheet(child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(VBottomSheet), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(size: Size(400, 800)),
              child: VBottomSheet(
                title: Text('Sheet Title'),
                child: Text('Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sheet Title'), findsOneWidget);
    });

    testWidgets('controls handle visibility', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBottomSheet(showHandle: false, child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(VBottomSheet), findsOneWidget);
    });
  });

  group('VSideSheet', () {
    testWidgets('creates side sheet', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSideSheet(child: Text('Side Content')),
          ),
        ),
      );

      expect(find.byType(VSideSheet), findsOneWidget);
      expect(find.text('Side Content'), findsOneWidget);
    });

    testWidgets('left side', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSideSheet(child: Text('Left')),
          ),
        ),
      );

      expect(find.byType(VSideSheet), findsOneWidget);
    });

    testWidgets('right side', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSideSheet(side: VSheetSide.right, child: Text('Right')),
          ),
        ),
      );

      expect(find.byType(VSideSheet), findsOneWidget);
    });

    testWidgets('custom width', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VSideSheet(width: 320, child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(VSideSheet), findsOneWidget);
    });
  });

  group('VSheet factory constructors', () {
    testWidgets('VSheet.bottom() creates VBottomSheet', (tester) async {
      final sheet = VSheet.bottom(
        title: const Text('Bottom Sheet'),
        child: const Text('Content'),
      );

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: sheet),
        ),
      );

      expect(find.byType(VBottomSheet), findsOneWidget);
      expect(sheet, isA<VBottomSheet>());
      expect(sheet, isA<VSheet>());
    });

    testWidgets('VSheet.side() creates VSideSheet', (tester) async {
      final sheet = VSheet.side(
        side: VSheetSide.right,
        child: const Text('Side Content'),
      );

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: sheet),
        ),
      );

      expect(find.byType(VSideSheet), findsOneWidget);
      expect(sheet, isA<VSideSheet>());
      expect(sheet, isA<VSheet>());
    });
  });

  group('VBottomSheet Interactions', () {
    testWidgets('shows sheet with VBottomSheet.show<void>()', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VBottomSheet.show<void>(
                          context,
                          title: const Text('Sheet Title'),
                          child: const Text('Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state: sheet is not visible
      expect(find.text('Sheet Content'), findsNothing);

      // Tap button -> sheet opens
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsOneWidget);
      expect(find.text('Sheet Title'), findsOneWidget);
    });

    testWidgets('closes sheet with VBottomSheet.close<void>()', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VBottomSheet.show<void>(
                          context,
                          child: Builder(
                            builder: (sheetContext) => GestureDetector(
                              onTap: () {
                                VBottomSheet.close<void>(sheetContext);
                              },
                              child: const Text('Close Button'),
                            ),
                          ),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Close Button'), findsOneWidget);

      // Tap close button -> sheet closes
      await tester.tap(find.text('Close Button'));
      await tester.pumpAndSettle();
      expect(find.text('Close Button'), findsNothing);
    });

    testWidgets('closes by tapping outside when barrierDismissible=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VBottomSheet.show<void>(
                          context,
                          child: const Text('Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsOneWidget);

      // Tap outside (barrier) -> sheet closes
      await tester.tapAt(const Offset(200, 50));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsNothing);
    });
  });

  group('VSideSheet Interactions', () {
    testWidgets('shows sheet with VSideSheet.show<void>()', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VSideSheet.show<void>(
                          context,
                          child: const Text('Side Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Side Sheet Content'), findsNothing);

      // Tap button -> sheet opens
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Side Sheet Content'), findsOneWidget);
    });

    testWidgets('closes sheet with VSideSheet.close<void>()', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VSideSheet.show<void>(
                          context,
                          child: Builder(
                            builder: (sheetContext) => GestureDetector(
                              onTap: () {
                                VSideSheet.close<void>(sheetContext);
                              },
                              child: const Text('Close Button'),
                            ),
                          ),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Close Button'), findsOneWidget);

      // Tap close button -> sheet closes
      await tester.tap(find.text('Close Button'));
      await tester.pumpAndSettle();
      expect(find.text('Close Button'), findsNothing);
    });

    testWidgets('closes by tapping outside when barrierDismissible=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VSideSheet.show<void>(
                          context,
                          width: 200,
                          child: const Text('Side Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Side Sheet Content'), findsOneWidget);

      // Tap outside (barrier) -> sheet closes (tap right area)
      await tester.tapAt(const Offset(350, 400));
      await tester.pumpAndSettle();
      expect(find.text('Side Sheet Content'), findsNothing);
    });
  });

  group('VBottomSheet Drag Interactions', () {
    testWidgets('resizes sheet by dragging', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VBottomSheet.show<void>(
                          context,
                          child: const Text('Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsOneWidget);

      // Find handle and drag up
      final sheetFinder = find.text('Sheet Content');
      expect(sheetFinder, findsOneWidget);

      // Drag up in sheet area (increase size)
      await tester.drag(sheetFinder, const Offset(0, -100));
      await tester.pumpAndSettle();

      // Sheet is still visible
      expect(find.text('Sheet Content'), findsOneWidget);
    });

    testWidgets('sheet closes when dragged below minimum size', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        await VBottomSheet.show<void>(
                          context,
                          initialSize: 0.3,
                          child: const Text('Sheet Content'),
                        );
                      },
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsOneWidget);

      // Drag down far in sheet area (below minimum size)
      final sheetFinder = find.text('Sheet Content');
      await tester.drag(sheetFinder, const Offset(0, 500));
      await tester.pumpAndSettle();

      // Sheet closes
      expect(find.text('Sheet Content'), findsNothing);
    });
  });

  group('show helpers pass style to the sheet', () {
    const red = Color(0xFFFF0000);
    const radius = BorderRadius.all(Radius.circular(3));

    Future<void> open(
      WidgetTester tester,
      Future<void> Function(BuildContext context) show,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder(
                  pageBuilder: (context, _, _) => Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => show(context),
                      child: const Text('Open Button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open Button'));
      await tester.pumpAndSettle();
    }

    BoxDecoration? bottomDecoration(WidgetTester tester) => tester
        .widgetList<Container>(
          find.ancestor(
            of: find.text('Sheet Content'),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .where((d) => d.color == red)
        .firstOrNull;

    Container? sideContainer(WidgetTester tester) => tester
        .widgetList<Container>(
          find.ancestor(
            of: find.text('Sheet Content'),
            matching: find.byType(Container),
          ),
        )
        .where((c) => c.color == red)
        .firstOrNull;

    testWidgets('VBottomSheet.show applies style', (tester) async {
      await open(
        tester,
        (context) => VBottomSheet.show<void>(
          context,
          style: const VSheetStyle(backgroundColor: red, borderRadius: radius),
          child: const Text('Sheet Content'),
        ),
      );

      expect(bottomDecoration(tester)?.borderRadius, radius);
    });

    testWidgets('VSideSheet.show applies style', (tester) async {
      await open(
        tester,
        (context) => VSideSheet.show<void>(
          context,
          style: const VSheetStyle(backgroundColor: red),
          child: const Text('Sheet Content'),
        ),
      );

      expect(sideContainer(tester), isNotNull);
    });

    testWidgets('VSheet.bottom applies style', (tester) async {
      await open(
        tester,
        (context) => VSheet.showBottom<void>(
          context,
          VSheet.bottom(
                style: const VSheetStyle(
                  backgroundColor: red,
                  borderRadius: radius,
                ),
                child: const Text('Sheet Content'),
              )
              as VBottomSheet,
        ),
      );

      expect(bottomDecoration(tester)?.borderRadius, radius);
    });

    testWidgets('VSheet.side applies style', (tester) async {
      await open(
        tester,
        (context) => VSheet.showSide<void>(
          context,
          VSheet.side(
                style: const VSheetStyle(backgroundColor: red),
                child: const Text('Sheet Content'),
              )
              as VSideSheet,
        ),
      );

      expect(sideContainer(tester), isNotNull);
    });
  });
}
