import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  const en = VoloLocalizationsEn();

  group('VoloLocalizationsEn', () {
    group('Common keys', () {
      test('noData returns English text', () {
        expect(en.noData, 'No data');
      });

      test('noResults returns English text', () {
        expect(en.noResults, 'No results found');
      });

      test('noOptions returns English text', () {
        expect(en.noOptions, 'No options');
      });

      test('loading returns English text', () {
        expect(en.loading, 'Loading...');
      });

      test('searchPlaceholder returns English text', () {
        expect(en.searchPlaceholder, 'Search...');
      });
    });

    group('VSelect keys', () {
      test('nSelected formats correctly', () {
        expect(en.nSelected(0), '0 selected');
        expect(en.nSelected(1), '1 selected');
        expect(en.nSelected(3), '3 selected');
      });

      test('selectNoResults returns English text', () {
        expect(en.selectNoResults, 'No results');
      });

      test('selectNoOptions returns English text', () {
        expect(en.selectNoOptions, 'No options');
      });
    });

    group('VAutocomplete keys', () {
      test('autocompleteNoResults with query', () {
        expect(en.autocompleteNoResults('hello'), "No results for 'hello'");
      });

      test('autocompleteNoResults with empty query', () {
        expect(en.autocompleteNoResults(''), 'No results found');
      });
    });

    group('VCalendar / VDatePicker keys', () {
      test('monthYear formats all 12 months', () {
        const expected = [
          'January 2026',
          'February 2026',
          'March 2026',
          'April 2026',
          'May 2026',
          'June 2026',
          'July 2026',
          'August 2026',
          'September 2026',
          'October 2026',
          'November 2026',
          'December 2026',
        ];
        for (var m = 1; m <= 12; m++) {
          expect(en.monthYear(2026, m), expected[m - 1]);
        }
      });

      test('fullDate formats correctly', () {
        expect(en.fullDate(2026, 3, 29), 'March 29, 2026');
        expect(en.fullDate(2025, 1, 1), 'January 1, 2025');
        expect(en.fullDate(2026, 12, 31), 'December 31, 2026');
      });

      test('anteMeridiemAbbreviation returns AM', () {
        expect(en.anteMeridiemAbbreviation, 'AM');
      });

      test('postMeridiemAbbreviation returns PM', () {
        expect(en.postMeridiemAbbreviation, 'PM');
      });
    });

    group('VDialog keys', () {
      test('dialogCancel returns Cancel', () {
        expect(en.dialogCancel, 'Cancel');
      });

      test('dialogConfirm returns Confirm', () {
        expect(en.dialogConfirm, 'Confirm');
      });
    });

    group('VStepper keys', () {
      test('stepperPrevious returns Previous', () {
        expect(en.stepperPrevious, 'Previous');
      });

      test('stepperNext returns Next', () {
        expect(en.stepperNext, 'Next');
      });

      test('stepperComplete returns Complete', () {
        expect(en.stepperComplete, 'Complete');
      });
    });

    group('VPagination keys', () {
      test('paginationPrevious returns Previous', () {
        expect(en.paginationPrevious, 'Previous');
      });

      test('paginationNext returns Next', () {
        expect(en.paginationNext, 'Next');
      });

      test('pageOf formats correctly', () {
        expect(en.pageOf(1, 10), 'Page 1 of 10');
        expect(en.pageOf(5, 20), 'Page 5 of 20');
      });

      test('paginationNavigationLabel returns text', () {
        expect(en.paginationNavigationLabel, 'Page navigation');
      });
    });

    group('VAvatarGroup keys', () {
      test('avatarGroupOverflow formats correctly', () {
        expect(en.avatarGroupOverflow(3), '+3 more');
      });

      test('avatarGroupLabel formats correctly', () {
        expect(en.avatarGroupLabel(5), '5 avatars');
      });
    });

    group('VChip keys', () {
      test('chipRemove formats correctly', () {
        expect(en.chipRemove('React'), 'Remove React');
      });
    });

    group('VBreadcrumb keys', () {
      test('breadcrumbLabel returns text', () {
        expect(en.breadcrumbLabel, 'Breadcrumb');
      });
    });

    group('VProgress keys', () {
      test('progressLoading returns text', () {
        expect(en.progressLoading, 'Loading...');
      });
    });

    group('VTable keys', () {
      test('tableNoData returns text', () {
        expect(en.tableNoData, 'No data');
      });
    });

    group('VCommand keys', () {
      test('commandNoResults returns text', () {
        expect(en.commandNoResults, 'No results');
      });

      test('commandPlaceholder returns text', () {
        expect(en.commandPlaceholder, 'Search...');
      });
    });
  });

  group('VoloLocalizations.of', () {
    testWidgets('retrieves from VTheme', (tester) async {
      late VoloLocalizations result;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                result = VoloLocalizations.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(result, isA<VoloLocalizationsEn>());
    });

    testWidgets('maybeOf returns null without VTheme', (tester) async {
      VoloLocalizations? result;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              result = VoloLocalizations.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result, isNull);
    });
  });
}
