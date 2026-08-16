set_source_files_properties(ControlCatalog.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(GalleryHistory.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

if(NOT DEFINED QWINUI3_HAS_MEDIA)
    set(QWINUI3_HAS_MEDIA OFF)
endif()
set(QWINUI3_GALLERY_MEDIA_QML)
if(QWINUI3_HAS_MEDIA)
    list(APPEND QWINUI3_GALLERY_MEDIA_QML pages/MediaPlayerElementPage.qml)
endif()

qt_add_executable(qwinui3_gallery
    main.cpp
)

qt_add_qml_module(qwinui3_gallery
    URI QWinUI3.Gallery
    VERSION 1.0
    SOURCES
        GraphicsBackend.h
        GraphicsBackend.cpp
    QML_FILES
        Main.qml
        ControlCatalog.qml
        GalleryHistory.qml
        PageHeader.qml
        ControlExample.qml
        pages/HomePage.qml
        pages/SettingsPage.qml
        pages/ButtonPage.qml
        pages/AccentButtonPage.qml
        pages/ActionCardPage.qml
        pages/AcrylicSurfacePage.qml
        pages/AppBarButtonPage.qml
        pages/AppBarSeparatorPage.qml
        pages/AppBarToggleButtonPage.qml
        pages/AnnotatedScrollBarPage.qml
        pages/AutoSuggestBoxPage.qml
        pages/AvatarGroupPage.qml
        pages/BreadcrumbBarPage.qml
        pages/BusyIndicatorPage.qml
        pages/CalendarDatePickerPage.qml
        pages/CalendarPage.qml
        pages/CheckBoxPage.qml
        pages/ChipGroupPage.qml
        pages/ChipPage.qml
        pages/ColorPickerPage.qml
        pages/ColorPickerButtonPage.qml
        pages/ComboBoxPage.qml
        pages/CommandBarPage.qml
        pages/CommandBarFlyoutPage.qml
        pages/ContentCardPage.qml
        pages/ContentDialogPage.qml
        pages/CopyButtonPage.qml
        pages/DelegatesPage.qml
        pages/DialPage.qml
        pages/DialogPage.qml
        pages/DatePickerPage.qml
        pages/DockPanelPage.qml
        pages/DrawerPage.qml
        pages/DropDownButtonPage.qml
        pages/EmptyStatePage.qml
        pages/ExpanderPage.qml
        pages/FlipViewPage.qml
        pages/FlyoutPage.qml
        pages/FormValidationPage.qml
        pages/FramePage.qml
        pages/FontIconPage.qml
        pages/GridTilePage.qml
        pages/GroupBoxPage.qml
        pages/HeaderedContentControlPage.qml
        pages/HeaderedTextBoxPage.qml
        pages/HyperlinkButtonPage.qml
        pages/IconButtonPage.qml
        pages/InfoBadgePage.qml
        pages/InfoBarHostPage.qml
        pages/InfoBarPage.qml
        pages/ItemsViewPage.qml
        pages/KeyVisualPage.qml
        pages/LabelPage.qml
        pages/ListTilePage.qml
        pages/MenuBarPage.qml
        pages/MenuFlyoutPage.qml
        pages/MenuFlyoutItemPage.qml
        pages/MenuPage.qml
        pages/MetadataControlPage.qml
        pages/MeterBarPage.qml
        pages/PitfallsPage.qml
        pages/ChartsPage.qml
        pages/SparklinePage.qml
        pages/LineChartPage.qml
        pages/AreaChartPage.qml
        pages/BarChartPage.qml
        pages/HorizontalBarChartPage.qml
        pages/StackedBarChartPage.qml
        pages/DonutChartPage.qml
        pages/PieChartPage.qml
        pages/ScatterChartPage.qml
        pages/HeatmapChartPage.qml
        pages/RadarChartPage.qml
        pages/WaterfallChartPage.qml
        pages/BulletChartPage.qml
        pages/ChartCardPage.qml
        pages/MiscButtonsPage.qml
        pages/MultiSelectComboBoxPage.qml
        pages/NavigationViewPage.qml
        pages/NumberBoxPage.qml
        pages/PageIndicatorPage.qml
        pages/PanePage.qml
        pages/PasswordBoxPage.qml
        pages/PersonPicturePage.qml
        pages/PipsPagerPage.qml
        pages/PivotPage.qml
        pages/ProgressBarPage.qml
        pages/ProgressButtonPage.qml
        pages/ProgressRingPage.qml
        pages/RadialGaugePage.qml
        pages/LinearGaugePage.qml
        pages/ArcGaugePage.qml
        pages/SegmentedGaugePage.qml
        pages/ZoneGaugePage.qml
        pages/RingGaugePage.qml
        pages/TankGaugePage.qml
        pages/ThermometerGaugePage.qml
        pages/KpiTilePage.qml
        pages/DashboardPage.qml
        pages/RadioButtonPage.qml
        pages/RadioButtonsPage.qml
        pages/RangeSliderPage.qml
        pages/RatingControlPage.qml
        pages/RefreshContainerPage.qml
        pages/RelativePanelPage.qml
        pages/ScrollBarPage.qml
        pages/SearchBoxPage.qml
        pages/SegmentedControlPage.qml
        pages/SelectorBarPage.qml
        pages/SettingsCardPage.qml
        pages/SettingsExpanderPage.qml
        pages/ShimmerPage.qml
        pages/SliderPage.qml
        pages/SpinBoxPage.qml
        pages/SplitButtonPage.qml
        pages/SplitViewPage.qml
        pages/StackPanelPage.qml
        pages/StackViewPage.qml
        pages/StatusDotPage.qml
        pages/StepBarPage.qml
        pages/SwitchPage.qml
        pages/SwitchPresenterPage.qml
        pages/SwipeControlPage.qml
        pages/SwipeDelegatePage.qml
        pages/SwipeViewPage.qml
        pages/SystemIntegrationPage.qml
        pages/TabBarPage.qml
        pages/TableViewPage.qml
        pages/TabViewPage.qml
        pages/TeachingTipPage.qml
        pages/TextAreaPage.qml
        pages/TextBlockPage.qml
        pages/TextFieldPage.qml
        pages/TimelinePage.qml
        pages/TimePickerPage.qml
        pages/TitleBarPage.qml
        pages/WindowParadigmPage.qml
        pages/ToastHostPage.qml
        pages/ToastPage.qml
        pages/TokenizingTextBoxPage.qml
        pages/ToggleButtonPage.qml
        pages/ToggleSplitButtonPage.qml
        pages/ToolBarPage.qml
        pages/ToolTipPage.qml
        pages/TreeViewPage.qml
        pages/TreeViewRecipePage.qml
        pages/TumblerPage.qml
        pages/TwoPaneViewPage.qml
        pages/UniformGridPage.qml
        pages/WrapPanelPage.qml
        ${QWINUI3_GALLERY_MEDIA_QML}
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_gallery
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::LabsQmlModels
        qwinui3_theme
        qwinui3_themeplugin
        qwinui3_style
        qwinui3_styleplugin
        qwinui3_extras
        qwinui3_extrasplugin
        qwinui3_platform
        qwinui3_platformplugin
)

# Drop GPL/Commercial Qt add-ons (e.g. Virtual Keyboard) if windeployqt copied them.
include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_gallery)

# Match examples: put the launcher next to build/ (not build/src/gallery/).
set_target_properties(qwinui3_gallery PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
