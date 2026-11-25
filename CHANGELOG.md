# Changelog

## 0.1.3

### Breaking changes

- **tabs:** announce tabs as a tab bar, tabs and a tab panel (fbee95c)

### Features

- **a11y:** keep every tappable widget at least minTapTargetSize (c405bc8)
- **icons:** add fromPath and eight common glyphs (c0af6a1)
- **badge:** add borderColor and padding to the style (b100616)
- **section:** add divider indent and color to the style, header alignment (f089021)
- **setting-tile:** add a radio row (ef88a23)
- **list-tile:** add leadingMinHeight to the style (ce6afe1)
- **empty-state:** add iconGap, descriptionGap and actionGap to the style (d9e88a6)
- **stack:** add textBaseline for baseline alignment (1538062)
- **app-bar:** add toolbarHeight and leadingWidth (85beeab)
- **toggle-button:** add track and text styles to the group style (6a4f167)
- **alert:** add showIcon and a minimum tap area for the close button (edd2aa7)
- **utils:** add VMinTapTarget to grow a tap area around a drawn widget (e742000)
- **theme:** add minTapTargetSize to VThemeData (f8614de)

### Fixes

- **a11y:** reach minTapTargetSize on the slider track and sortable table headers (7b223c0)
- **avatar:** reach minTapTargetSize when the avatar is tappable (731f687)
- **a11y:** grow only the tap area of controls nested in a drawn container (7af0950)
- **scaffold:** let an extended body reach the bottom of the screen (a991689)

## 0.1.2

### Breaking changes

- keep a Flexible passed as the VButton child from competing (b0b4a7f)
- **style:** drop VLinkStyle.visitedColor (9f05210)
- **style:** add VScaffold.style and drop the VScaffoldStyle colors of other widgets (4a0ef58)
- **style:** read VFabStyle fields and replace its elevation with shadows (6032347)
- **style:** replace elevation with shadows in VCard, VPopover and VCommand styles (436b667)
- **style:** give VBottomNavStyle shadows and drop its unread fields (8e5275e)
- **menu:** open VMenu from a controller and style its panel (49c7dbc)
- **style:** read VTabsStyle and add text styles (7f884bc)
- **style:** give VDialogStyle and VAlertDialogStyle shadows instead of elevation (9ba3af8)
- **style:** read VSheetStyle border color and padding, drop its elevation (cf70588)

### Features

- **tooling:** add look_alikes to catch app widgets that rebuild a library widget (de0bacd)
- **tabs:** drive VTabs from a controller and swipe between panels (c9a997b)
- **list-tile:** style the leading slot, gaps and minimum height (64d7965)
- add VDismissible with a screen reader action (fff348c)
- add VEmptyState for an empty list or screen (b4004b0)
- **app:** add VApp.router for router-driven apps (a741233)
- **icons:** add nine icons and fall back to the IconTheme color (7f32112)

### Fixes

- keep disabled and read-only pickers and selects closed on tap (d7abfbe)
- **style:** let VChipStyle set the chip text style (62d3ffd)
- **tooling:** let look_alikes take any button and a reasoned look-alike marker (7332b21)
- **widgetbook:** use VChip instead of a hand-built chip and rename a stat block (16d61e5)
- **a11y:** let VToggleButton and its group segments grow with large text (59df2d2)
- **style:** let the VButtonGroup spacing argument win over the style (0a43e5e)
- **style:** place the floating VFormHeader label with a spacing token (499b58c)
- keep the VButton pill fully rounded when it grows (f147075)
- let VButton take its size from VButtonGroup (b155999)
- **a11y:** make VToggleButtonGroup segments focusable and announce their state (89c3698)
- **a11y:** let VFormBody and the VSelect trigger grow with large text (a8e6444)
- **style:** read VFormFieldStyle helper and error styles (40b75b3)
- **style:** read VButtonGroupStyle borderColor and borderRadius (9f78b58)
- **style:** let VToggleButtonGroup read VToggleButtonStyle (55e89bd)
- **style:** read VSelectStyle and show a focus border on VSelect (d8ae05d)
- **a11y:** wrap long VFormHeader labels (a361700)
- **style:** pass VTextFieldStyle to its body and header (6c0fbd2)
- **style:** read every VButtonStyle and VIconButtonStyle field (6ba5c37)
- **a11y:** let VButton grow with its text and wrap long labels (f5c7453)
- **style:** read VAppBarStyle, VDrawerStyle and VPaginationStyle colors (55e5d88)
- **style:** read VDatePickerStyle and show a focus border on VDatePicker (f02fc16)
- **style:** read VAutocompleteStyle text and dropdown fields (9d01d4d)
- **style:** let VCardStyle.foregroundColor color the card's text and icons (af718de)
- **style:** read VImage, VProgress, VCarousel and VCheckListTile style fields (3eea44e)
- **a11y:** shrink VBottomNav labels to fit the tab (731a34a)
- **style:** let VBadgeStyle set the badge text style (41b270f)
- **a11y:** let VChip grow with its text and stay inert without callbacks (a168950)
- **style:** read VAppStyle background and text colors (25627fe)
- **widgetbook:** build the VApp mode card with VCard (fb4ad9b)
- **a11y:** drop the unlabeled tap layer behind VBottomSheet and VSideSheet (0978e5e)

## 0.1.1

### Features

- **index:** tell agents to try parameters first and report gaps (22431f5)

### Fixes

- **a11y:** read a switch or check tile once, hug tile content, add the VBottomNav top bar (a56492e)

## 0.1.0

### Features

- add volo_flutter_ui, the Volo Flutter design system (898b578)
