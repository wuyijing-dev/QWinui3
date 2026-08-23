pragma Singleton
import QtQuick
import QWinUI3.Theme

QtObject {
    id: root

    // 10 pane groups. Rail uses hub pages with inline demos (hubEmbed); search finds all siblings.
    // Locale dependency so qsTr titles refresh with GalleryLanguage + engine.retranslate().
    readonly property var categories: {
        GalleryLanguage.currentLocale
        return [
        { key: "basic", title: qsTr("Basic input"), icon: FluentIcons.Checkbox },
        { key: "text", title: qsTr("Text"), icon: FluentIcons.Font },
        { key: "collections", title: qsTr("Collections"), icon: FluentIcons.List },
        { key: "date", title: qsTr("Date & time"), icon: FluentIcons.Calendar },
        { key: "dialogs", title: qsTr("Dialogs & flyouts"), icon: FluentIcons.Comment },
        { key: "layout", title: qsTr("Layout"), icon: FluentIcons.Document },
        { key: "menus", title: qsTr("Menus & toolbars"), icon: FluentIcons.More },
        { key: "navigation", title: qsTr("Navigation"), icon: FluentIcons.ChevronRight },
        { key: "status", title: qsTr("Status & info"), icon: FluentIcons.Info },
        { key: "charts", title: qsTr("Charts"), icon: FluentIcons.AreaChart }
        ]
    }

    readonly property var controls: {
        GalleryLanguage.currentLocale
        return [
        {
            title: qsTr("Button"),
            category: "basic",
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
            category: "basic",
            icon: FluentIcons.ChevronDown,
            description: qsTr("A primary action plus a flyout for related commands."),
            component: "SplitButtonPage",
            source: "pages/SplitButtonPage.qml"
        },
        {
            title: qsTr("ToggleButton"),
            category: "basic",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A button that toggles between on and off states."),
            component: "ToggleButtonPage",
            source: "pages/ToggleButtonPage.qml"
        },
        {
            title: qsTr("ToggleSplitButton"),
            category: "basic",
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
            category: "menus",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("An icon-and-label command button for app bars and tool strips."),
            component: "AppBarButtonPage",
            source: "pages/AppBarButtonPage.qml"
        },
        {
            title: qsTr("AppBarToggleButton"),
            category: "menus",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A checkable app-bar button that stays on until toggled off."),
            component: "AppBarToggleButtonPage",
            source: "pages/AppBarToggleButtonPage.qml"
        },
        {
            title: qsTr("Chip"),
            category: "basic",
            icon: FluentIcons.List,
            description: qsTr("A compact selectable or closable tag."),
            component: "ChipPage",
            source: "pages/ChipPage.qml"
        },
        {
            title: qsTr("AccentButton"),
            category: "basic",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("A primary accent-colored button for the main call to action."),
            component: "AccentButtonPage",
            source: "pages/AccentButtonPage.qml"
        },
        {
            title: qsTr("IconButton"),
            category: "basic",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("Icon-only button with glyph micro-motion (1.49) — docs/icons.md."),
            component: "IconButtonPage",
            source: "pages/IconButtonPage.qml"
        },
        {
            title: qsTr("IconicButton"),
            category: "basic",
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
            title: qsTr("MaskedTextField"),
            category: "text",
            icon: FluentIcons.ContactInfo,
            description: qsTr("Simple digit/letter input masks for phone and ID patterns (2.71)."),
            component: "MaskedTextFieldPage",
            source: "pages/MaskedTextFieldPage.qml"
        },
        {
            title: qsTr("PermissionGate"),
            category: "status",
            icon: FluentIcons.Shield,
            description: qsTr("Declarative hide/disable by role (2.71)."),
            component: "PermissionGatePage",
            source: "pages/PermissionGatePage.qml"
        },
        {
            title: qsTr("AutoSuggestBox"),
            category: "text",
            icon: FluentIcons.Search,
            description: qsTr("Suggest-as-you-type — docs/search.md (1.59)."),
            component: "AutoSuggestBoxPage",
            source: "pages/AutoSuggestBoxPage.qml"
        },
        {
            title: qsTr("SearchBox"),
            category: "text",
            icon: FluentIcons.Search,
            description: qsTr("Search field + suggestions — docs/search.md (1.59)."),
            component: "SearchBoxPage",
            source: "pages/SearchBoxPage.qml"
        },
        {
            title: qsTr("RichEdit"),
            category: "text",
            icon: FluentIcons.Edit,
            description: qsTr("Rich text for mail and templates — experimental, docs/rich-edit-261.md (2.61)."),
            component: "RichEditPage",
            source: "pages/RichEditPage.qml"
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
            title: qsTr("On-screen keyboard"),
            category: "text",
            icon: FluentIcons.Font,
            description: qsTr("Win11 floating OSK + Windows system-wide — docs/on-screen-keyboard.md (1.84). Still experimental."),
            component: "OnScreenKeyboardPage",
            source: "pages/OnScreenKeyboardPage.qml"
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
            category: "basic",
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
            category: "layout",
            icon: FluentIcons.ChevronLeft,
            description: qsTr("A control for scrolling content vertically or horizontally."),
            component: "ScrollBarPage",
            source: "pages/ScrollBarPage.qml"
        },
        {
            title: qsTr("AnnotatedScrollBar"),
            category: "layout",
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
            title: qsTr("FileTree"),
            category: "collections",
            icon: FluentIcons.FolderOpen,
            description: qsTr("Explorer tree + file metadata table — docs/tree-data.md (2.06, experimental)."),
            component: "FileTreePage",
            source: "pages/FileTreePage.qml"
        },
        {
            title: qsTr("TreeDataGrid"),
            category: "collections",
            icon: FluentIcons.PageList,
            description: qsTr("Hierarchical multi-column grid — sort/filter per branch — docs/tree-data.md (2.21, experimental)."),
            component: "TreeDataGridPage",
            source: "pages/TreeDataGridPage.qml"
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
            title: qsTr("High-DPI & monitors"),
            category: "navigation",
            icon: FluentIcons.FullScreen,
            description: qsTr("DPR readout · geometry clamp — docs/high-dpi.md (1.58)."),
            component: "HighDpiPage",
            source: "pages/HighDpiPage.qml"
        },
        {
            title: qsTr("Multi-window"),
            category: "navigation",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("Main + tool + owned dialog — docs/window-shells.md (1.56)."),
            component: "MultiWindowPage",
            source: "pages/MultiWindowPage.qml"
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
            title: qsTr("Wizard"),
            category: "navigation",
            icon: FluentIcons.List,
            description: qsTr("Multi-step host with validation gates and Back/Next (2.68)."),
            component: "WizardPage",
            source: "pages/WizardPage.qml"
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
            title: qsTr("Settings patterns"),
            category: "layout",
            icon: FluentIcons.Settings,
            description: qsTr("SettingsView building blocks — SettingsGroup / SettingsCard / expander."),
            component: "SettingsHubPage",
            source: "pages/SettingsHubPage.qml"
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
            category: "status",
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
            title: qsTr("Panels & grids"),
            category: "layout",
            icon: FluentIcons.GridView,
            description: qsTr("WrapPanel · UniformGrid · DockPanel · RelativePanel · StackPanel."),
            component: "PanelsHubPage",
            source: "pages/PanelsHubPage.qml"
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
            title: qsTr("SemanticZoom"),
            category: "collections",
            icon: FluentIcons.People,
            description: qsTr("Grid ↔ index with shared selection — experimental, docs/semantic-zoom-262.md (2.62)."),
            component: "SemanticZoomPage",
            source: "pages/SemanticZoomPage.qml"
        },
        {
            title: qsTr("ItemsWrapGrid"),
            category: "layout",
            icon: FluentIcons.Document,
            description: qsTr("Model-driven wrap grid with variable item sizes."),
            component: "ItemsWrapGridPage",
            source: "pages/ItemsWrapGridPage.qml"
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
            category: "collections",
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
            title: qsTr("CalendarView"),
            category: "date",
            icon: FluentIcons.Calendar,
            description: qsTr("Month grid — single / multiple / range selection. Experimental — docs/calendar-view.md (2.31)."),
            component: "CalendarViewPage",
            source: "pages/CalendarViewPage.qml"
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
            description: qsTr("Modal queue A→B→C · Esc/Closing — docs/dialogs-flyouts.md (1.48)."),
            component: "ContentDialogPage",
            source: "pages/ContentDialogPage.qml"
        },
        {
            title: qsTr("Dialogs & flyouts"),
            category: "dialogs",
            icon: FluentIcons.Comment,
            description: qsTr("Chooser + queue recipe pointer — docs/dialogs-flyouts.md (1.48)."),
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
            title: qsTr("Onboarding coach"),
            category: "dialogs",
            icon: FluentIcons.Lightbulb,
            description: qsTr("Sequenced TeachingTips + don’t-show-again — docs/feedback.md (1.55)."),
            component: "OnboardingCoachPage",
            source: "pages/OnboardingCoachPage.qml"
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
            category: "basic",
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
            category: "charts",
            icon: FluentIcons.Slider,
            description: qsTr("Toolkit-style radial needle gauge (experimental — deferred 1.66)."),
            component: "RadialGaugePage",
            source: "pages/RadialGaugePage.qml"
        },
        {
            title: qsTr("LinearGauge"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Horizontal or vertical linear gauge (experimental — deferred 1.66)."),
            component: "LinearGaugePage",
            source: "pages/LinearGaugePage.qml"
        },
        {
            title: qsTr("ArcGauge"),
            category: "charts",
            icon: FluentIcons.Slider,
            description: qsTr("Semicircle dashboard gauge (experimental — deferred 1.66)."),
            component: "ArcGaugePage",
            source: "pages/ArcGaugePage.qml"
        },
        {
            title: qsTr("SegmentedGauge"),
            category: "charts",
            icon: FluentIcons.Sync,
            description: qsTr("Segmented ring gauge (experimental — deferred 1.66)."),
            component: "SegmentedGaugePage",
            source: "pages/SegmentedGaugePage.qml"
        },
        {
            title: qsTr("ZoneGauge"),
            category: "charts",
            icon: FluentIcons.Slider,
            description: qsTr("Needle gauge with zone bands (experimental — deferred 1.66)."),
            component: "ZoneGaugePage",
            source: "pages/ZoneGaugePage.qml"
        },
        {
            title: qsTr("RingGauge"),
            category: "charts",
            icon: FluentIcons.Slider,
            description: qsTr("Closed-ring KPI gauge (stable 1.23) — docs/charts.md."),
            component: "RingGaugePage",
            source: "pages/RingGaugePage.qml"
        },
        {
            title: qsTr("TankGauge"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Vertical tank / reservoir gauge (experimental — deferred 1.66)."),
            component: "TankGaugePage",
            source: "pages/TankGaugePage.qml"
        },
        {
            title: qsTr("ThermometerGauge"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Stem-and-bulb thermometer (experimental — deferred 1.66)."),
            component: "ThermometerGaugePage",
            source: "pages/ThermometerGaugePage.qml"
        },
        {
            title: qsTr("CompassGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Heading compass 0–360° (experimental). Prefer RadialGauge for linear scales."),
            component: "CompassGaugePage",
            source: "pages/CompassGaugePage.qml"
        },
        {
            title: qsTr("VuMeter"),
            category: "charts",
            icon: FluentIcons.Microphone,
            description: qsTr("LED / peak-hold meter (experimental). Prefer LinearGauge for analog tracks."),
            component: "VuMeterPage",
            source: "pages/VuMeterPage.qml"
        },
        {
            title: qsTr("DualRingGauge"),
            category: "charts",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Concentric KPI rings (experimental). Prefer RingGauge.value2 when scales match."),
            component: "DualRingGaugePage",
            source: "pages/DualRingGaugePage.qml"
        },
        {
            title: qsTr("TachometerGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("RPM needle with redline (experimental). Prefer RadialGauge for generic scales."),
            component: "TachometerGaugePage",
            source: "pages/TachometerGaugePage.qml"
        },
        {
            title: qsTr("BatteryGauge"),
            category: "charts",
            icon: FluentIcons.Battery,
            description: qsTr("Battery silhouette (experimental). Prefer RingGauge for a generic closed ring."),
            component: "BatteryGaugePage",
            source: "pages/BatteryGaugePage.qml"
        },
        {
            title: qsTr("FuelGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("E–F fuel arc (experimental). Prefer RingGauge."),
            component: "FuelGaugePage",
            source: "pages/FuelGaugePage.qml"
        },
        {
            title: qsTr("QuarterGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("90° quadrant meter (experimental). Prefer RadialGauge."),
            component: "QuarterGaugePage",
            source: "pages/QuarterGaugePage.qml"
        },
        {
            title: qsTr("DigitGauge"),
            category: "charts",
            icon: FluentIcons.Calculator,
            description: qsTr("Seven-segment readout (experimental). Prefer KpiTile."),
            component: "DigitGaugePage",
            source: "pages/DigitGaugePage.qml"
        },
        {
            title: qsTr("CylinderGauge"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Isometric cylinder level (experimental). Prefer TankGauge."),
            component: "CylinderGaugePage",
            source: "pages/CylinderGaugePage.qml"
        },
        {
            title: qsTr("LedRingGauge"),
            category: "charts",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Circular LED / peak-hold (experimental). Prefer VuMeter."),
            component: "LedRingGaugePage",
            source: "pages/LedRingGaugePage.qml"
        },
        {
            title: qsTr("PressureGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Zoned industrial needle (experimental). Prefer RadialGauge."),
            component: "PressureGaugePage",
            source: "pages/PressureGaugePage.qml"
        },
        {
            title: qsTr("SpeedometerGauge"),
            category: "charts",
            icon: FluentIcons.SpeedHigh,
            description: qsTr("Vehicle speed needle (experimental). Prefer RadialGauge."),
            component: "SpeedometerGaugePage",
            source: "pages/SpeedometerGaugePage.qml"
        },
        {
            title: qsTr("CoolantGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("C–H coolant arc (experimental). Prefer ThermometerGauge."),
            component: "CoolantGaugePage",
            source: "pages/CoolantGaugePage.qml"
        },
        {
            title: qsTr("BoostGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Vacuum/boost needle (experimental). Prefer RadialGauge."),
            component: "BoostGaugePage",
            source: "pages/BoostGaugePage.qml"
        },
        {
            title: qsTr("VoltageGauge"),
            category: "charts",
            icon: FluentIcons.Battery,
            description: qsTr("12 V electrical bar (experimental). Prefer LinearGauge."),
            component: "VoltageGaugePage",
            source: "pages/VoltageGaugePage.qml"
        },
        {
            title: qsTr("GearIndicator"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("PRNDS gear readout (experimental). Prefer DigitGauge."),
            component: "GearIndicatorPage",
            source: "pages/GearIndicatorPage.qml"
        },
        {
            title: qsTr("OdometerGauge"),
            category: "charts",
            icon: FluentIcons.Calculator,
            description: qsTr("Total and trip distance (experimental). Prefer DigitGauge."),
            component: "OdometerGaugePage",
            source: "pages/OdometerGaugePage.qml"
        },
        {
            title: qsTr("TelltaleBar"),
            category: "charts",
            icon: FluentIcons.Warning,
            description: qsTr("Cluster warning lamps (experimental). Prefer InfoBadge."),
            component: "TelltaleBarPage",
            source: "pages/TelltaleBarPage.qml"
        },
        {
            title: qsTr("TpmsGauge"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Four-corner tire pressure (experimental). Prefer KpiTile."),
            component: "TpmsGaugePage",
            source: "pages/TpmsGaugePage.qml"
        },
        {
            title: qsTr("GMeterGauge"),
            category: "charts",
            icon: FluentIcons.DialShape3,
            description: qsTr("Lateral/longitudinal G plot (experimental). Prefer ScatterChart."),
            component: "GMeterGaugePage",
            source: "pages/GMeterGaugePage.qml"
        },
        {
            title: qsTr("AutomotiveCluster"),
            category: "charts",
            icon: FluentIcons.SpeedHigh,
            description: qsTr("Composed instrument cluster (experimental). Prefer the stable six."),
            component: "AutomotiveClusterPage",
            source: "pages/AutomotiveClusterPage.qml"
        },
        {
            title: qsTr("KpiTile"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("KPI tile with delta / sparkline (stable 1.23) — docs/charts.md."),
            component: "KpiTilePage",
            source: "pages/KpiTilePage.qml"
        },
        {
            title: qsTr("Dashboard"),
            category: "charts",
            icon: FluentIcons.Home,
            description: qsTr("Stable KPI/chart layout (1.66); extra gauges deferred — docs/charts.md."),
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
            category: "navigation",
            icon: FluentIcons.Folder,
            description: qsTr("FilePicker · tray · Snap / reveal — Linux portal harden 1.68."),
            component: "SystemIntegrationPage",
            source: "pages/SystemIntegrationPage.qml"
        },
        {
            title: qsTr("MediaPlayerElement"),
            category: "dialogs",
            icon: FluentIcons.Video,
            description: qsTr("Optional Qt Multimedia — permanent defer 2.09. docs/media.md."),
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
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("A multi-segment meter for stacked values."),
            component: "MeterBarPage",
            source: "pages/MeterBarPage.qml"
        },
        {
            title: qsTr("Charts"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Stable six + deferred compose chooser (2.26) — docs/charts.md."),
            component: "ChartsPage",
            source: "pages/ChartsPage.qml"
        },
        {
            title: qsTr("Gauges"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Deferred gauge chooser — product apps use RingGauge / KpiTile."),
            component: "GaugesHubPage",
            source: "pages/GaugesHubPage.qml"
        },
        {
            title: qsTr("Sparkline"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Compact inline trend (experimental — deferred 1.66). Prefer KpiTile.trendValues."),
            component: "SparklinePage",
            source: "pages/SparklinePage.qml"
        },
        {
            title: qsTr("LineChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Multi-series line/area chart (stable 1.23) — docs/charts.md."),
            component: "LineChartPage",
            source: "pages/LineChartPage.qml"
        },
        {
            title: qsTr("AreaChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Filled area chart (experimental — deferred 1.66). Prefer LineChart showArea."),
            component: "AreaChartPage",
            source: "pages/AreaChartPage.qml"
        },
        {
            title: qsTr("BarChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Vertical column chart (stable 1.23) — docs/charts.md."),
            component: "BarChartPage",
            source: "pages/BarChartPage.qml"
        },
        {
            title: qsTr("HorizontalBarChart"),
            category: "charts",
            icon: FluentIcons.Dial6,
            description: qsTr("Horizontal bars (experimental — deferred 1.66). Prefer BarChart."),
            component: "HorizontalBarChartPage",
            source: "pages/HorizontalBarChartPage.qml"
        },
        {
            title: qsTr("StackedBarChart"),
            category: "charts",
            icon: FluentIcons.DialShape3,
            description: qsTr("Stacked columns (experimental — deferred 1.66)."),
            component: "StackedBarChartPage",
            source: "pages/StackedBarChartPage.qml"
        },
        {
            title: qsTr("DonutChart"),
            category: "charts",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Part-to-whole donut (stable 1.23) — docs/charts.md."),
            component: "DonutChartPage",
            source: "pages/DonutChartPage.qml"
        },
        {
            title: qsTr("PieChart"),
            category: "charts",
            icon: FluentIcons.DonutChart,
            description: qsTr("Solid pie (experimental — deferred 1.66). Prefer DonutChart."),
            component: "PieChartPage",
            source: "pages/PieChartPage.qml"
        },
        {
            title: qsTr("ScatterChart"),
            category: "charts",
            icon: FluentIcons.BarChartVertical,
            description: qsTr("Scatter plot (experimental — deferred 1.66)."),
            component: "ScatterChartPage",
            source: "pages/ScatterChartPage.qml"
        },
        {
            title: qsTr("WaterfallChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Bridge / step chart (experimental — deferred 1.66)."),
            component: "WaterfallChartPage",
            source: "pages/WaterfallChartPage.qml"
        },
        {
            title: qsTr("HeatmapChart"),
            category: "charts",
            icon: FluentIcons.AreaChartMirrored,
            description: qsTr("Density heatmap (experimental — deferred 1.66)."),
            component: "HeatmapChartPage",
            source: "pages/HeatmapChartPage.qml"
        },
        {
            title: qsTr("RadarChart"),
            category: "charts",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Spider / radar chart (experimental — deferred 1.66)."),
            component: "RadarChartPage",
            source: "pages/RadarChartPage.qml"
        },
        {
            title: qsTr("ChartCard"),
            category: "charts",
            icon: FluentIcons.Document,
            description: qsTr("Dashboard card chrome (stable 1.23) — docs/charts.md."),
            component: "ChartCardPage",
            source: "pages/ChartCardPage.qml"
        },
        {
            title: qsTr("BulletChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("KPI bullet (experimental — deferred 1.66). Prefer KpiTile."),
            component: "BulletChartPage",
            source: "pages/BulletChartPage.qml"
        },
        {
            title: qsTr("ComboChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Dual-axis bars + line (experimental). Volume vs price."),
            component: "ComboChartPage",
            source: "pages/ComboChartPage.qml"
        },
        {
            title: qsTr("FunnelChart"),
            category: "charts",
            icon: FluentIcons.Filter,
            description: qsTr("Conversion funnel (experimental). Prefer DonutChart for part-to-whole."),
            component: "FunnelChartPage",
            source: "pages/FunnelChartPage.qml"
        },
        {
            title: qsTr("CandlestickChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("OHLC candlesticks (experimental). Pass {o,h,l,c} objects."),
            component: "CandlestickChartPage",
            source: "pages/CandlestickChartPage.qml"
        },
        {
            title: qsTr("HistogramChart"),
            category: "charts",
            icon: FluentIcons.BarChartVertical,
            description: qsTr("Frequency bins (experimental). ChartUtils.histogramBins."),
            component: "HistogramChartPage",
            source: "pages/HistogramChartPage.qml"
        },
        {
            title: qsTr("BoxPlotChart"),
            category: "charts",
            icon: FluentIcons.BarChartVertical,
            description: qsTr("Tukey box-and-whisker (experimental). ChartUtils.boxPlotStats."),
            component: "BoxPlotChartPage",
            source: "pages/BoxPlotChartPage.qml"
        },
        {
            title: qsTr("ParetoChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Ranked bars + cumulative percent (experimental)."),
            component: "ParetoChartPage",
            source: "pages/ParetoChartPage.qml"
        },
        {
            title: qsTr("BandChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("High/low envelope with mid line (experimental). Prefer LineChart.showArea."),
            component: "BandChartPage",
            source: "pages/BandChartPage.qml"
        },
        {
            title: qsTr("TreemapChart"),
            category: "charts",
            icon: FluentIcons.GridView,
            description: qsTr("Slice-and-dice treemap (experimental). Prefer DonutChart."),
            component: "TreemapChartPage",
            source: "pages/TreemapChartPage.qml"
        },
        {
            title: qsTr("PolarAreaChart"),
            category: "charts",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Coxcomb / polar area (experimental). Prefer RadarChart."),
            component: "PolarAreaChartPage",
            source: "pages/PolarAreaChartPage.qml"
        },
        {
            title: qsTr("ViolinChart"),
            category: "charts",
            icon: FluentIcons.AreaChart,
            description: qsTr("Density violins (experimental). Prefer BoxPlotChart for Tukey summaries."),
            component: "ViolinChartPage",
            source: "pages/ViolinChartPage.qml"
        },
        {
            title: qsTr("ErrorBarChart"),
            category: "charts",
            icon: FluentIcons.BarChartVertical,
            description: qsTr("Mean ± error whiskers (experimental). Prefer BoxPlotChart for samples."),
            component: "ErrorBarChartPage",
            source: "pages/ErrorBarChartPage.qml"
        },
        {
            title: qsTr("WaffleChart"),
            category: "charts",
            icon: FluentIcons.GridView,
            description: qsTr("10×10 part-to-whole (experimental). Prefer DonutChart."),
            component: "WaffleChartPage",
            source: "pages/WaffleChartPage.qml"
        },
        {
            title: qsTr("LollipopChart"),
            category: "charts",
            icon: FluentIcons.PieSingle,
            description: qsTr("Stem-and-marker (experimental). Prefer BarChart."),
            component: "LollipopChartPage",
            source: "pages/LollipopChartPage.qml"
        },
        {
            title: qsTr("DumbbellChart"),
            category: "charts",
            icon: FluentIcons.AreaChartMirrored,
            description: qsTr("Before/after pairs (experimental). Prefer BarChart.series."),
            component: "DumbbellChartPage",
            source: "pages/DumbbellChartPage.qml"
        },
        {
            title: qsTr("SunburstChart"),
            category: "charts",
            icon: FluentIcons.ProgressRingCommon,
            description: qsTr("Two-level nested rings (experimental). Prefer DonutChart."),
            component: "SunburstChartPage",
            source: "pages/SunburstChartPage.qml"
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
            category: "layout",
            icon: FluentIcons.Sync,
            description: qsTr("Motion recipe hub (1.22) — ConnectedAnimation, entrance, theme transitions."),
            component: "AnimationsPage",
            source: "pages/AnimationsPage.qml"
        },
        {
            title: qsTr("EntranceThemeTransition"),
            category: "layout",
            icon: FluentIcons.Completed,
            description: qsTr("Fade + rise + scale entrance — docs/animations.md (1.22)."),
            component: "EntranceThemeTransitionPage",
            source: "pages/EntranceThemeTransitionPage.qml"
        },
        {
            title: qsTr("Theme transitions"),
            category: "layout",
            icon: FluentIcons.Sync,
            description: qsTr("ContentThemeTransition + RepositionThemeTransition — docs/animations.md (1.22)."),
            component: "ThemeTransitionsPage",
            source: "pages/ThemeTransitionsPage.qml"
        },
        {
            title: qsTr("Style spot-check"),
            category: "layout",
            icon: FluentIcons.Edit,
            description: qsTr("WinUI 3 Style chrome audit — docs/style-polish.md (2.17)."),
            component: "StyleSpotCheckPage",
            source: "pages/StyleSpotCheckPage.qml"
        },
        {
            title: qsTr("Theme overrides"),
            category: "layout",
            icon: FluentIcons.Color,
            description: qsTr("Brand + contrast AA table — docs/color-contrast.md (1.43)."),
            component: "ThemeOverridesPage",
            source: "pages/ThemeOverridesPage.qml"
        },
        {
            title: qsTr("Theme prefs"),
            category: "layout",
            icon: FluentIcons.Color,
            description: qsTr("ThemeAppearanceSettings + copy recipe — kit, not Gallery-only (1.69)."),
            component: "ThemePrefsPage",
            source: "pages/ThemePrefsPage.qml"
        },
        {
            title: qsTr("ConnectedAnimation"),
            category: "layout",
            icon: FluentIcons.Sync,
            description: qsTr("Shared-element list→detail — docs/animations.md (1.22)."),
            component: "ConnectedAnimationPage",
            source: "pages/ConnectedAnimationPage.qml"
        },
        {
            title: qsTr("CopyButton"),
            category: "basic",
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
            category: "basic",
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
            category: "basic",
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
            category: "status",
            icon: FluentIcons.Warning,
            description: qsTr("Anti-patterns + 1.xx maturity checkpoint (1.51) — docs/maturity-1xx.md."),
            component: "PitfallsPage",
            source: "pages/PitfallsPage.qml"
        },
        {
            title: qsTr("Accessibility"),
            category: "status",
            icon: FluentIcons.EaseOfAccess,
            description: qsTr("A11y + keyboard + wave 3 focus return / live regions — docs/accessibility.md (1.85)."),
            component: "AccessibilityPage",
            source: "pages/AccessibilityPage.qml"
        },
        {
            title: qsTr("i18n / RTL"),
            category: "text",
            icon: FluentIcons.Globe,
            description: qsTr("Live language switch + full catalogs — docs/i18n-rtl.md."),
            component: "I18nRtlPage",
            source: "pages/I18nRtlPage.qml"
        },
        {
            title: qsTr("Consumer packaging"),
            category: "navigation",
            icon: FluentIcons.Publish,
            description: qsTr("Shared vs static / windeploy / strip — docs/packaging-consumer.md (1.12 / 1.46)."),
            component: "PackagingConsumerPage",
            source: "pages/PackagingConsumerPage.qml"
        },
        {
            title: qsTr("Qt Creator"),
            category: "navigation",
            icon: FluentIcons.Repair,
            description: qsTr("Open Gallery / examples with CMake kits — docs/qt-creator.md (1.35)."),
            component: "QtCreatorPage",
            source: "pages/QtCreatorPage.qml"
        },
        {
            title: qsTr("CI / smoke"),
            category: "navigation",
            icon: FluentIcons.ConstructionCone,
            description: qsTr("Gallery --smoke · docs links · Qt matrix — python scripts/smoke_gallery.py."),
            component: "CiSmokePage",
            source: "pages/CiSmokePage.qml"
        },
        {
            title: qsTr("Example templates"),
            category: "navigation",
            icon: FluentIcons.PageList,
            description: qsTr("Copy-ready starters — gallery-shell (1.50) first. examples/README.md."),
            component: "ExamplesTemplatesPage",
            source: "pages/ExamplesTemplatesPage.qml"
        },
        {
            title: qsTr("Performance"),
            category: "status",
            icon: FluentIcons.ViewAll,
            description: qsTr("Lists / charts / cold start — docs/performance.md (1.25 / 1.39)."),
            component: "PerformancePage",
            source: "pages/PerformancePage.qml"
        },
        {
            title: qsTr("Density"),
            category: "layout",
            icon: FluentIcons.Slider,
            description: qsTr("uiScale / density tokens · narrow shells — docs/density.md (1.30)."),
            component: "DensityPage",
            source: "pages/DensityPage.qml"
        },
        {
            title: qsTr("Touch & pointer"),
            category: "basic",
            icon: FluentIcons.Tablet,
            description: qsTr("Targets · scroll vs drag · pen notes — docs/touch-pointer.md (1.57)."),
            component: "TouchPointerPage",
            source: "pages/TouchPointerPage.qml"
        },
        {
            title: qsTr("Graphics backend"),
            category: "navigation",
            icon: FluentIcons.Color,
            description: qsTr("RHI ship table · --rhi — docs/graphics-backend.md (1.31)."),
            component: "GraphicsBackendPage",
            source: "pages/GraphicsBackendPage.qml"
        },
        {
            title: qsTr("Forms & settings"),
            category: "layout",
            icon: FluentIcons.Settings,
            description: qsTr("FormLayout + LoB templates — docs/forms.md (2.25)."),
            component: "FormsHubPage",
            source: "pages/FormsHubPage.qml"
        },
        {
            title: qsTr("Registration template"),
            category: "layout",
            icon: FluentIcons.Contact,
            description: qsTr("LoB sign-up — FormLayout, tokens, multi-select (2.25)."),
            component: "FormRegistrationTemplatePage",
            source: "pages/FormRegistrationTemplatePage.qml"
        },
        {
            title: qsTr("Admin CRUD template"),
            category: "layout",
            icon: FluentIcons.Edit,
            description: qsTr("DataTable + FormLayout admin editor (2.25)."),
            component: "FormAdminCrudTemplatePage",
            source: "pages/FormAdminCrudTemplatePage.qml"
        },
        {
            title: qsTr("Preferences template"),
            category: "layout",
            icon: FluentIcons.Settings,
            description: qsTr("SettingsView cards + expander + tokens (2.25)."),
            component: "SettingsPreferencesTemplatePage",
            source: "pages/SettingsPreferencesTemplatePage.qml"
        },
        {
            title: qsTr("Commands & menus"),
            category: "menus",
            icon: FluentIcons.More,
            description: qsTr("CommandPalette / CommandBar / MenuFlyout — docs/commands.md (1.15)."),
            component: "CommandsHubPage",
            source: "pages/CommandsHubPage.qml"
        },
        {
            title: qsTr("Feedback surfaces"),
            category: "status",
            icon: FluentIcons.Info,
            description: qsTr("InfoBar / Toast / TeachingTip / onboarding — docs/feedback.md (1.55)."),
            component: "FeedbackHubPage",
            source: "pages/FeedbackHubPage.qml"
        },
        {
            title: qsTr("Notification center"),
            category: "status",
            icon: FluentIcons.Ringer,
            description: qsTr("Grouped in-app history + InfoBadge bell — docs/feedback.md (2.27)."),
            component: "NotificationCenterPage",
            source: "pages/NotificationCenterPage.qml"
        },
        {
            title: qsTr("Keyboard-first"),
            category: "menus",
            icon: FluentIcons.Search,
            description: qsTr("Chords → palette → dialogs → lists — docs/keyboard.md (1.44)."),
            component: "KeyboardFirstPage",
            source: "pages/KeyboardFirstPage.qml"
        },
        {
            title: qsTr("Print / share / export"),
            category: "dialogs",
            icon: FluentIcons.Share,
            description: qsTr("grabToImage · save · reveal — docs/print-share.md (1.63)."),
            component: "PrintSharePage",
            source: "pages/PrintSharePage.qml"
        },
        {
            title: qsTr("Security & trust"),
            category: "dialogs",
            icon: FluentIcons.Shield,
            description: qsTr("WebView2 / drop / picker boundaries — docs/security-trust.md (1.64)."),
            component: "SecurityTrustPage",
            source: "pages/SecurityTrustPage.qml"
        },
        {
            title: qsTr("Settings persistence"),
            category: "layout",
            icon: FluentIcons.Save,
            description: qsTr("QSettings / Settings · schemaVersion — docs/settings-persistence.md (1.65)."),
            component: "SettingsPersistencePage",
            source: "pages/SettingsPersistencePage.qml"
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
            category: "layout",
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
            category: "status",
            icon: FluentIcons.Lightbulb,
            description: qsTr("Form save + coach tip end-to-end — docs/feedback.md (1.34)."),
            component: "InfoTeachingRecipePage",
            source: "pages/InfoTeachingRecipePage.qml"
        },
        {
            title: qsTr("WebView2"),
            category: "dialogs",
            icon: FluentIcons.Globe,
            description: qsTr("Stable Edge WebView2 host (1.18) — trust: docs/security-trust.md (1.64)."),
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
            category: "basic",
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
            title: qsTr("AnimatedIcon"),
            category: "basic",
            icon: FluentIcons.Play,
            description: qsTr("Thin state glyph swap (1.53) — not Lottie. docs/icons.md."),
            component: "AnimatedIconPage",
            source: "pages/AnimatedIconPage.qml"
        },
        {
            title: qsTr("Iconography"),
            category: "basic",
            icon: FluentIcons.OpenInNewWindow,
            description: qsTr("FluentIcons + FontIcon micro-motion (1.49) — docs/icons.md."),
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
    }

    // Gallery API stability badges (2.45) — see docs/experimental-sweep.md
    readonly property var _railHiddenBeyondDefer: [
        // Basic — button variants (Misc Buttons hub)
        "AccentButtonPage", "IconButtonPage", "IconicButtonPage", "HyperlinkButtonPage",
        "ToggleSplitButtonPage", "CopyButtonPage", "ProgressButtonPage",
        // Collections — covered by Delegates / hubs
        "SwipeDelegatePage", "TreeViewRecipePage", "AvatarGroupPage", "GridTilePage",
        "PersonPicturePage", "TimelinePage",
        // Text — suggest patterns covered by SearchBox / AutoSuggestBox demos
        "AutoSuggestBoxPage", "OnScreenKeyboardPage", "I18nRtlPage",
        // Former Recipes category — searchable, not on rail
        "HighDpiPage", "SystemIntegrationPage", "AnimationsPage", "EntranceThemeTransitionPage",
        "ThemeTransitionsPage", "ConnectedAnimationPage", "StyleSpotCheckPage", "ThemeOverridesPage",
        "ThemePrefsPage", "PitfallsPage", "AccessibilityPage", "PackagingConsumerPage", "QtCreatorPage",
        "CiSmokePage", "ExamplesTemplatesPage", "PerformancePage", "DensityPage", "TouchPointerPage",
        "GraphicsBackendPage", "FormsHubPage", "FormRegistrationTemplatePage", "FormAdminCrudTemplatePage",
        "SettingsPreferencesTemplatePage", "NotificationCenterPage", "KeyboardFirstPage", "PrintSharePage",
        "SecurityTrustPage", "SettingsPersistencePage", "InfoTeachingRecipePage",
        // Navigation — carousel / step chrome
        "PageIndicatorPage", "PipsPagerPage", "FlipViewPage", "StepBarPage", "BreadcrumbBarPage"
    ]

    readonly property var _permanentDeferPages: [
        "MediaPlayerElementPage",
        "SparklinePage", "AreaChartPage", "HorizontalBarChartPage", "StackedBarChartPage",
        "PieChartPage", "ScatterChartPage", "WaterfallChartPage", "HeatmapChartPage",
        "RadarChartPage", "BulletChartPage",
        "ComboChartPage", "FunnelChartPage", "CandlestickChartPage", "HistogramChartPage",
        "BoxPlotChartPage", "ParetoChartPage", "BandChartPage", "TreemapChartPage", "PolarAreaChartPage",
        "ViolinChartPage", "ErrorBarChartPage", "WaffleChartPage", "LollipopChartPage", "DumbbellChartPage", "SunburstChartPage",
        "RadialGaugePage", "LinearGaugePage", "ArcGaugePage", "SegmentedGaugePage",
        "ZoneGaugePage", "TankGaugePage", "ThermometerGaugePage",
        "CompassGaugePage", "VuMeterPage", "DualRingGaugePage", "TachometerGaugePage", "BatteryGaugePage",
        "FuelGaugePage", "QuarterGaugePage", "DigitGaugePage", "CylinderGaugePage", "LedRingGaugePage", "PressureGaugePage",
        "SpeedometerGaugePage", "CoolantGaugePage", "BoostGaugePage", "VoltageGaugePage", "GearIndicatorPage",
        "OdometerGaugePage", "TelltaleBarPage", "TpmsGaugePage", "GMeterGaugePage", "AutomotiveClusterPage"
    ]

    readonly property var _railHiddenComponents: {
        var h = _railHiddenBeyondDefer.slice(0)
        for (var i = 0; i < _permanentDeferPages.length; ++i) {
            var id = _permanentDeferPages[i]
            if (h.indexOf(id) < 0)
                h.push(id)
        }
        return h
    }

    readonly property var _experimentalPages: [
        "OnScreenKeyboardPage",
        "FileTreePage", "TreeDataGridPage", "ItemsWrapGridPage",
        "CalendarViewPage", "NotificationCenterPage", "RichEditPage", "SemanticZoomPage", "SwipeControlPage",
        "AnimatedIconPage", "AnimationsPage", "ConnectedAnimationPage",
        "EntranceThemeTransitionPage"
    ]

    function apiStabilityForComponent(componentId) {
        if (!componentId || !componentId.length)
            return "stable"
        if (_permanentDeferPages.indexOf(componentId) >= 0)
            return "permanent-defer"
        if (_experimentalPages.indexOf(componentId) >= 0)
            return "experimental"
        return "stable"
    }

    function apiStabilityLabel(stability) {
        if (stability === "permanent-defer")
            return qsTr("Permanent defer")
        if (stability === "experimental")
            return qsTr("Experimental")
        return ""
    }

    function controlsInCategory(key) {
        return controls.filter(function (c) { return c.category === key })
    }

    function isRailVisible(componentId) {
        if (!componentId || !componentId.length)
            return true
        if (_railHiddenComponents.indexOf(componentId) >= 0)
            return false
        var item = findByComponent(componentId)
        if (!item)
            return true
        var cat = item.category
        if (cat === "charts") {
            return componentId === "ChartsPage"
                || componentId === "DashboardPage"
                || componentId === "GaugesHubPage"
                || componentId === "LineChartPage"
                || componentId === "BarChartPage"
                || componentId === "DonutChartPage"
                || componentId === "RingGaugePage"
                || componentId === "KpiTilePage"
                || componentId === "ChartCardPage"
        }
        if (cat === "menus")
            return componentId === "CommandsHubPage"
        if (cat === "dialogs")
            return componentId === "DialogsFlyoutsPage"
        if (cat === "status")
            return componentId === "FeedbackHubPage"
        if (cat === "layout") {
            return componentId === "SettingsHubPage"
                || componentId === "SettingsGroupPage"
                || componentId === "PanelsHubPage"
                || componentId === "TwoPaneViewPage"
                || componentId === "SplitViewPage"
                || componentId === "PanePage"
                || componentId === "DrawerPage"
                || componentId === "ScrollBarPage"
                || componentId === "AnnotatedScrollBarPage"
                || componentId === "FramePage"
                || componentId === "ContentCardPage"
                || componentId === "ActionCardPage"
                || componentId === "FileDropZonePage"
                || componentId === "RefreshContainerPage"
        }
        return true
    }

    function controlsForRail(key) {
        return controls.filter(function (c) {
            return c.category === key && isRailVisible(c.component)
        })
    }

    // Rail row to highlight when opening a (possibly rail-hidden) page from search.
    // Hub / soft-hub hosts keep the selection pip on a visible nav item.
    function railAnchorComponent(componentId) {
        if (!componentId || !componentId.length)
            return ""
        if (isRailVisible(componentId))
            return componentId
        var item = findByComponent(componentId)
        if (!item)
            return ""
        var cat = item.category || ""
        if (cat === "menus")
            return "CommandsHubPage"
        if (cat === "dialogs")
            return "DialogsFlyoutsPage"
        if (cat === "status")
            return "FeedbackHubPage"
        if (cat === "charts") {
            var gauges = componentId.indexOf("Gauge") >= 0
                         || componentId.indexOf("Meter") >= 0
                         || componentId.indexOf("Tachometer") >= 0
                         || componentId.indexOf("Odometer") >= 0
                         || componentId.indexOf("Telltale") >= 0
                         || componentId.indexOf("Tpms") >= 0
                         || componentId === "AutomotiveClusterPage"
                         || componentId === "GearIndicatorPage"
            return gauges ? "GaugesHubPage" : "ChartsPage"
        }
        if (cat === "layout") {
            if (componentId.indexOf("Form") >= 0 || componentId.indexOf("Settings") >= 0)
                return "SettingsHubPage"
            if (componentId.indexOf("Panel") >= 0 || componentId === "ItemsWrapGridPage"
                    || componentId === "SwitchPresenterPage" || componentId === "HeaderedContentControlPage"
                    || componentId === "AcrylicSurfacePage")
                return "PanelsHubPage"
        }
        if (cat === "basic") {
            if (componentId === "AccentButtonPage" || componentId === "IconButtonPage"
                    || componentId === "IconicButtonPage" || componentId === "HyperlinkButtonPage"
                    || componentId === "ToggleSplitButtonPage" || componentId === "CopyButtonPage"
                    || componentId === "ProgressButtonPage")
                return "MiscButtonsPage"
        }
        var rail = controlsForRail(cat)
        for (var i = 0; i < rail.length; ++i) {
            var c = rail[i].component || ""
            if (c.indexOf("Hub") >= 0 || c === "DialogsFlyoutsPage" || c === "ChartsPage"
                    || c === "MiscButtonsPage")
                return c
        }
        return rail.length ? rail[0].component : ""
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

    // Critical pages for Gallery smoke page-load (keep in sync with python scripts/smoke_gallery.py).
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
            "I18nRtlPage",
            "FontIconPage",
            "PitfallsPage",
            "ExamplesTemplatesPage",
            "SearchBoxPage",
            "HighDpiPage",
            "MultiWindowPage",
            "StyleSpotCheckPage",
            "PerformancePage"
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
