pragma Singleton
import QtQuick
import QWinUI3.Theme

QtObject {
    id: root

    readonly property var categories: [
        { key: "buttons", title: qsTr("Buttons"), icon: FluentIcons.OpenInNewWindow },
        { key: "basic", title: qsTr("Basic input"), icon: FluentIcons.Checkbox },
        { key: "text", title: qsTr("Text"), icon: FluentIcons.Font },
        { key: "collections", title: qsTr("Collections"), icon: FluentIcons.List },
        { key: "menus", title: qsTr("Menus & toolbars"), icon: FluentIcons.More },
        { key: "navigation", title: qsTr("Navigation"), icon: FluentIcons.ChevronRight },
        { key: "layout", title: qsTr("Layout"), icon: FluentIcons.Document },
        { key: "scrolling", title: qsTr("Scrolling"), icon: FluentIcons.ScrollMode },
        { key: "date", title: qsTr("Date & time"), icon: FluentIcons.Calendar },
        { key: "dialogs", title: qsTr("Dialogs & flyouts"), icon: FluentIcons.Comment },
        { key: "status", title: qsTr("Status & info"), icon: FluentIcons.Info },
        { key: "charts", title: qsTr("Charts"), icon: FluentIcons.AreaChart }
    ]

    readonly property var controls: [
        {
            title: qsTr("Button"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A control that responds to user input and raises a Click event."),
            component: "ButtonPage",
            source: "pages/ButtonPage.qml"
        },
        {
            title: qsTr("CheckBox"),
            category: "basic",
            icon: FluentIcons.Checkbox,
            description: qsTr("A control that a user can select or clear."),
            component: "CheckBoxPage",
            source: "pages/CheckBoxPage.qml"
        },
        {
            title: qsTr("RadioButton"),
            category: "basic",
            icon: FluentIcons.RadioButton,
            description: qsTr("A control that allows a user to select a single option from a group."),
            component: "RadioButtonPage",
            source: "pages/RadioButtonPage.qml"
        },
        {
            title: qsTr("Slider"),
            category: "basic",
            icon: FluentIcons.Slider,
            description: qsTr("A control that lets the user select from a range of values by moving a thumb."),
            component: "SliderPage",
            source: "pages/SliderPage.qml"
        },
        {
            title: qsTr("RangeSlider"),
            category: "basic",
            icon: FluentIcons.Slider,
            description: qsTr("A slider with two thumbs for selecting a value range."),
            component: "RangeSliderPage",
            source: "pages/RangeSliderPage.qml"
        },
        {
            title: qsTr("Switch"),
            category: "basic",
            icon: FluentIcons.Toggle,
            description: qsTr("A binary on/off control that can be toggled."),
            component: "SwitchPage",
            source: "pages/SwitchPage.qml"
        },
        {
            title: qsTr("ComboBox"),
            category: "basic",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A drop-down list of selectable items."),
            component: "ComboBoxPage",
            source: "pages/ComboBoxPage.qml"
        },
        {
            title: qsTr("SpinBox"),
            category: "basic",
            icon: FluentIcons.Calculator,
            description: qsTr("A control for selecting a numeric value."),
            component: "SpinBoxPage",
            source: "pages/SpinBoxPage.qml"
        },
        {
            title: qsTr("Dial"),
            category: "basic",
            icon: FluentIcons.Slider,
            description: qsTr("A circular dial for selecting a value from a range."),
            component: "DialPage",
            source: "pages/DialPage.qml"
        },
        {
            title: qsTr("RatingControl"),
            category: "basic",
            icon: FluentIcons.Favorite,
            description: qsTr("A star rating control for collecting or displaying ratings."),
            component: "RatingControlPage",
            source: "pages/RatingControlPage.qml"
        },
        {
            title: qsTr("NumberBox"),
            category: "basic",
            icon: FluentIcons.Calculator,
            description: qsTr("Numeric spin + FormLayout (stable 1.37) — docs/pickers.md."),
            component: "NumberBoxPage",
            source: "pages/NumberBoxPage.qml"
        },
        {
            title: qsTr("SplitButton"),
            category: "buttons",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A primary action plus a flyout for related commands."),
            component: "SplitButtonPage",
            source: "pages/SplitButtonPage.qml"
        },
        {
            title: qsTr("ToggleButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A button that toggles between on and off states."),
            component: "ToggleButtonPage",
            source: "pages/ToggleButtonPage.qml"
        },
        {
            title: qsTr("ToggleSplitButton"),
            category: "buttons",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A checkable primary action with a related command flyout."),
            component: "ToggleSplitButtonPage",
            source: "pages/ToggleSplitButtonPage.qml"
        },
        {
            title: qsTr("SelectorBar"),
            category: "basic",
            icon: FluentIcons.Comment,
            description: qsTr("A compact segmented control for mutually exclusive options."),
            component: "SelectorBarPage",
            source: "pages/SelectorBarPage.qml"
        },
        {
            title: qsTr("RadioButtons"),
            category: "basic",
            icon: FluentIcons.RadioButton,
            description: qsTr("A labeled group of mutually exclusive radio options."),
            component: "RadioButtonsPage",
            source: "pages/RadioButtonsPage.qml"
        },
        {
            title: qsTr("ColorPicker"),
            category: "basic",
            icon: FluentIcons.Color,
            description: qsTr("A selectable color spectrum."),
            component: "ColorPickerPage",
            source: "pages/ColorPickerPage.qml"
        },
        {
            title: qsTr("AppBarButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("An icon-and-label command button for app bars and tool strips."),
            component: "AppBarButtonPage",
            source: "pages/AppBarButtonPage.qml"
        },
        {
            title: qsTr("AppBarToggleButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A checkable app-bar button that stays on until toggled off."),
            component: "AppBarToggleButtonPage",
            source: "pages/AppBarToggleButtonPage.qml"
        },
        {
            title: qsTr("Chip"),
            category: "buttons",
            icon: FluentIcons.List,
            description: qsTr("A compact selectable or closable tag."),
            component: "ChipPage",
            source: "pages/ChipPage.qml"
        },
        {
            title: qsTr("AccentButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A primary accent-colored button for the main call to action."),
            component: "AccentButtonPage",
            source: "pages/AccentButtonPage.qml"
        },
        {
            title: qsTr("IconButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A compact icon-only button for toolbars and dense UIs."),
            component: "IconButtonPage",
            source: "pages/IconButtonPage.qml"
        },
        {
            title: qsTr("IconicButton"),
            category: "buttons",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("Base icon + label button used by IconButton and AppBar*."),
            component: "IconicButtonPage",
            source: "pages/IconicButtonPage.qml"
        },
        {
            title: qsTr("TextField"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("A single-line text input control."),
            component: "TextFieldPage",
            source: "pages/TextFieldPage.qml"
        },
        {
            title: qsTr("TextArea"),
            category: "text",
            icon: FluentIcons.Document,
            description: qsTr("A multi-line text input control."),
            component: "TextAreaPage",
            source: "pages/TextAreaPage.qml"
        },
        {
            title: qsTr("PasswordBox"),
            category: "text",
            icon: FluentIcons.Lock,
            description: qsTr("A text field for passwords with a reveal button."),
            component: "PasswordBoxPage",
            source: "pages/PasswordBoxPage.qml"
        },
        {
            title: qsTr("AutoSuggestBox"),
            category: "text",
            icon: FluentIcons.Search,
            description: qsTr("A text field that suggests matching items as you type."),
            component: "AutoSuggestBoxPage",
            source: "pages/AutoSuggestBoxPage.qml"
        },
        {
            title: qsTr("SearchBox"),
            category: "text",
            icon: FluentIcons.Search,
            description: qsTr("A search field with clear button, without suggestion popup."),
            component: "SearchBoxPage",
            source: "pages/SearchBoxPage.qml"
        },
        {
            title: qsTr("TokenizingTextBox"),
            category: "text",
            icon: FluentIcons.Library,
            description: qsTr("A text box that converts typed text into tokens."),
            component: "TokenizingTextBoxPage",
            source: "pages/TokenizingTextBoxPage.qml"
        },
        {
            title: qsTr("Label"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("A text label for captions and descriptions."),
            component: "LabelPage",
            source: "pages/LabelPage.qml"
        },
        {
            title: qsTr("HyperlinkButton"),
            category: "buttons",
            icon: FluentIcons.Link,
            description: qsTr("A button that appears as a hyperlink."),
            component: "HyperlinkButtonPage",
            source: "pages/HyperlinkButtonPage.qml"
        },
        {
            title: qsTr("TabBar"),
            category: "navigation",
            icon: FluentIcons.Comment,
            description: qsTr("A horizontal set of tabs for switching views."),
            component: "TabBarPage",
            source: "pages/TabBarPage.qml"
        },
        {
            title: qsTr("PageIndicator"),
            category: "navigation",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Dots that show the current page in a multi-page view."),
            component: "PageIndicatorPage",
            source: "pages/PageIndicatorPage.qml"
        },
        {
            title: qsTr("SwipeView"),
            category: "navigation",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("A swipeable multi-page container."),
            component: "SwipeViewPage",
            source: "pages/SwipeViewPage.qml"
        },
        {
            title: qsTr("GroupBox"),
            category: "collections",
            icon: FluentIcons.List,
            description: qsTr("A container that groups related controls under a label."),
            component: "GroupBoxPage",
            source: "pages/GroupBoxPage.qml"
        },
        {
            title: qsTr("ScrollBar"),
            category: "scrolling",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("A control for scrolling content vertically or horizontally."),
            component: "ScrollBarPage",
            source: "pages/ScrollBarPage.qml"
        },
        {
            title: qsTr("AnnotatedScrollBar"),
            category: "scrolling",
            icon: FluentIcons.ScrollMode,
            description: qsTr("A scrollable region whose scrollbar shows a label while dragging."),
            component: "AnnotatedScrollBarPage",
            source: "pages/AnnotatedScrollBarPage.qml"
        },
        {
            title: qsTr("Delegates"),
            category: "collections",
            icon: FluentIcons.List,
            description: qsTr("Check, switch, and radio list delegates."),
            component: "DelegatesPage",
            source: "pages/DelegatesPage.qml"
        },
        {
            title: qsTr("Expander"),
            category: "collections",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A collapsible container for progressive disclosure."),
            component: "ExpanderPage",
            source: "pages/ExpanderPage.qml"
        },
        {
            title: qsTr("SwipeDelegate"),
            category: "collections",
            icon: FluentIcons.List,
            description: qsTr("A list delegate that reveals actions when swiped."),
            component: "SwipeDelegatePage",
            source: "pages/SwipeDelegatePage.qml"
        },
        {
            title: qsTr("TreeView"),
            category: "collections",
            icon: FluentIcons.PageList,
            description: qsTr("Fluent TreeViewDelegate basics — docs/tree-data.md (1.33)."),
            component: "TreeViewPage",
            source: "pages/TreeViewPage.qml"
        },
        {
            title: qsTr("TreeView recipe"),
            category: "collections",
            icon: FluentIcons.PageList,
            description: qsTr("Hierarchy LoB: selection, ←/→, MenuFlyout, ItemsView sections (1.33)."),
            component: "TreeViewRecipePage",
            source: "pages/TreeViewRecipePage.qml"
        },
        {
            title: qsTr("ItemsView"),
            category: "collections",
            icon: FluentIcons.ViewAll,
            description: qsTr("List recipe: sections, multi-select, context menu, empty state."),
            component: "ItemsViewPage",
            source: "pages/ItemsViewPage.qml"
        },
        {
            title: qsTr("ItemsRepeater"),
            category: "collections",
            icon: FluentIcons.List,
            description: qsTr("Virtualizing ListView wrapper (stable 1.37) — docs/performance.md."),
            component: "ItemsRepeaterPage",
            source: "pages/ItemsRepeaterPage.qml"
        },
        {
            title: qsTr("ListDetailsView"),
            category: "collections",
            icon: FluentIcons.ViewAll,
            description: qsTr("Master–detail on TwoPaneView — docs/adaptive-layout.md (1.42)."),
            component: "ListDetailsViewPage",
            source: "pages/ListDetailsViewPage.qml"
        },
        {
            title: qsTr("BreadcrumbBar"),
            category: "navigation",
            icon: FluentIcons.ChevronRight,
            description: qsTr("Shows the current path and lets users navigate ancestors."),
            component: "BreadcrumbBarPage",
            source: "pages/BreadcrumbBarPage.qml"
        },
        {
            title: qsTr("NavigationView"),
            category: "navigation",
            icon: FluentIcons.GlobalNavButton,
            description: qsTr("Pane modes, page cache LRU, initialPageTransition — docs/performance.md (1.39)."),
            component: "NavigationViewPage",
            source: "pages/NavigationViewPage.qml"
        },
        {
            title: qsTr("TitleBar"),
            category: "navigation",
            icon: FluentIcons.HalfStar,
            description: qsTr("WinUI TitleBar with Back, PaneToggle, Subtitle, Content, and RightHeader."),
            component: "TitleBarPage",
            source: "pages/TitleBarPage.qml"
        },
        {
            title: qsTr("Window shells"),
            category: "navigation",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("ShellWindow / Blank / Nav / MenuStatus (stable 1.37) — docs/window-shells.md."),
            component: "WindowParadigmPage",
            source: "pages/WindowParadigmPage.qml"
        },
        {
            title: qsTr("TableView"),
            category: "collections",
            icon: FluentIcons.ViewAll,
            description: qsTr("Tabular data with styled horizontal and vertical headers."),
            component: "TableViewPage",
            source: "pages/TableViewPage.qml"
        },
        {
            title: qsTr("DataTable"),
            category: "collections",
            icon: FluentIcons.ViewAll,
            description: qsTr("Fluent table with sort, filter, resize, keyboard, virtualization — docs/performance.md (1.25)."),
            component: "DataTablePage",
            source: "pages/DataTablePage.qml"
        },
        {
            title: qsTr("TabView"),
            category: "collections",
            icon: FluentIcons.Comment,
            description: qsTr("Document tabs (stable 1.37). Tear-out remains experimental — docs/navigation.md."),
            component: "TabViewPage",
            source: "pages/TabViewPage.qml"
        },
        {
            title: qsTr("FlipView"),
            category: "navigation",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("A swipeable page container with previous and next buttons."),
            component: "FlipViewPage",
            source: "pages/FlipViewPage.qml"
        },
        {
            title: qsTr("PipsPager"),
            category: "navigation",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Clickable page indicator dots for multi-page views."),
            component: "PipsPagerPage",
            source: "pages/PipsPagerPage.qml"
        },
        {
            title: qsTr("PagerControl"),
            category: "navigation",
            icon: FluentIcons.ChevronRight,
            description: qsTr("Numbered page navigation with previous and next."),
            component: "PagerControlPage",
            source: "pages/PagerControlPage.qml"
        },
        {
            title: qsTr("StepBar"),
            category: "navigation",
            icon: FluentIcons.List,
            description: qsTr("A horizontal step indicator for multi-step flows."),
            component: "StepBarPage",
            source: "pages/StepBarPage.qml"
        },
        {
            title: qsTr("Pane"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A styled content panel with padding and background."),
            component: "PanePage",
            source: "pages/PanePage.qml"
        },
        {
            title: qsTr("SplitView"),
            category: "layout",
            icon: FluentIcons.Publish,
            description: qsTr("A view with resizable panes separated by a splitter."),
            component: "SplitViewPage",
            source: "pages/SplitViewPage.qml"
        },
        {
            title: qsTr("Drawer"),
            category: "layout",
            icon: FluentIcons.GlobalNavButton,
            description: qsTr("Edge panel (stable 1.37) — docs/dialogs-flyouts.md."),
            component: "DrawerPage",
            source: "pages/DrawerPage.qml"
        },
        {
            title: qsTr("StackView"),
            category: "navigation",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("A stack-based navigation container with animated transitions."),
            component: "StackViewPage",
            source: "pages/StackViewPage.qml"
        },
        {
            title: qsTr("CommandBar"),
            category: "menus",
            icon: FluentIcons.More,
            description: qsTr("Page tool strip (stable 1.37) — docs/commands.md."),
            component: "CommandBarPage",
            source: "pages/CommandBarPage.qml"
        },
        {
            title: qsTr("CommandBarFlyout"),
            category: "menus",
            icon: FluentIcons.More,
            description: qsTr("A flyout that hosts a compact command bar with optional secondary actions."),
            component: "CommandBarFlyoutPage",
            source: "pages/CommandBarFlyoutPage.qml"
        },
        {
            title: qsTr("CommandPalette"),
            category: "menus",
            icon: FluentIcons.Search,
            description: qsTr("Ctrl+K launcher — docs/keyboard.md (1.44) · docs/commands.md."),
            component: "CommandPalettePage",
            source: "pages/CommandPalettePage.qml"
        },
        {
            title: qsTr("AppBarSeparator"),
            category: "menus",
            icon: FluentIcons.ChevronRight,
            description: qsTr("A thin divider for grouping commands in an app bar or command bar."),
            component: "AppBarSeparatorPage",
            source: "pages/AppBarSeparatorPage.qml"
        },
        {
            title: qsTr("ToolBar"),
            category: "menus",
            icon: FluentIcons.Repair,
            description: qsTr("A container for command buttons and related controls."),
            component: "ToolBarPage",
            source: "pages/ToolBarPage.qml"
        },
        {
            title: qsTr("MenuBar"),
            category: "menus",
            icon: FluentIcons.GlobalNavButton,
            description: qsTr("Classic window menu bar (stable 1.37) — docs/commands.md."),
            component: "MenuBarPage",
            source: "pages/MenuBarPage.qml"
        },
        {
            title: qsTr("SettingsCard"),
            category: "layout",
            icon: FluentIcons.Settings,
            description: qsTr("Settings row; toggle: true for a built-in Switch."),
            component: "SettingsCardPage",
            source: "pages/SettingsCardPage.qml"
        },
        {
            title: qsTr("Settings combo & slider"),
            category: "layout",
            icon: FluentIcons.ChevronDown,
            description: qsTr("SettingsComboCard and SettingsSliderCard conveniences."),
            component: "SettingsComboSliderPage",
            source: "pages/SettingsComboSliderPage.qml"
        },
        {
            title: qsTr("SettingsGroup"),
            category: "layout",
            icon: FluentIcons.List,
            description: qsTr("SettingsView + SettingsGroup; SettingsCard.toggle for Switch rows."),
            component: "SettingsGroupPage",
            source: "pages/SettingsGroupPage.qml"
        },
        {
            title: qsTr("StatusBar"),
            category: "layout",
            icon: FluentIcons.Street,
            description: qsTr("A bottom status strip with text, progress, and slots."),
            component: "StatusBarPage",
            source: "pages/StatusBarPage.qml"
        },
        {
            title: qsTr("SettingsExpander"),
            category: "layout",
            icon: FluentIcons.ChevronDown,
            description: qsTr("An expandable settings group with title and description."),
            component: "SettingsExpanderPage",
            source: "pages/SettingsExpanderPage.qml"
        },
        {
            title: qsTr("WrapPanel"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A panel that arranges child elements in wrapping rows or columns."),
            component: "WrapPanelPage",
            source: "pages/WrapPanelPage.qml"
        },
        {
            title: qsTr("HeaderedContentControl"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A content container with a header above the body."),
            component: "HeaderedContentControlPage",
            source: "pages/HeaderedContentControlPage.qml"
        },
        {
            title: qsTr("UniformGrid"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A grid that sizes all cells equally."),
            component: "UniformGridPage",
            source: "pages/UniformGridPage.qml"
        },
        {
            title: qsTr("DockPanel"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("Arranges children along edges with a center fill region."),
            component: "DockPanelPage",
            source: "pages/DockPanelPage.qml"
        },
        {
            title: qsTr("Frame"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A simple styled container with padding and a surface fill."),
            component: "FramePage",
            source: "pages/FramePage.qml"
        },
        {
            title: qsTr("ContentCard"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("An elevated card with optional title, subtitle, and body content."),
            component: "ContentCardPage",
            source: "pages/ContentCardPage.qml"
        },
        {
            title: qsTr("PersonPicture"),
            category: "layout",
            icon: FluentIcons.Contact,
            description: qsTr("Displays a person's avatar, initials, or silhouette."),
            component: "PersonPicturePage",
            source: "pages/PersonPicturePage.qml"
        },
        {
            title: qsTr("Calendar"),
            category: "date",
            icon: FluentIcons.Calendar,
            description: qsTr("MonthGrid and DayOfWeekRow for building calendar views."),
            component: "CalendarPage",
            source: "pages/CalendarPage.qml"
        },
        {
            title: qsTr("CalendarDatePicker"),
            category: "date",
            icon: FluentIcons.Calendar,
            description: qsTr("Calendar flyout + FormLayout errorMessage - docs/pickers.md (1.28)."),
            component: "CalendarDatePickerPage",
            source: "pages/CalendarDatePickerPage.qml"
        },
        {
            title: qsTr("DatePicker"),
            category: "date",
            icon: FluentIcons.Calendar,
            description: qsTr("Date tumblers + FormLayout errorMessage - docs/pickers.md (1.28)."),
            component: "DatePickerPage",
            source: "pages/DatePickerPage.qml"
        },
        {
            title: qsTr("Tumbler"),
            category: "date",
            icon: FluentIcons.History,
            description: qsTr("A spinning wheel for selecting values from a list."),
            component: "TumblerPage",
            source: "pages/TumblerPage.qml"
        },
        {
            title: qsTr("TimePicker"),
            category: "date",
            icon: FluentIcons.Clock,
            description: qsTr("Time tumblers + FormLayout errorMessage - docs/pickers.md (1.28)."),
            component: "TimePickerPage",
            source: "pages/TimePickerPage.qml"
        },
        {
            title: qsTr("Dialog"),
            category: "dialogs",
            icon: FluentIcons.Comment,
            description: qsTr("A modal dialog that prompts for user interaction."),
            component: "DialogPage",
            source: "pages/DialogPage.qml"
        },
        {
            title: qsTr("ContentDialog"),
            category: "dialogs",
            icon: FluentIcons.Comment,
            description: qsTr("A modal dialog with primary, secondary, and close actions."),
            component: "ContentDialogPage",
            source: "pages/ContentDialogPage.qml"
        },
        {
            title: qsTr("Dialogs & flyouts"),
            category: "dialogs",
            icon: FluentIcons.Comment,
            description: qsTr("Chooser: ContentDialog / Flyout / TeachingTip / Drawer (stable surfaces 1.37)."),
            component: "DialogsFlyoutsPage",
            source: "pages/DialogsFlyoutsPage.qml"
        },
        {
            title: qsTr("Flyout"),
            category: "dialogs",
            icon: FluentIcons.Lightbulb,
            description: qsTr("Light-dismiss popup (stable 1.37) — docs/dialogs-flyouts.md."),
            component: "FlyoutPage",
            source: "pages/FlyoutPage.qml"
        },
        {
            title: qsTr("TeachingTip"),
            category: "dialogs",
            icon: FluentIcons.Info,
            description: qsTr("Coach mark; focus returns to target — docs/feedback.md (1.34)."),
            component: "TeachingTipPage",
            source: "pages/TeachingTipPage.qml"
        },
        {
            title: qsTr("InfoButton"),
            category: "dialogs",
            icon: FluentIcons.Info,
            description: qsTr("Info glyph that opens a TeachingTip."),
            component: "InfoButtonPage",
            source: "pages/InfoButtonPage.qml"
        },
        {
            title: qsTr("ToolTip"),
            category: "dialogs",
            icon: FluentIcons.KnowledgeArticle,
            description: qsTr("A short tip shown when the user hovers a control."),
            component: "ToolTipPage",
            source: "pages/ToolTipPage.qml"
        },
        {
            title: qsTr("Menu"),
            category: "menus",
            icon: FluentIcons.GlobalNavButton,
            description: qsTr("A menu of commands and options."),
            component: "MenuPage",
            source: "pages/MenuPage.qml"
        },
        {
            title: qsTr("DropDownButton"),
            category: "buttons",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A button that opens a menu of commands."),
            component: "DropDownButtonPage",
            source: "pages/DropDownButtonPage.qml"
        },
        {
            title: qsTr("ProgressBar"),
            category: "status",
            icon: FluentIcons.PieSingle,
            description: qsTr("In-place progress — docs/feedback.md (1.34)."),
            component: "ProgressBarPage",
            source: "pages/ProgressBarPage.qml"
        },
        {
            title: qsTr("ProgressRing"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("In-place progress ring (stable 1.37) — docs/feedback.md."),
            component: "ProgressRingPage",
            source: "pages/ProgressRingPage.qml"
        },
        {
            title: qsTr("RadialGauge"),
            category: "status",
            icon: FluentIcons.Slider,
            description: qsTr("Toolkit-style radial needle gauge (MinAngle, TickSpacing, ScaleWidth)."),
            component: "RadialGaugePage",
            source: "pages/RadialGaugePage.qml"
        },
        {
            title: qsTr("LinearGauge"),
            category: "status",
            icon: FluentIcons.PieSingle,
            description: qsTr("A horizontal or vertical linear gauge with thumb and thresholds."),
            component: "LinearGaugePage",
            source: "pages/LinearGaugePage.qml"
        },
        {
            title: qsTr("ArcGauge"),
            category: "status",
            icon: FluentIcons.Slider,
            description: qsTr("A semicircle dashboard gauge with a large center value."),
            component: "ArcGaugePage",
            source: "pages/ArcGaugePage.qml"
        },
        {
            title: qsTr("SegmentedGauge"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("A ring divided into discrete segments for steps or quota."),
            component: "SegmentedGaugePage",
            source: "pages/SegmentedGaugePage.qml"
        },
        {
            title: qsTr("ZoneGauge"),
            category: "status",
            icon: FluentIcons.Slider,
            description: qsTr("A needle gauge with colored zone bands (Toolkit-style)."),
            component: "ZoneGaugePage",
            source: "pages/ZoneGaugePage.qml"
        },
        {
            title: qsTr("RingGauge"),
            category: "status",
            icon: FluentIcons.Slider,
            description: qsTr("A closed-ring KPI gauge with a large center value."),
            component: "RingGaugePage",
            source: "pages/RingGaugePage.qml"
        },
        {
            title: qsTr("TankGauge"),
            category: "status",
            icon: FluentIcons.PieSingle,
            description: qsTr("A vertical tank / reservoir level gauge."),
            component: "TankGaugePage",
            source: "pages/TankGaugePage.qml"
        },
        {
            title: qsTr("ThermometerGauge"),
            category: "status",
            icon: FluentIcons.AreaChart,
            description: qsTr("A classic stem-and-bulb thermometer gauge."),
            component: "ThermometerGaugePage",
            source: "pages/ThermometerGaugePage.qml"
        },
        {
            title: qsTr("KpiTile"),
            category: "status",
            icon: FluentIcons.AreaChart,
            description: qsTr("A compact KPI tile with delta and optional sparkline."),
            component: "KpiTilePage",
            source: "pages/KpiTilePage.qml"
        },
        {
            title: qsTr("Dashboard"),
            category: "status",
            icon: FluentIcons.Home,
            description: qsTr("Composite monitoring layout with gauges, KPIs, and charts."),
            component: "DashboardPage",
            source: "pages/DashboardPage.qml"
        },
        {
            title: qsTr("BusyIndicator"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("An indeterminate progress indicator."),
            component: "BusyIndicatorPage",
            source: "pages/BusyIndicatorPage.qml"
        },
        {
            title: qsTr("InfoBar"),
            category: "status",
            icon: FluentIcons.Info,
            description: qsTr("Inline severity banner — docs/feedback.md (1.34)."),
            component: "InfoBarPage",
            source: "pages/InfoBarPage.qml"
        },
        {
            title: qsTr("InfoBadge"),
            category: "status",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Counts / status dots (stable 1.37)."),
            component: "InfoBadgePage",
            source: "pages/InfoBadgePage.qml"
        },
        {
            title: qsTr("Toast"),
            category: "status",
            icon: FluentIcons.Info,
            description: qsTr("Window-overlay toast with placement picker and pending queue."),
            component: "ToastPage",
            source: "pages/ToastPage.qml"
        },
        {
            title: qsTr("System integration"),
            category: "dialogs",
            icon: FluentIcons.Folder,
            description: qsTr("Snap Layouts · taskbar · attention — docs/shell-extras.md (1.47)."),
            component: "SystemIntegrationPage",
            source: "pages/SystemIntegrationPage.qml"
        },
        {
            title: qsTr("MediaPlayerElement"),
            category: "status",
            icon: FluentIcons.Video,
            description: qsTr("Optional Qt Multimedia shell — docs/media.md (1.21)."),
            component: "MediaPlayerElementPage",
            source: "pages/MediaPlayerElementPage.qml"
        },
        {
            title: qsTr("SegmentedControl"),
            category: "basic",
            icon: FluentIcons.List,
            description: qsTr("A mutually exclusive segmented option bar."),
            component: "SegmentedControlPage",
            source: "pages/SegmentedControlPage.qml"
        },
        {
            title: qsTr("StackPanel"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("Stacks children horizontally or vertically with spacing."),
            component: "StackPanelPage",
            source: "pages/StackPanelPage.qml"
        },
        {
            title: qsTr("MeterBar"),
            category: "status",
            icon: FluentIcons.PieSingle,
            description: qsTr("A multi-segment meter for stacked values."),
            component: "MeterBarPage",
            source: "pages/MeterBarPage.qml"
        },
        {
            title: qsTr("Charts"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Stable chart subset (1.23) — Line/Bar/Donut + RingGauge + KpiTile + ChartCard."),
            component: "ChartsPage",
            source: "pages/ChartsPage.qml"
        },
        {
            title: qsTr("Sparkline"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Compact inline trend glyph for dense data."),
            component: "SparklinePage",
            source: "pages/SparklinePage.qml"
        },
        {
            title: qsTr("LineChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Multi-series line and area chart."),
            component: "LineChartPage",
            source: "pages/LineChartPage.qml"
        },
        {
            title: qsTr("AreaChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Filled area chart with optional stacking."),
            component: "AreaChartPage",
            source: "pages/AreaChartPage.qml"
        },
        {
            title: qsTr("BarChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Vertical column chart in a single Canvas pass."),
            component: "BarChartPage",
            source: "pages/BarChartPage.qml"
        },
        {
            title: qsTr("HorizontalBarChart"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Horizontal bars for rankings and comparisons."),
            component: "HorizontalBarChartPage",
            source: "pages/HorizontalBarChartPage.qml"
        },
        {
            title: qsTr("StackedBarChart"),
            category: "charts",
            icon: FluentIcons.DialShape3,
            description: qsTr("Stacked columns for category composition."),
            component: "StackedBarChartPage",
            source: "pages/StackedBarChartPage.qml"
        },
        {
            title: qsTr("DonutChart"),
            category: "charts",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Part-to-whole donut with legend and center label."),
            component: "DonutChartPage",
            source: "pages/DonutChartPage.qml"
        },
        {
            title: qsTr("PieChart"),
            category: "charts",
            icon: FluentIcons.DonutChart,
            description: qsTr("Solid pie chart with Fluent color tokens."),
            component: "PieChartPage",
            source: "pages/PieChartPage.qml"
        },
        {
            title: qsTr("ScatterChart"),
            category: "charts",
            icon: FluentIcons.BarChartVertical,
            description: qsTr("Scatter plot with trend line and point tooltips."),
            component: "ScatterChartPage",
            source: "pages/ScatterChartPage.qml"
        },
        {
            title: qsTr("WaterfallChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Cumulative step / bridge chart with total column."),
            component: "WaterfallChartPage",
            source: "pages/WaterfallChartPage.qml"
        },
        {
            title: qsTr("HeatmapChart"),
            category: "charts",
            icon: FluentIcons.AreaChartMirrored,
            description: qsTr("Density heatmap with reveal and hover readout."),
            component: "HeatmapChartPage",
            source: "pages/HeatmapChartPage.qml"
        },
        {
            title: qsTr("RadarChart"),
            category: "charts",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Spider / radar comparison chart."),
            component: "RadarChartPage",
            source: "pages/RadarChartPage.qml"
        },
        {
            title: qsTr("ChartCard"),
            category: "charts",
            icon: FluentIcons.Document,
            description: qsTr("Dashboard card chrome with entrance animation."),
            component: "ChartCardPage",
            source: "pages/ChartCardPage.qml"
        },
        {
            title: qsTr("BulletChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Compact KPI bullet with ranges, value, and target."),
            component: "BulletChartPage",
            source: "pages/BulletChartPage.qml"
        },
        {
            title: qsTr("Shimmer"),
            category: "status",
            icon: FluentIcons.Toggle,
            description: qsTr("Skeleton placeholders that shimmer while loading."),
            component: "ShimmerPage",
            source: "pages/ShimmerPage.qml"
        },
        {
            title: qsTr("EmptyState"),
            category: "status",
            icon: FluentIcons.Warning,
            description: qsTr("Empty collection placeholder with optional action."),
            component: "EmptyStatePage",
            source: "pages/EmptyStatePage.qml"
        },
        {
            title: qsTr("Animations"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("Motion recipe hub (1.22) — ConnectedAnimation, entrance, theme transitions."),
            component: "AnimationsPage",
            source: "pages/AnimationsPage.qml"
        },
        {
            title: qsTr("EntranceThemeTransition"),
            category: "status",
            icon: FluentIcons.Completed,
            description: qsTr("Fade + rise + scale entrance — docs/animations.md (1.22)."),
            component: "EntranceThemeTransitionPage",
            source: "pages/EntranceThemeTransitionPage.qml"
        },
        {
            title: qsTr("Theme transitions"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("ContentThemeTransition + RepositionThemeTransition — docs/animations.md (1.22)."),
            component: "ThemeTransitionsPage",
            source: "pages/ThemeTransitionsPage.qml"
        },
        {
            title: qsTr("Theme overrides"),
            category: "status",
            icon: FluentIcons.Color,
            description: qsTr("Brand + contrast AA table — docs/color-contrast.md (1.43)."),
            component: "ThemeOverridesPage",
            source: "pages/ThemeOverridesPage.qml"
        },
        {
            title: qsTr("ConnectedAnimation"),
            category: "status",
            icon: FluentIcons.Sync,
            description: qsTr("Shared-element list→detail — docs/animations.md (1.22)."),
            component: "ConnectedAnimationPage",
            source: "pages/ConnectedAnimationPage.qml"
        },
        {
            title: qsTr("CopyButton"),
            category: "buttons",
            icon: FluentIcons.Copy,
            description: qsTr("Copies text to the clipboard with success feedback — docs/drag-drop.md (1.41)."),
            component: "CopyButtonPage",
            source: "pages/CopyButtonPage.qml"
        },
        {
            title: qsTr("AvatarGroup"),
            category: "collections",
            icon: FluentIcons.People,
            description: qsTr("Overlapping person pictures with overflow count."),
            component: "AvatarGroupPage",
            source: "pages/AvatarGroupPage.qml"
        },
        {
            title: qsTr("ProgressButton"),
            category: "buttons",
            icon: FluentIcons.AreaChartMirrored,
            description: qsTr("Button with embedded progress (stable 1.37) — docs/feedback.md."),
            component: "ProgressButtonPage",
            source: "pages/ProgressButtonPage.qml"
        },
        {
            title: qsTr("TwoPaneView"),
            category: "layout",
            icon: FluentIcons.ViewAll,
            description: qsTr("Wide / Tall / SinglePane breakpoints — docs/adaptive-layout.md (1.42)."),
            component: "TwoPaneViewPage",
            source: "pages/TwoPaneViewPage.qml"
        },
        {
            title: qsTr("Pivot"),
            category: "navigation",
            icon: FluentIcons.List,
            description: qsTr("Headered multi-view with an accent underline indicator."),
            component: "PivotPage",
            source: "pages/PivotPage.qml"
        },
        {
            title: qsTr("MultiSelectComboBox"),
            category: "basic",
            icon: FluentIcons.Comment,
            description: qsTr("Combo box that supports multiple checked selections."),
            component: "MultiSelectComboBoxPage",
            source: "pages/MultiSelectComboBoxPage.qml"
        },
        {
            title: qsTr("ColorPickerButton"),
            category: "basic",
            icon: FluentIcons.Color,
            description: qsTr("Color chip button that opens a ColorPicker flyout."),
            component: "ColorPickerButtonPage",
            source: "pages/ColorPickerButtonPage.qml"
        },
        {
            title: qsTr("AcrylicSurface"),
            category: "layout",
            icon: FluentIcons.Color,
            description: qsTr("Layered acrylic-like surface for grouping content."),
            component: "AcrylicSurfacePage",
            source: "pages/AcrylicSurfacePage.qml"
        },
        {
            title: qsTr("Timeline"),
            category: "collections",
            icon: FluentIcons.History,
            description: qsTr("Vertical timeline for chronological events."),
            component: "TimelinePage",
            source: "pages/TimelinePage.qml"
        },
        {
            title: qsTr("SwipeControl"),
            category: "collections",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("Reveal leading or trailing actions by dragging content."),
            component: "SwipeControlPage",
            source: "pages/SwipeControlPage.qml"
        },
        {
            title: qsTr("KeyVisual"),
            category: "basic",
            icon: FluentIcons.Presence,
            description: qsTr("Key chrome and KeyChordVisual shortcut parsing (not Qt Virtual Keyboard)."),
            component: "KeyVisualPage",
            source: "pages/KeyVisualPage.qml"
        },
        {
            title: qsTr("Misc Buttons"),
            category: "buttons",
            icon: FluentIcons.Repair,
            description: qsTr("ToolButton, RoundButton, DelayButton and other button variants."),
            component: "MiscButtonsPage",
            source: "pages/MiscButtonsPage.qml"
        },
        {
            title: qsTr("ListTile"),
            category: "collections",
            icon: FluentIcons.List,
            description: qsTr("A list row with glyph, title, subtitle, and trailing content."),
            component: "ListTilePage",
            source: "pages/ListTilePage.qml"
        },
        {
            title: qsTr("Pitfalls"),
            category: "layout",
            icon: FluentIcons.Warning,
            description: qsTr("Anti-patterns + 1.xx compatibility freeze gate (1.40) — docs/compatibility-1xx.md."),
            component: "PitfallsPage",
            source: "pages/PitfallsPage.qml"
        },
        {
            title: qsTr("Accessibility"),
            category: "layout",
            icon: FluentIcons.EaseOfAccess,
            description: qsTr("A11y + keyboard-first tour — docs/keyboard.md (1.44)."),
            component: "AccessibilityPage",
            source: "pages/AccessibilityPage.qml"
        },
        {
            title: qsTr("i18n / RTL"),
            category: "layout",
            icon: FluentIcons.Globe,
            description: qsTr("qsTr + zh_CN seed + RTL — docs/i18n-rtl.md (1.45)."),
            component: "I18nRtlPage",
            source: "pages/I18nRtlPage.qml"
        },
        {
            title: qsTr("GridTile"),
            category: "collections",
            icon: FluentIcons.Document,
            description: qsTr("A selectable grid card with glyph or image, title, and subtitle."),
            component: "GridTilePage",
            source: "pages/GridTilePage.qml"
        },
        {
            title: qsTr("HeaderedTextBox"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("A text field with a WinUI-style header and description."),
            component: "HeaderedTextBoxPage",
            source: "pages/HeaderedTextBoxPage.qml"
        },
        {
            title: qsTr("HeaderedComboBox"),
            category: "text",
            icon: FluentIcons.ChevronDown,
            description: qsTr("Labeled ComboBox with FormLayout header placement."),
            component: "HeaderedComboBoxPage",
            source: "pages/HeaderedComboBoxPage.qml"
        },
        {
            title: qsTr("Form validation"),
            category: "text",
            icon: FluentIcons.Accept,
            description: qsTr("FormLayout + ValidationSummary + date pickers - docs/pickers.md (1.28)."),
            component: "FormValidationPage",
            source: "pages/FormValidationPage.qml"
        },
        {
            title: qsTr("FileDropZone"),
            category: "layout",
            icon: FluentIcons.OpenFile,
            description: qsTr("Drop + Browse + clipboard — docs/drag-drop.md (1.41)."),
            component: "FileDropZonePage",
            source: "pages/FileDropZonePage.qml"
        },
        {
            title: qsTr("MenuFlyout"),
            category: "menus",
            icon: FluentIcons.GlobalNavButton,
            description: qsTr("Context / overflow menu (stable 1.37) — docs/commands.md."),
            component: "MenuFlyoutPage",
            source: "pages/MenuFlyoutPage.qml"
        },
        {
            title: qsTr("RefreshContainer"),
            category: "scrolling",
            icon: FluentIcons.Refresh,
            description: qsTr("Pull down on scrollable content to request a refresh."),
            component: "RefreshContainerPage",
            source: "pages/RefreshContainerPage.qml"
        },
        {
            title: qsTr("TextBlock"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("Typography mapped to the WinUI type ramp."),
            component: "TextBlockPage",
            source: "pages/TextBlockPage.qml"
        },
        {
            title: qsTr("ActionCard"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("A clickable card with glyph, title, description, and chevron."),
            component: "ActionCardPage",
            source: "pages/ActionCardPage.qml"
        },
        {
            title: qsTr("InfoBarHost"),
            category: "status",
            icon: FluentIcons.Info,
            description: qsTr("maxVisible InfoBar stack — docs/feedback.md (1.34)."),
            component: "InfoBarHostPage",
            source: "pages/InfoBarHostPage.qml"
        },
        {
            title: qsTr("InfoBar + TeachingTip recipe"),
            category: "dialogs",
            icon: FluentIcons.Lightbulb,
            description: qsTr("Form save + coach tip end-to-end — docs/feedback.md (1.34)."),
            component: "InfoTeachingRecipePage",
            source: "pages/InfoTeachingRecipePage.qml"
        },
        {
            title: qsTr("WebView2"),
            category: "dialogs",
            icon: FluentIcons.Globe,
            description: qsTr("Stable Edge WebView2 host (1.18) — Runtime / clip / focus recipe."),
            component: "WebView2Page",
            source: "pages/WebView2Page.qml"
        },
        {
            title: qsTr("ToastHost"),
            category: "status",
            icon: FluentIcons.Info,
            description: qsTr("Pending toast queue — docs/feedback.md (1.34)."),
            component: "ToastHostPage",
            source: "pages/ToastHostPage.qml"
        },
        {
            title: qsTr("NotificationBridge"),
            category: "status",
            icon: FluentIcons.Notification,
            description: qsTr("Mirror ToastHost to Windows balloons or Linux portal notifications."),
            component: "NotificationBridgePage",
            source: "pages/NotificationBridgePage.qml"
        },
        {
            title: qsTr("ChipGroup"),
            category: "buttons",
            icon: FluentIcons.List,
            description: qsTr("A row of chips for exclusive or multi-select filters."),
            component: "ChipGroupPage",
            source: "pages/ChipGroupPage.qml"
        },
        {
            title: qsTr("StatusDot"),
            category: "status",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Presence and health indicators with optional pulse."),
            component: "StatusDotPage",
            source: "pages/StatusDotPage.qml"
        },
        {
            title: qsTr("Iconography"),
            category: "basic",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("FluentIcons + FontIcon (stable 1.37) — docs/icons.md."),
            component: "FontIconPage",
            source: "pages/FontIconPage.qml"
        },
        {
            title: qsTr("MetadataControl"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("Label and value pairs for detail and inspector surfaces."),
            component: "MetadataControlPage",
            source: "pages/MetadataControlPage.qml"
        },
        {
            title: qsTr("RelativePanel"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("Positions children with sibling and panel alignment constraints."),
            component: "RelativePanelPage",
            source: "pages/RelativePanelPage.qml"
        },
        {
            title: qsTr("SwitchPresenter"),
            category: "layout",
            icon: FluentIcons.List,
            description: qsTr("Shows one child case based on a matching value."),
            component: "SwitchPresenterPage",
            source: "pages/SwitchPresenterPage.qml"
        },
        {
            title: qsTr("MenuFlyoutItem"),
            category: "menus",
            icon: FluentIcons.GlobalNavButton,
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

    // Curated “recently shipped” recipe pages (1.20) — not catalog array order.
    function recentlyShipped(count) {
        var ids = [
            "SystemIntegrationPage",  // 1.47 Snap / shell extras
            "I18nRtlPage",            // 1.45 locale packs
            "AccessibilityPage",      // 1.44 keyboard tour
            "CommandPalettePage",     // 1.44 / 1.37
            "ThemeOverridesPage",     // 1.43 contrast AA
            "TwoPaneViewPage",        // 1.42 adaptive layout
            "ListDetailsViewPage",    // 1.42 breakpoints
            "FileDropZonePage",       // 1.41 drag-drop recipe
            "CopyButtonPage",         // 1.41 clipboard
            "PitfallsPage",           // 1.40 compatibility freeze
            "NavigationViewPage",     // 1.39 page cache / cold start
            "HomePage",               // 1.39 deferred card effects
            "DialogsFlyoutsPage",     // 1.37 promote
            "TabViewPage",            // 1.37 promote
            "WindowParadigmPage",     // 1.37 ShellWindow family
            "ChartsPage",             // 1.23
            "AnimationsPage",         // 1.22 experimental
            "WebView2Page",           // 1.18
            "DataTablePage"           // 1.07
        ]
        var n = Math.max(1, count || 9)
        var out = []
        for (var i = 0; i < ids.length && out.length < n; ++i) {
            var item = findByComponent(ids[i])
            if (item)
                out.push(item)
        }
        return out
    }

    // Critical pages for Gallery smoke page-load (keep in sync with docs/ci-smoke.md).
    function smokeCriticalComponents() {
        return [
            "HomePage",
            "ButtonPage",
            "ContentDialogPage",
            "DataTablePage",
            "FormValidationPage",
            "CommandPalettePage",
            "AccessibilityPage",
            "SystemIntegrationPage",
            "WebView2Page",
            "ChartsPage",
            "DialogsFlyoutsPage",
            "AnimationsPage",
            "I18nRtlPage"
        ]
    }

    // Heavy Gallery pages — defer until opened; prefer Loader inside the page (1.39).
    function heavyComponents() {
        return [
            "DataTablePage",
            "ChartsPage",
            "FontIconPage",
            "WebView2Page",
            "MediaPlayerElementPage",
            "HeatmapChartPage",
            "ScatterChartPage"
        ]
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
            var comp = (c.component || "").toLowerCase()
            var compShort = comp.replace(/page$/, "")
            if (title.indexOf(q) >= 0 || comp.indexOf(q) >= 0 || compShort.indexOf(q) >= 0) {
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
