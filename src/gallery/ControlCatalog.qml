pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property var categories: [
        { key: "buttons", title: qsTr("Buttons"), icon: "\uE8A7" },
        { key: "basic", title: qsTr("Basic input"), icon: "\uE73A" },
        { key: "text", title: qsTr("Text"), icon: "\uE8D2" },
        { key: "collections", title: qsTr("Collections"), icon: "\uE8FD" },
        { key: "menus", title: qsTr("Menus & toolbars"), icon: "\uE712" },
        { key: "navigation", title: qsTr("Navigation"), icon: "\uE76C" },
        { key: "layout", title: qsTr("Layout"), icon: "\uE8A5" },
        { key: "scrolling", title: qsTr("Scrolling"), icon: "\uE76F" },
        { key: "date", title: qsTr("Date & time"), icon: "\uE787" },
        { key: "dialogs", title: qsTr("Dialogs & flyouts"), icon: "\uE8A1" },
        { key: "status", title: qsTr("Status & info"), icon: "\uE946" },
        { key: "charts", title: qsTr("Charts"), icon: "\uE9D2" }
    ]

    readonly property var controls: [
        {
            title: qsTr("Button"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("A control that responds to user input and raises a Click event."),
            component: "ButtonPage",
            source: "pages/ButtonPage.qml"
        },
        {
            title: qsTr("CheckBox"),
            category: "basic",
            icon: "\uE73A",
            description: qsTr("A control that a user can select or clear."),
            component: "CheckBoxPage",
            source: "pages/CheckBoxPage.qml"
        },
        {
            title: qsTr("RadioButton"),
            category: "basic",
            icon: "\uECCA",
            description: qsTr("A control that allows a user to select a single option from a group."),
            component: "RadioButtonPage",
            source: "pages/RadioButtonPage.qml"
        },
        {
            title: qsTr("Slider"),
            category: "basic",
            icon: "\uE9E9",
            description: qsTr("A control that lets the user select from a range of values by moving a thumb."),
            component: "SliderPage",
            source: "pages/SliderPage.qml"
        },
        {
            title: qsTr("RangeSlider"),
            category: "basic",
            icon: "\uE9E9",
            description: qsTr("A slider with two thumbs for selecting a value range."),
            component: "RangeSliderPage",
            source: "pages/RangeSliderPage.qml"
        },
        {
            title: qsTr("Switch"),
            category: "basic",
            icon: "\uE9CE",
            description: qsTr("A binary on/off control that can be toggled."),
            component: "SwitchPage",
            source: "pages/SwitchPage.qml"
        },
        {
            title: qsTr("ComboBox"),
            category: "basic",
            icon: "\uE70D",
            description: qsTr("A drop-down list of selectable items."),
            component: "ComboBoxPage",
            source: "pages/ComboBoxPage.qml"
        },
        {
            title: qsTr("SpinBox"),
            category: "basic",
            icon: "\uE8EF",
            description: qsTr("A control for selecting a numeric value."),
            component: "SpinBoxPage",
            source: "pages/SpinBoxPage.qml"
        },
        {
            title: qsTr("Dial"),
            category: "basic",
            icon: "\uE9E9",
            description: qsTr("A circular dial for selecting a value from a range."),
            component: "DialPage",
            source: "pages/DialPage.qml"
        },
        {
            title: qsTr("RatingControl"),
            category: "basic",
            icon: "\uE734",
            description: qsTr("A star rating control for collecting or displaying ratings."),
            component: "RatingControlPage",
            source: "pages/RatingControlPage.qml"
        },
        {
            title: qsTr("NumberBox"),
            category: "basic",
            icon: "\uE8EF",
            description: qsTr("A numeric input with spin buttons and value constraints."),
            component: "NumberBoxPage",
            source: "pages/NumberBoxPage.qml"
        },
        {
            title: qsTr("SplitButton"),
            category: "buttons",
            icon: "\uE70D",
            description: qsTr("A primary action plus a flyout for related commands."),
            component: "SplitButtonPage",
            source: "pages/SplitButtonPage.qml"
        },
        {
            title: qsTr("ToggleButton"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("A button that toggles between on and off states."),
            component: "ToggleButtonPage",
            source: "pages/ToggleButtonPage.qml"
        },
        {
            title: qsTr("ToggleSplitButton"),
            category: "buttons",
            icon: "\uE70D",
            description: qsTr("A checkable primary action with a related command flyout."),
            component: "ToggleSplitButtonPage",
            source: "pages/ToggleSplitButtonPage.qml"
        },
        {
            title: qsTr("SelectorBar"),
            category: "basic",
            icon: "\uE8A1",
            description: qsTr("A compact segmented control for mutually exclusive options."),
            component: "SelectorBarPage",
            source: "pages/SelectorBarPage.qml"
        },
        {
            title: qsTr("RadioButtons"),
            category: "basic",
            icon: "\uECCA",
            description: qsTr("A labeled group of mutually exclusive radio options."),
            component: "RadioButtonsPage",
            source: "pages/RadioButtonsPage.qml"
        },
        {
            title: qsTr("ColorPicker"),
            category: "basic",
            icon: "\uE790",
            description: qsTr("A selectable color spectrum."),
            component: "ColorPickerPage",
            source: "pages/ColorPickerPage.qml"
        },
        {
            title: qsTr("AppBarButton"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("An icon-and-label command button for app bars and tool strips."),
            component: "AppBarButtonPage",
            source: "pages/AppBarButtonPage.qml"
        },
        {
            title: qsTr("AppBarToggleButton"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("A checkable app-bar button that stays on until toggled off."),
            component: "AppBarToggleButtonPage",
            source: "pages/AppBarToggleButtonPage.qml"
        },
        {
            title: qsTr("Chip"),
            category: "buttons",
            icon: "\uE8FD",
            description: qsTr("A compact selectable or closable tag."),
            component: "ChipPage",
            source: "pages/ChipPage.qml"
        },
        {
            title: qsTr("AccentButton"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("A primary accent-colored button for the main call to action."),
            component: "AccentButtonPage",
            source: "pages/AccentButtonPage.qml"
        },
        {
            title: qsTr("IconButton"),
            category: "buttons",
            icon: "\uE8A7",
            description: qsTr("A compact icon-only button for toolbars and dense UIs."),
            component: "IconButtonPage",
            source: "pages/IconButtonPage.qml"
        },
        {
            title: qsTr("TextField"),
            category: "text",
            icon: "\uE8D2",
            description: qsTr("A single-line text input control."),
            component: "TextFieldPage",
            source: "pages/TextFieldPage.qml"
        },
        {
            title: qsTr("TextArea"),
            category: "text",
            icon: "\uE8A5",
            description: qsTr("A multi-line text input control."),
            component: "TextAreaPage",
            source: "pages/TextAreaPage.qml"
        },
        {
            title: qsTr("PasswordBox"),
            category: "text",
            icon: "\uE72E",
            description: qsTr("A text field for passwords with a reveal button."),
            component: "PasswordBoxPage",
            source: "pages/PasswordBoxPage.qml"
        },
        {
            title: qsTr("AutoSuggestBox"),
            category: "text",
            icon: "\uE721",
            description: qsTr("A text field that suggests matching items as you type."),
            component: "AutoSuggestBoxPage",
            source: "pages/AutoSuggestBoxPage.qml"
        },
        {
            title: qsTr("SearchBox"),
            category: "text",
            icon: "\uE721",
            description: qsTr("A search field with clear button, without suggestion popup."),
            component: "SearchBoxPage",
            source: "pages/SearchBoxPage.qml"
        },
        {
            title: qsTr("TokenizingTextBox"),
            category: "text",
            icon: "\uE8F1",
            description: qsTr("A text box that converts typed text into tokens."),
            component: "TokenizingTextBoxPage",
            source: "pages/TokenizingTextBoxPage.qml"
        },
        {
            title: qsTr("Label"),
            category: "text",
            icon: "\uE8D2",
            description: qsTr("A text label for captions and descriptions."),
            component: "LabelPage",
            source: "pages/LabelPage.qml"
        },
        {
            title: qsTr("HyperlinkButton"),
            category: "buttons",
            icon: "\uE71B",
            description: qsTr("A button that appears as a hyperlink."),
            component: "HyperlinkButtonPage",
            source: "pages/HyperlinkButtonPage.qml"
        },
        {
            title: qsTr("TabBar"),
            category: "navigation",
            icon: "\uE8A1",
            description: qsTr("A horizontal set of tabs for switching views."),
            component: "TabBarPage",
            source: "pages/TabBarPage.qml"
        },
        {
            title: qsTr("PageIndicator"),
            category: "navigation",
            icon: "\uE909",
            description: qsTr("Dots that show the current page in a multi-page view."),
            component: "PageIndicatorPage",
            source: "pages/PageIndicatorPage.qml"
        },
        {
            title: qsTr("SwipeView"),
            category: "navigation",
            icon: "\uE76B",
            description: qsTr("A swipeable multi-page container."),
            component: "SwipeViewPage",
            source: "pages/SwipeViewPage.qml"
        },
        {
            title: qsTr("GroupBox"),
            category: "collections",
            icon: "\uE8FD",
            description: qsTr("A container that groups related controls under a label."),
            component: "GroupBoxPage",
            source: "pages/GroupBoxPage.qml"
        },
        {
            title: qsTr("ScrollBar"),
            category: "scrolling",
            icon: "\uE76B",
            description: qsTr("A control for scrolling content vertically or horizontally."),
            component: "ScrollBarPage",
            source: "pages/ScrollBarPage.qml"
        },
        {
            title: qsTr("AnnotatedScrollBar"),
            category: "scrolling",
            icon: "\uE76F",
            description: qsTr("A scrollable region whose scrollbar shows a label while dragging."),
            component: "AnnotatedScrollBarPage",
            source: "pages/AnnotatedScrollBarPage.qml"
        },
        {
            title: qsTr("Delegates"),
            category: "collections",
            icon: "\uE8FD",
            description: qsTr("Check, switch, and radio list delegates."),
            component: "DelegatesPage",
            source: "pages/DelegatesPage.qml"
        },
        {
            title: qsTr("Expander"),
            category: "collections",
            icon: "\uE70D",
            description: qsTr("A collapsible container for progressive disclosure."),
            component: "ExpanderPage",
            source: "pages/ExpanderPage.qml"
        },
        {
            title: qsTr("SwipeDelegate"),
            category: "collections",
            icon: "\uE8FD",
            description: qsTr("A list delegate that reveals actions when swiped."),
            component: "SwipeDelegatePage",
            source: "pages/SwipeDelegatePage.qml"
        },
        {
            title: qsTr("TreeView"),
            category: "collections",
            icon: "\uE8F0",
            description: qsTr("Hierarchical rows styled with TreeViewDelegate."),
            component: "TreeViewPage",
            source: "pages/TreeViewPage.qml"
        },
        {
            title: qsTr("TreeView recipe"),
            category: "collections",
            icon: "\uE8F0",
            description: qsTr("Tree rows with context MenuFlyout (expand / rename / delete)."),
            component: "TreeViewRecipePage",
            source: "pages/TreeViewRecipePage.qml"
        },
        {
            title: qsTr("ItemsView"),
            category: "collections",
            icon: "\uE8A9",
            description: qsTr("List recipe: sections, multi-select, context menu, empty state."),
            component: "ItemsViewPage",
            source: "pages/ItemsViewPage.qml"
        },
        {
            title: qsTr("ListDetailsView"),
            category: "collections",
            icon: "\uE8A9",
            description: qsTr("Master–detail recipe on TwoPaneView with list selection."),
            component: "ListDetailsViewPage",
            source: "pages/ListDetailsViewPage.qml"
        },
        {
            title: qsTr("BreadcrumbBar"),
            category: "navigation",
            icon: "\uE76C",
            description: qsTr("Shows the current path and lets users navigate ancestors."),
            component: "BreadcrumbBarPage",
            source: "pages/BreadcrumbBarPage.qml"
        },
        {
            title: qsTr("NavigationView"),
            category: "navigation",
            icon: "\uE700",
            description: qsTr("Top-level navigation with a collapsible pane and page host."),
            component: "NavigationViewPage",
            source: "pages/NavigationViewPage.qml"
        },
        {
            title: qsTr("TitleBar"),
            category: "navigation",
            icon: "\uE737",
            description: qsTr("WinUI TitleBar with Back, PaneToggle, Subtitle, Content, and RightHeader."),
            component: "TitleBarPage",
            source: "pages/TitleBarPage.qml"
        },
        {
            title: qsTr("Window shells"),
            category: "navigation",
            icon: "\uE8A7",
            description: qsTr("Window roles (paradigm/presenter) + Blank/Navigation/MenuStatus shells."),
            component: "WindowParadigmPage",
            source: "pages/WindowParadigmPage.qml"
        },
        {
            title: qsTr("TableView"),
            category: "collections",
            icon: "\uE8A9",
            description: qsTr("Tabular data with styled horizontal and vertical headers."),
            component: "TableViewPage",
            source: "pages/TableViewPage.qml"
        },
        {
            title: qsTr("TabView"),
            category: "collections",
            icon: "\uE8A1",
            description: qsTr("A multi-document tab strip with closable tabs."),
            component: "TabViewPage",
            source: "pages/TabViewPage.qml"
        },
        {
            title: qsTr("FlipView"),
            category: "navigation",
            icon: "\uE76B",
            description: qsTr("A swipeable page container with previous and next buttons."),
            component: "FlipViewPage",
            source: "pages/FlipViewPage.qml"
        },
        {
            title: qsTr("PipsPager"),
            category: "navigation",
            icon: "\uE909",
            description: qsTr("Clickable page indicator dots for multi-page views."),
            component: "PipsPagerPage",
            source: "pages/PipsPagerPage.qml"
        },
        {
            title: qsTr("PagerControl"),
            category: "navigation",
            icon: "\uE76C",
            description: qsTr("Numbered page navigation with previous and next."),
            component: "PagerControlPage",
            source: "pages/PagerControlPage.qml"
        },
        {
            title: qsTr("StepBar"),
            category: "navigation",
            icon: "\uE8FD",
            description: qsTr("A horizontal step indicator for multi-step flows."),
            component: "StepBarPage",
            source: "pages/StepBarPage.qml"
        },
        {
            title: qsTr("Pane"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A styled content panel with padding and background."),
            component: "PanePage",
            source: "pages/PanePage.qml"
        },
        {
            title: qsTr("SplitView"),
            category: "layout",
            icon: "\uE74A",
            description: qsTr("A view with resizable panes separated by a splitter."),
            component: "SplitViewPage",
            source: "pages/SplitViewPage.qml"
        },
        {
            title: qsTr("Drawer"),
            category: "layout",
            icon: "\uE700",
            description: qsTr("A slide-out panel anchored to a window edge."),
            component: "DrawerPage",
            source: "pages/DrawerPage.qml"
        },
        {
            title: qsTr("StackView"),
            category: "navigation",
            icon: "\uE76B",
            description: qsTr("A stack-based navigation container with animated transitions."),
            component: "StackViewPage",
            source: "pages/StackViewPage.qml"
        },
        {
            title: qsTr("CommandBar"),
            category: "menus",
            icon: "\uE712",
            description: qsTr("A compact toolbar for frequent commands."),
            component: "CommandBarPage",
            source: "pages/CommandBarPage.qml"
        },
        {
            title: qsTr("CommandBarFlyout"),
            category: "menus",
            icon: "\uE712",
            description: qsTr("A flyout that hosts a compact command bar with optional secondary actions."),
            component: "CommandBarFlyoutPage",
            source: "pages/CommandBarFlyoutPage.qml"
        },
        {
            title: qsTr("AppBarSeparator"),
            category: "menus",
            icon: "\uE76C",
            description: qsTr("A thin divider for grouping commands in an app bar or command bar."),
            component: "AppBarSeparatorPage",
            source: "pages/AppBarSeparatorPage.qml"
        },
        {
            title: qsTr("ToolBar"),
            category: "menus",
            icon: "\uE90F",
            description: qsTr("A container for command buttons and related controls."),
            component: "ToolBarPage",
            source: "pages/ToolBarPage.qml"
        },
        {
            title: qsTr("MenuBar"),
            category: "menus",
            icon: "\uE700",
            description: qsTr("A horizontal bar of cascading menus for an application window."),
            component: "MenuBarPage",
            source: "pages/MenuBarPage.qml"
        },
        {
            title: qsTr("SettingsCard"),
            category: "layout",
            icon: "\uE713",
            description: qsTr("Settings row; toggle: true for a built-in Switch."),
            component: "SettingsCardPage",
            source: "pages/SettingsCardPage.qml"
        },
        {
            title: qsTr("Settings combo & slider"),
            category: "layout",
            icon: "\uE70D",
            description: qsTr("SettingsComboCard and SettingsSliderCard conveniences."),
            component: "SettingsComboSliderPage",
            source: "pages/SettingsComboSliderPage.qml"
        },
        {
            title: qsTr("SettingsGroup"),
            category: "layout",
            icon: "\uE8FD",
            description: qsTr("SettingsView + SettingsGroup; SettingsCard.toggle for Switch rows."),
            component: "SettingsGroupPage",
            source: "pages/SettingsGroupPage.qml"
        },
        {
            title: qsTr("StatusBar"),
            category: "layout",
            icon: "\uE7C3",
            description: qsTr("A bottom status strip with text, progress, and slots."),
            component: "StatusBarPage",
            source: "pages/StatusBarPage.qml"
        },
        {
            title: qsTr("SettingsExpander"),
            category: "layout",
            icon: "\uE70D",
            description: qsTr("An expandable settings group with title and description."),
            component: "SettingsExpanderPage",
            source: "pages/SettingsExpanderPage.qml"
        },
        {
            title: qsTr("WrapPanel"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A panel that arranges child elements in wrapping rows or columns."),
            component: "WrapPanelPage",
            source: "pages/WrapPanelPage.qml"
        },
        {
            title: qsTr("HeaderedContentControl"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A content container with a header above the body."),
            component: "HeaderedContentControlPage",
            source: "pages/HeaderedContentControlPage.qml"
        },
        {
            title: qsTr("UniformGrid"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A grid that sizes all cells equally."),
            component: "UniformGridPage",
            source: "pages/UniformGridPage.qml"
        },
        {
            title: qsTr("DockPanel"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("Arranges children along edges with a center fill region."),
            component: "DockPanelPage",
            source: "pages/DockPanelPage.qml"
        },
        {
            title: qsTr("Frame"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A simple styled container with padding and a surface fill."),
            component: "FramePage",
            source: "pages/FramePage.qml"
        },
        {
            title: qsTr("ContentCard"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("An elevated card with optional title, subtitle, and body content."),
            component: "ContentCardPage",
            source: "pages/ContentCardPage.qml"
        },
        {
            title: qsTr("PersonPicture"),
            category: "layout",
            icon: "\uE77B",
            description: qsTr("Displays a person's avatar, initials, or silhouette."),
            component: "PersonPicturePage",
            source: "pages/PersonPicturePage.qml"
        },
        {
            title: qsTr("Calendar"),
            category: "date",
            icon: "\uE787",
            description: qsTr("MonthGrid and DayOfWeekRow for building calendar views."),
            component: "CalendarPage",
            source: "pages/CalendarPage.qml"
        },
        {
            title: qsTr("CalendarDatePicker"),
            category: "date",
            icon: "\uE787",
            description: qsTr("Pick a date from a calendar flyout."),
            component: "CalendarDatePickerPage",
            source: "pages/CalendarDatePickerPage.qml"
        },
        {
            title: qsTr("DatePicker"),
            category: "date",
            icon: "\uE787",
            description: qsTr("Pick a date with year, month, and day tumblers."),
            component: "DatePickerPage",
            source: "pages/DatePickerPage.qml"
        },
        {
            title: qsTr("Tumbler"),
            category: "date",
            icon: "\uE81C",
            description: qsTr("A spinning wheel for selecting values from a list."),
            component: "TumblerPage",
            source: "pages/TumblerPage.qml"
        },
        {
            title: qsTr("TimePicker"),
            category: "date",
            icon: "\uE823",
            description: qsTr("Pick a time with hour and minute tumblers."),
            component: "TimePickerPage",
            source: "pages/TimePickerPage.qml"
        },
        {
            title: qsTr("Dialog"),
            category: "dialogs",
            icon: "\uE8A1",
            description: qsTr("A modal dialog that prompts for user interaction."),
            component: "DialogPage",
            source: "pages/DialogPage.qml"
        },
        {
            title: qsTr("ContentDialog"),
            category: "dialogs",
            icon: "\uE8A1",
            description: qsTr("A modal dialog with primary, secondary, and close actions."),
            component: "ContentDialogPage",
            source: "pages/ContentDialogPage.qml"
        },
        {
            title: qsTr("Flyout"),
            category: "dialogs",
            icon: "\uE75A",
            description: qsTr("A lightweight dismissible popup anchored to a control."),
            component: "FlyoutPage",
            source: "pages/FlyoutPage.qml"
        },
        {
            title: qsTr("TeachingTip"),
            category: "dialogs",
            icon: "\uE946",
            description: qsTr("A tip that teaches users about a new or important feature."),
            component: "TeachingTipPage",
            source: "pages/TeachingTipPage.qml"
        },
        {
            title: qsTr("InfoButton"),
            category: "dialogs",
            icon: "\uE946",
            description: qsTr("Info glyph that opens a TeachingTip."),
            component: "InfoButtonPage",
            source: "pages/InfoButtonPage.qml"
        },
        {
            title: qsTr("ToolTip"),
            category: "dialogs",
            icon: "\uE82F",
            description: qsTr("A short tip shown when the user hovers a control."),
            component: "ToolTipPage",
            source: "pages/ToolTipPage.qml"
        },
        {
            title: qsTr("Menu"),
            category: "menus",
            icon: "\uE700",
            description: qsTr("A menu of commands and options."),
            component: "MenuPage",
            source: "pages/MenuPage.qml"
        },
        {
            title: qsTr("DropDownButton"),
            category: "buttons",
            icon: "\uE70D",
            description: qsTr("A button that opens a menu of commands."),
            component: "DropDownButtonPage",
            source: "pages/DropDownButtonPage.qml"
        },
        {
            title: qsTr("ProgressBar"),
            category: "status",
            icon: "\uE9D9",
            description: qsTr("Shows the progress of an operation."),
            component: "ProgressBarPage",
            source: "pages/ProgressBarPage.qml"
        },
        {
            title: qsTr("ProgressRing"),
            category: "status",
            icon: "\uE895",
            description: qsTr("A circular determinate or indeterminate progress indicator."),
            component: "ProgressRingPage",
            source: "pages/ProgressRingPage.qml"
        },
        {
            title: qsTr("RadialGauge"),
            category: "status",
            icon: "\uE9E9",
            description: qsTr("Toolkit-style radial needle gauge (MinAngle, TickSpacing, ScaleWidth)."),
            component: "RadialGaugePage",
            source: "pages/RadialGaugePage.qml"
        },
        {
            title: qsTr("LinearGauge"),
            category: "status",
            icon: "\uE9D9",
            description: qsTr("A horizontal or vertical linear gauge with thumb and thresholds."),
            component: "LinearGaugePage",
            source: "pages/LinearGaugePage.qml"
        },
        {
            title: qsTr("ArcGauge"),
            category: "status",
            icon: "\uE9E9",
            description: qsTr("A semicircle dashboard gauge with a large center value."),
            component: "ArcGaugePage",
            source: "pages/ArcGaugePage.qml"
        },
        {
            title: qsTr("SegmentedGauge"),
            category: "status",
            icon: "\uE895",
            description: qsTr("A ring divided into discrete segments for steps or quota."),
            component: "SegmentedGaugePage",
            source: "pages/SegmentedGaugePage.qml"
        },
        {
            title: qsTr("ZoneGauge"),
            category: "status",
            icon: "\uE9E9",
            description: qsTr("A needle gauge with colored zone bands (Toolkit-style)."),
            component: "ZoneGaugePage",
            source: "pages/ZoneGaugePage.qml"
        },
        {
            title: qsTr("RingGauge"),
            category: "status",
            icon: "\uE9E9",
            description: qsTr("A closed-ring KPI gauge with a large center value."),
            component: "RingGaugePage",
            source: "pages/RingGaugePage.qml"
        },
        {
            title: qsTr("TankGauge"),
            category: "status",
            icon: "\uE9D9",
            description: qsTr("A vertical tank / reservoir level gauge."),
            component: "TankGaugePage",
            source: "pages/TankGaugePage.qml"
        },
        {
            title: qsTr("ThermometerGauge"),
            category: "status",
            icon: "\uE9D2",
            description: qsTr("A classic stem-and-bulb thermometer gauge."),
            component: "ThermometerGaugePage",
            source: "pages/ThermometerGaugePage.qml"
        },
        {
            title: qsTr("KpiTile"),
            category: "status",
            icon: "\uE9D2",
            description: qsTr("A compact KPI tile with delta and optional sparkline."),
            component: "KpiTilePage",
            source: "pages/KpiTilePage.qml"
        },
        {
            title: qsTr("Dashboard"),
            category: "status",
            icon: "\uE80F",
            description: qsTr("Composite monitoring layout with gauges, KPIs, and charts."),
            component: "DashboardPage",
            source: "pages/DashboardPage.qml"
        },
        {
            title: qsTr("BusyIndicator"),
            category: "status",
            icon: "\uE895",
            description: qsTr("An indeterminate progress indicator."),
            component: "BusyIndicatorPage",
            source: "pages/BusyIndicatorPage.qml"
        },
        {
            title: qsTr("InfoBar"),
            category: "status",
            icon: "\uE946",
            description: qsTr("An inline message that informs users of an app state."),
            component: "InfoBarPage",
            source: "pages/InfoBarPage.qml"
        },
        {
            title: qsTr("InfoBadge"),
            category: "status",
            icon: "\uEA3A",
            description: qsTr("A small badge for counts or status dots."),
            component: "InfoBadgePage",
            source: "pages/InfoBadgePage.qml"
        },
        {
            title: qsTr("Toast"),
            category: "status",
            icon: "\uE946",
            description: qsTr("A transient notification that auto-dismisses."),
            component: "ToastPage",
            source: "pages/ToastPage.qml"
        },
        {
            title: qsTr("System integration"),
            category: "dialogs",
            icon: "\uE8B7",
            description: qsTr("FilePicker dialogs and TrayIcon system notify bridge."),
            component: "SystemIntegrationPage",
            source: "pages/SystemIntegrationPage.qml"
        },
        {
            title: qsTr("MediaPlayerElement"),
            category: "status",
            icon: "\uE714",
            description: qsTr("Fluent media shell (requires Qt Multimedia / QWINUI3_BUILD_MEDIA)."),
            component: "MediaPlayerElementPage",
            source: "pages/MediaPlayerElementPage.qml"
        },
        {
            title: qsTr("SegmentedControl"),
            category: "basic",
            icon: "\uE8FD",
            description: qsTr("A mutually exclusive segmented option bar."),
            component: "SegmentedControlPage",
            source: "pages/SegmentedControlPage.qml"
        },
        {
            title: qsTr("StackPanel"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("Stacks children horizontally or vertically with spacing."),
            component: "StackPanelPage",
            source: "pages/StackPanelPage.qml"
        },
        {
            title: qsTr("MeterBar"),
            category: "status",
            icon: "\uE9D9",
            description: qsTr("A multi-segment meter for stacked values."),
            component: "MeterBarPage",
            source: "pages/MeterBarPage.qml"
        },
        {
            title: qsTr("Charts"),
            category: "charts",
            icon: "\uE9D2",
            description: qsTr("Overview of WinUI-style Canvas charts."),
            component: "ChartsPage",
            source: "pages/ChartsPage.qml"
        },
        {
            title: qsTr("Sparkline"),
            category: "charts",
            icon: "\uE9D9",
            description: qsTr("Compact inline trend glyph for dense data."),
            component: "SparklinePage",
            source: "pages/SparklinePage.qml"
        },
        {
            title: qsTr("LineChart"),
            category: "charts",
            icon: "\uE9D2",
            description: qsTr("Multi-series line and area chart."),
            component: "LineChartPage",
            source: "pages/LineChartPage.qml"
        },
        {
            title: qsTr("AreaChart"),
            category: "charts",
            icon: "\uE9D2",
            description: qsTr("Filled area chart with optional stacking."),
            component: "AreaChartPage",
            source: "pages/AreaChartPage.qml"
        },
        {
            title: qsTr("BarChart"),
            category: "charts",
            icon: "\uE9D9",
            description: qsTr("Vertical column chart in a single Canvas pass."),
            component: "BarChartPage",
            source: "pages/BarChartPage.qml"
        },
        {
            title: qsTr("HorizontalBarChart"),
            category: "charts",
            icon: "\uE9E6",
            description: qsTr("Horizontal bars for rankings and comparisons."),
            component: "HorizontalBarChartPage",
            source: "pages/HorizontalBarChartPage.qml"
        },
        {
            title: qsTr("StackedBarChart"),
            category: "charts",
            icon: "\uF56C",
            description: qsTr("Stacked columns for category composition."),
            component: "StackedBarChartPage",
            source: "pages/StackedBarChartPage.qml"
        },
        {
            title: qsTr("DonutChart"),
            category: "charts",
            icon: "\uEA3A",
            description: qsTr("Part-to-whole donut with legend and center label."),
            component: "DonutChartPage",
            source: "pages/DonutChartPage.qml"
        },
        {
            title: qsTr("PieChart"),
            category: "charts",
            icon: "\uEB05",
            description: qsTr("Solid pie chart with Fluent color tokens."),
            component: "PieChartPage",
            source: "pages/PieChartPage.qml"
        },
        {
            title: qsTr("ScatterChart"),
            category: "charts",
            icon: "\uE81E",
            description: qsTr("Scatter plot with trend line and point tooltips."),
            component: "ScatterChartPage",
            source: "pages/ScatterChartPage.qml"
        },
        {
            title: qsTr("WaterfallChart"),
            category: "charts",
            icon: "\uE9D9",
            description: qsTr("Cumulative step / bridge chart with total column."),
            component: "WaterfallChartPage",
            source: "pages/WaterfallChartPage.qml"
        },
        {
            title: qsTr("HeatmapChart"),
            category: "charts",
            icon: "\uE9F9",
            description: qsTr("Density heatmap with reveal and hover readout."),
            component: "HeatmapChartPage",
            source: "pages/HeatmapChartPage.qml"
        },
        {
            title: qsTr("RadarChart"),
            category: "charts",
            icon: "\uE909",
            description: qsTr("Spider / radar comparison chart."),
            component: "RadarChartPage",
            source: "pages/RadarChartPage.qml"
        },
        {
            title: qsTr("ChartCard"),
            category: "charts",
            icon: "\uE8A5",
            description: qsTr("Dashboard card chrome with entrance animation."),
            component: "ChartCardPage",
            source: "pages/ChartCardPage.qml"
        },
        {
            title: qsTr("BulletChart"),
            category: "charts",
            icon: "\uE9D9",
            description: qsTr("Compact KPI bullet with ranges, value, and target."),
            component: "BulletChartPage",
            source: "pages/BulletChartPage.qml"
        },
        {
            title: qsTr("Shimmer"),
            category: "status",
            icon: "\uE9CE",
            description: qsTr("Skeleton placeholders that shimmer while loading."),
            component: "ShimmerPage",
            source: "pages/ShimmerPage.qml"
        },
        {
            title: qsTr("EmptyState"),
            category: "status",
            icon: "\uE7BA",
            description: qsTr("Empty collection placeholder with optional action."),
            component: "EmptyStatePage",
            source: "pages/EmptyStatePage.qml"
        },
        {
            title: qsTr("CopyButton"),
            category: "buttons",
            icon: "\uE8C8",
            description: qsTr("Copies text to the clipboard with success feedback."),
            component: "CopyButtonPage",
            source: "pages/CopyButtonPage.qml"
        },
        {
            title: qsTr("AvatarGroup"),
            category: "collections",
            icon: "\uE716",
            description: qsTr("Overlapping person pictures with overflow count."),
            component: "AvatarGroupPage",
            source: "pages/AvatarGroupPage.qml"
        },
        {
            title: qsTr("ProgressButton"),
            category: "buttons",
            icon: "\uE9F9",
            description: qsTr("A button with embedded determinate or indeterminate progress."),
            component: "ProgressButtonPage",
            source: "pages/ProgressButtonPage.qml"
        },
        {
            title: qsTr("TwoPaneView"),
            category: "layout",
            icon: "\uE8A9",
            description: qsTr("Adaptive dual-pane layout with wide, tall, and single modes."),
            component: "TwoPaneViewPage",
            source: "pages/TwoPaneViewPage.qml"
        },
        {
            title: qsTr("Pivot"),
            category: "navigation",
            icon: "\uE8FD",
            description: qsTr("Headered multi-view with an accent underline indicator."),
            component: "PivotPage",
            source: "pages/PivotPage.qml"
        },
        {
            title: qsTr("MultiSelectComboBox"),
            category: "basic",
            icon: "\uE8A1",
            description: qsTr("Combo box that supports multiple checked selections."),
            component: "MultiSelectComboBoxPage",
            source: "pages/MultiSelectComboBoxPage.qml"
        },
        {
            title: qsTr("ColorPickerButton"),
            category: "basic",
            icon: "\uE790",
            description: qsTr("Color chip button that opens a ColorPicker flyout."),
            component: "ColorPickerButtonPage",
            source: "pages/ColorPickerButtonPage.qml"
        },
        {
            title: qsTr("AcrylicSurface"),
            category: "layout",
            icon: "\uE790",
            description: qsTr("Layered acrylic-like surface for grouping content."),
            component: "AcrylicSurfacePage",
            source: "pages/AcrylicSurfacePage.qml"
        },
        {
            title: qsTr("Timeline"),
            category: "collections",
            icon: "\uE81C",
            description: qsTr("Vertical timeline for chronological events."),
            component: "TimelinePage",
            source: "pages/TimelinePage.qml"
        },
        {
            title: qsTr("SwipeControl"),
            category: "collections",
            icon: "\uE76B",
            description: qsTr("Reveal leading or trailing actions by dragging content."),
            component: "SwipeControlPage",
            source: "pages/SwipeControlPage.qml"
        },
        {
            title: qsTr("KeyVisual"),
            category: "basic",
            icon: "\uE765",
            description: qsTr("Key chrome and KeyChordVisual shortcut parsing (not Qt Virtual Keyboard)."),
            component: "KeyVisualPage",
            source: "pages/KeyVisualPage.qml"
        },
        {
            title: qsTr("Misc Buttons"),
            category: "buttons",
            icon: "\uE90F",
            description: qsTr("ToolButton, RoundButton, DelayButton and other button variants."),
            component: "MiscButtonsPage",
            source: "pages/MiscButtonsPage.qml"
        },
        {
            title: qsTr("ListTile"),
            category: "collections",
            icon: "\uE8FD",
            description: qsTr("A list row with glyph, title, subtitle, and trailing content."),
            component: "ListTilePage",
            source: "pages/ListTilePage.qml"
        },
        {
            title: qsTr("Pitfalls"),
            category: "layout",
            icon: "\uE7BA",
            description: qsTr("Anti-patterns: square fills and clip that break rounded borders."),
            component: "PitfallsPage",
            source: "pages/PitfallsPage.qml"
        },
        {
            title: qsTr("GridTile"),
            category: "collections",
            icon: "\uE8A5",
            description: qsTr("A selectable grid card with glyph or image, title, and subtitle."),
            component: "GridTilePage",
            source: "pages/GridTilePage.qml"
        },
        {
            title: qsTr("HeaderedTextBox"),
            category: "text",
            icon: "\uE8D2",
            description: qsTr("A text field with a WinUI-style header and description."),
            component: "HeaderedTextBoxPage",
            source: "pages/HeaderedTextBoxPage.qml"
        },
        {
            title: qsTr("HeaderedComboBox"),
            category: "text",
            icon: "\uE70D",
            description: qsTr("Labeled ComboBox with FormLayout header placement."),
            component: "HeaderedComboBoxPage",
            source: "pages/HeaderedComboBoxPage.qml"
        },
        {
            title: qsTr("Form validation"),
            category: "text",
            icon: "\uE73E",
            description: qsTr("FormLayout labelWidth, left headers, ValidationSummary, RadioButtons."),
            component: "FormValidationPage",
            source: "pages/FormValidationPage.qml"
        },
        {
            title: qsTr("FileDropZone"),
            category: "layout",
            icon: "\uE8E5",
            description: qsTr("Drag-and-drop target with optional extension filter."),
            component: "FileDropZonePage",
            source: "pages/FileDropZonePage.qml"
        },
        {
            title: qsTr("MenuFlyout"),
            category: "menus",
            icon: "\uE700",
            description: qsTr("A command flyout menu anchored to a control."),
            component: "MenuFlyoutPage",
            source: "pages/MenuFlyoutPage.qml"
        },
        {
            title: qsTr("RefreshContainer"),
            category: "scrolling",
            icon: "\uE72C",
            description: qsTr("Pull down on scrollable content to request a refresh."),
            component: "RefreshContainerPage",
            source: "pages/RefreshContainerPage.qml"
        },
        {
            title: qsTr("TextBlock"),
            category: "text",
            icon: "\uE8D2",
            description: qsTr("Typography mapped to the WinUI type ramp."),
            component: "TextBlockPage",
            source: "pages/TextBlockPage.qml"
        },
        {
            title: qsTr("ActionCard"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("A clickable card with glyph, title, description, and chevron."),
            component: "ActionCardPage",
            source: "pages/ActionCardPage.qml"
        },
        {
            title: qsTr("InfoBarHost"),
            category: "status",
            icon: "\uE946",
            description: qsTr("Stacks InfoBar messages with shared layout spacing."),
            component: "InfoBarHostPage",
            source: "pages/InfoBarHostPage.qml"
        },
        {
            title: qsTr("ToastHost"),
            category: "status",
            icon: "\uE946",
            description: qsTr("Queues multiple toasts with a progress countdown."),
            component: "ToastHostPage",
            source: "pages/ToastHostPage.qml"
        },
        {
            title: qsTr("ChipGroup"),
            category: "buttons",
            icon: "\uE8FD",
            description: qsTr("A row of chips for exclusive or multi-select filters."),
            component: "ChipGroupPage",
            source: "pages/ChipGroupPage.qml"
        },
        {
            title: qsTr("StatusDot"),
            category: "status",
            icon: "\uEA3A",
            description: qsTr("Presence and health indicators with optional pulse."),
            component: "StatusDotPage",
            source: "pages/StatusDotPage.qml"
        },
        {
            title: qsTr("FontIcon"),
            category: "basic",
            icon: "\uE8A7",
            description: qsTr("A Fluent Icons glyph with theme-aware color and size."),
            component: "FontIconPage",
            source: "pages/FontIconPage.qml"
        },
        {
            title: qsTr("MetadataControl"),
            category: "text",
            icon: "\uE8D2",
            description: qsTr("Label and value pairs for detail and inspector surfaces."),
            component: "MetadataControlPage",
            source: "pages/MetadataControlPage.qml"
        },
        {
            title: qsTr("RelativePanel"),
            category: "layout",
            icon: "\uE8A5",
            description: qsTr("Positions children with sibling and panel alignment constraints."),
            component: "RelativePanelPage",
            source: "pages/RelativePanelPage.qml"
        },
        {
            title: qsTr("SwitchPresenter"),
            category: "layout",
            icon: "\uE8FD",
            description: qsTr("Shows one child case based on a matching value."),
            component: "SwitchPresenterPage",
            source: "pages/SwitchPresenterPage.qml"
        },
        {
            title: qsTr("MenuFlyoutItem"),
            category: "menus",
            icon: "\uE700",
            description: qsTr("Flyout menu rows with glyphs, toggles, radios, and headers."),
            component: "MenuFlyoutItemPage",
            source: "pages/MenuFlyoutItemPage.qml"
        }
    ]

    function controlsInCategory(key) {
        return controls.filter(function (c) { return c.category === key })
    }

    function findByComponent(name) {
        if (!name)
            return null
        for (var i = 0; i < controls.length; ++i) {
            if (controls[i].component === name)
                return controls[i]
        }
        return null
    }

    function recentlyAdded(count) {
        var n = Math.max(1, count || 8)
        var start = Math.max(0, controls.length - n)
        var out = []
        for (var i = controls.length - 1; i >= start; --i)
            out.push(controls[i])
        return out
    }

    function search(query) {
        var q = (query || "").trim().toLowerCase()
        if (!q.length)
            return []
        // Cap results for title-bar popup responsiveness.
        var limit = 24
        var out = []
        for (var i = 0; i < controls.length; ++i) {
            var c = controls[i]
            var title = (c.title || "").toLowerCase()
            if (title.indexOf(q) >= 0) {
                out.push(c)
            } else {
                var desc = (c.description || "").toLowerCase()
                var cat = (c.category || "").toLowerCase()
                if (desc.indexOf(q) >= 0 || cat.indexOf(q) >= 0)
                    out.push(c)
            }
            if (out.length >= limit)
                break
        }
        return out
    }
}
