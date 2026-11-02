import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'src/about/about_use_case.dart';
import 'src/font_loader.dart';
import 'src/foundation/animation_use_case.dart';
import 'src/foundation/border_use_case.dart';
import 'src/foundation/color_use_case.dart';
import 'src/foundation/gradient_use_case.dart';
import 'src/foundation/icon_use_case.dart';
import 'src/foundation/radius_use_case.dart';
import 'src/foundation/shadow_use_case.dart';
import 'src/foundation/size_use_case.dart';
import 'src/foundation/spacing_use_case.dart';
import 'src/foundation/typography_use_case.dart';
import 'use_cases/01_inputs/v_autocomplete.dart';
import 'use_cases/01_inputs/v_button.dart';
import 'use_cases/01_inputs/v_button_group.dart';
import 'use_cases/01_inputs/v_calendar.dart';
import 'use_cases/01_inputs/v_checkbox.dart';
import 'use_cases/01_inputs/v_date_picker.dart';
import 'use_cases/01_inputs/v_fab.dart';
import 'use_cases/01_inputs/v_form.dart';
import 'use_cases/01_inputs/v_form_body.dart';
import 'use_cases/01_inputs/v_form_field.dart';
import 'use_cases/01_inputs/v_form_footer.dart';
import 'use_cases/01_inputs/v_form_header.dart';
import 'use_cases/01_inputs/v_icon_button.dart';
import 'use_cases/01_inputs/v_label.dart';
import 'use_cases/01_inputs/v_link.dart';
import 'use_cases/01_inputs/v_radio.dart';
import 'use_cases/01_inputs/v_select.dart';
import 'use_cases/01_inputs/v_slider.dart';
import 'use_cases/01_inputs/v_switch.dart';
import 'use_cases/01_inputs/v_text_area.dart';
import 'use_cases/01_inputs/v_text_field.dart';
import 'use_cases/01_inputs/v_toggle_button.dart';
import 'use_cases/02_data_display/v_avatar.dart';
import 'use_cases/02_data_display/v_badge.dart';
import 'use_cases/02_data_display/v_check_list_tile.dart';
import 'use_cases/02_data_display/v_chip.dart';
import 'use_cases/02_data_display/v_dismissible.dart';
import 'use_cases/02_data_display/v_divider.dart';
import 'use_cases/02_data_display/v_hover_card.dart';
import 'use_cases/02_data_display/v_image.dart';
import 'use_cases/02_data_display/v_list_tile.dart';
import 'use_cases/02_data_display/v_setting_tile.dart';
import 'use_cases/02_data_display/v_switch_list_tile.dart';
import 'use_cases/02_data_display/v_table.dart';
import 'use_cases/02_data_display/v_tooltip.dart';
import 'use_cases/03_feedback/v_alert.dart';
import 'use_cases/03_feedback/v_alert_dialog.dart';
import 'use_cases/03_feedback/v_backdrop.dart';
import 'use_cases/03_feedback/v_dialog.dart';
import 'use_cases/03_feedback/v_empty_state.dart';
import 'use_cases/03_feedback/v_loading_spinner.dart';
import 'use_cases/03_feedback/v_progress.dart';
import 'use_cases/03_feedback/v_skeleton.dart';
import 'use_cases/03_feedback/v_snackbar.dart';
import 'use_cases/03_feedback/v_toast.dart';
import 'use_cases/04_surfaces/v_accordion.dart';
import 'use_cases/04_surfaces/v_card.dart';
import 'use_cases/04_surfaces/v_popover.dart';
import 'use_cases/04_surfaces/v_sheet.dart';
import 'use_cases/05_navigation/v_app_bar.dart';
import 'use_cases/05_navigation/v_bottom_nav.dart';
import 'use_cases/05_navigation/v_breadcrumb.dart';
import 'use_cases/05_navigation/v_command.dart';
import 'use_cases/05_navigation/v_drawer.dart';
import 'use_cases/05_navigation/v_menu.dart';
import 'use_cases/05_navigation/v_page_indicator.dart';
import 'use_cases/05_navigation/v_pagination.dart';
import 'use_cases/05_navigation/v_stepper.dart';
import 'use_cases/05_navigation/v_tabs.dart';
import 'use_cases/06_layout/v_app.dart';
import 'use_cases/06_layout/v_box.dart';
import 'use_cases/06_layout/v_carousel.dart';
import 'use_cases/06_layout/v_grid.dart';
import 'use_cases/06_layout/v_resizable.dart';
import 'use_cases/06_layout/v_scaffold.dart';
import 'use_cases/06_layout/v_scroll_area.dart';
import 'use_cases/06_layout/v_section.dart';
import 'use_cases/06_layout/v_stack.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadPretendardFont();
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) => Widgetbook(
    appBuilder: (context, child) {
      final baseTheme = context.knobs.object.dropdown<VThemeData>(
        label: 'Theme',
        options: [VThemeData.light(), VThemeData.dark()],
        labelBuilder: (theme) => theme.isDark ? 'Dark' : 'Light',
      );
      // Widgetbook only: inject the loaded Pretendard font into every TextStyle
      const ff = 'Pretendard Variable';
      final bt = baseTheme.typography;
      final theme = baseTheme.copyWith(
        typography: bt.copyWith(
          fontFamily: ff,
          displayLarge: bt.displayLarge.copyWith(fontFamily: ff),
          displayMedium: bt.displayMedium.copyWith(fontFamily: ff),
          displaySmall: bt.displaySmall.copyWith(fontFamily: ff),
          headlineLarge: bt.headlineLarge.copyWith(fontFamily: ff),
          headlineMedium: bt.headlineMedium.copyWith(fontFamily: ff),
          headlineSmall: bt.headlineSmall.copyWith(fontFamily: ff),
          titleLarge: bt.titleLarge.copyWith(fontFamily: ff),
          titleMedium: bt.titleMedium.copyWith(fontFamily: ff),
          titleSmall: bt.titleSmall.copyWith(fontFamily: ff),
          bodyLarge: bt.bodyLarge.copyWith(fontFamily: ff),
          bodyMedium: bt.bodyMedium.copyWith(fontFamily: ff),
          bodySmall: bt.bodySmall.copyWith(fontFamily: ff),
          labelLarge: bt.labelLarge.copyWith(fontFamily: ff),
          labelMedium: bt.labelMedium.copyWith(fontFamily: ff),
          labelSmall: bt.labelSmall.copyWith(fontFamily: ff),
        ),
      );
      return VTheme(
        data: theme,
        child: ColoredBox(color: theme.colors.background, child: child),
      );
    },
    directories: [
      // about - Library introduction
      WidgetbookCategory(name: 'About', children: [aboutComponent()]),
      // foundation - Design tokens
      WidgetbookCategory(
        name: 'Foundation',
        children: [
          // Foundation pages in reading order
          colorComponent(),
          typographyComponent(),
          sizeComponent(),
          spacingComponent(),
          radiusComponent(),
          borderComponent(),
          shadowComponent(),
          gradientComponent(),
          animationComponent(),
          iconComponent(),
        ],
      ),
      // components - UI components
      WidgetbookCategory(
        name: 'Components',
        children: [
          // inputs — Actions → Text → Selection → Value → Form
          WidgetbookCategory(
            name: 'Inputs',
            children: [
              // Actions
              vButtonComponent(),
              vButtonGroupComponent(),
              vToggleButtonComponent(),
              vIconButtonComponent(),
              vFabComponent(),
              vLinkComponent(),
              vLabelComponent(),
              // Text Input
              vTextFieldComponent(),
              vTextAreaComponent(),
              vAutocompleteComponent(),
              // Selection
              vCheckboxComponent(),
              vRadioComponent(),
              vSwitchComponent(),
              vSelectComponent(),
              // Value
              vSliderComponent(),
              vCalendarComponent(),
              vDatePickerComponent(),
              // Form Structure
              vFormComponent(),
              vFormFieldComponent(),
              vFormBodyComponent(),
              vFormHeaderComponent(),
              vFormFooterComponent(),
            ],
          ),
          // data-display — Content → Lists → Data → Structure
          WidgetbookCategory(
            name: 'Data Display',
            children: [
              // Content
              vImageComponent(),
              vAvatarComponent(),
              vBadgeComponent(),
              vChipComponent(),
              // Lists
              vListTileComponent(),
              vCheckListTileComponent(),
              vSwitchListTileComponent(),
              vSettingTileComponent(),
              vDismissibleComponent(),
              // Data
              vTableComponent(),
              vTooltipComponent(),
              vHoverCardComponent(),
              // Structure
              vDividerComponent(),
            ],
          ),
          // feedback
          WidgetbookCategory(
            name: 'Feedback',
            children: [
              vAlertComponent(),
              vAlertDialogComponent(),
              vBackdropComponent(),
              vDialogComponent(),
              vEmptyStateComponent(),
              vLoadingSpinnerComponent(),
              vProgressComponent(),
              vSkeletonComponent(),
              vSnackbarComponent(),
              vToastComponent(),
            ],
          ),
          // surfaces
          WidgetbookCategory(
            name: 'Surfaces',
            children: [
              vAccordionComponent(),
              vCardComponent(),
              vPopoverComponent(),
              vSheetComponent(),
            ],
          ),
          // navigation — App Structure → Page Nav → Actions
          WidgetbookCategory(
            name: 'Navigation',
            children: [
              // App Structure
              vAppBarComponent(),
              vBottomNavComponent(),
              vDrawerComponent(),
              // Page Navigation
              vTabsComponent(),
              vBreadcrumbComponent(),
              vPaginationComponent(),
              vPageIndicatorComponent(),
              vStepperComponent(),
              // Actions
              vMenuComponent(),
              vCommandComponent(),
            ],
          ),
          // layout — Structure → Content
          WidgetbookCategory(
            name: 'Layout',
            children: [
              // Structure
              vAppComponent(),
              vScaffoldComponent(),
              vBoxComponent(),
              vStackComponent(),
              vGridComponent(),
              // Content
              vSectionComponent(),
              vScrollAreaComponent(),
              vCarouselComponent(),
              vResizableComponent(),
            ],
          ),
        ],
      ),
    ],
  );
}
