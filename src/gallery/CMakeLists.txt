set_source_files_properties(ControlCatalog.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(GalleryHistory.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

if(NOT DEFINED QWINUI3_HAS_MEDIA)
    set(QWINUI3_HAS_MEDIA OFF)
endif()
# Always ship the Media Gallery page (1.21) — EmptyState / stub when Multimedia is off.
set(QWINUI3_GALLERY_MEDIA_QML pages/MediaPlayerElementPage.qml)

find_package(Qt6 REQUIRED COMPONENTS LinguistTools)

qt_add_executable(qwinui3_gallery
    main.cpp
)

qt_add_translations(qwinui3_gallery
    TS_FILES
        translations/qwinui3_gallery_en.ts
        translations/qwinui3_gallery_zh_CN.ts
        translations/qwinui3_gallery_ja_JP.ts
        translations/qwinui3_gallery_ko_KR.ts
        translations/qwinui3_gallery_de_DE.ts
    RESOURCE_PREFIX "/i18n"
)

qt_add_qml_module(qwinui3_gallery
    URI QWinUI3.Gallery
    VERSION 1.0
    SOURCES
        GraphicsBackend.h
        GraphicsBackend.cpp
        GalleryLanguage.h
        GalleryLanguage.cpp
        DemoTreeModel.h
        DemoTreeModel.cpp
    QML_FILES
        Main.qml
        ControlCatalog.qml
        GalleryHistory.qml
        PageHeader.qml
        ApiStabilityBadge.qml
        ControlExample.qml
        CatalogPage.qml
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
        pages/AnimatedIconPage.qml
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
        pages/CommandPalettePage.qml
        pages/ConnectedAnimationPage.qml
        pages/AnimationsPage.qml
        pages/ContentCardPage.qml
        pages/ContentDialogPage.qml
        pages/DialogsFlyoutsPage.qml
        pages/CopyButtonPage.qml
        pages/DataTablePage.qml
        pages/DelegatesPage.qml
        pages/DialPage.qml
        pages/DialogPage.qml
        pages/DatePickerPage.qml
        pages/DockPanelPage.qml
        pages/DrawerPage.qml
        pages/DropDownButtonPage.qml
        pages/EmptyStatePage.qml
        pages/EntranceThemeTransitionPage.qml
        pages/ExpanderPage.qml
        pages/FlipViewPage.qml
        pages/FlyoutPage.qml
        pages/FormValidationPage.qml
        pages/FormRegistrationTemplatePage.qml
        pages/FormAdminCrudTemplatePage.qml
        pages/SettingsPreferencesTemplatePage.qml
        pages/FramePage.qml
        pages/FontIconPage.qml
        pages/GridTilePage.qml
        pages/SettingsGroupPage.qml
        pages/StatusBarPage.qml
        pages/GroupBoxPage.qml
        pages/HeaderedContentControlPage.qml
        pages/HeaderedTextBoxPage.qml
        pages/HeaderedComboBoxPage.qml
        pages/HighDpiPage.qml
        pages/HyperlinkButtonPage.qml
        pages/IconButtonPage.qml
        pages/IconicButtonPage.qml
        pages/InfoBadgePage.qml
        pages/InfoBarHostPage.qml
        pages/InfoBarPage.qml
        pages/InfoButtonPage.qml
        pages/InfoTeachingRecipePage.qml
        pages/OnboardingCoachPage.qml
        pages/ItemsRepeaterPage.qml
        pages/ItemsWrapGridPage.qml
        pages/ItemsViewPage.qml
        pages/WebView2Page.qml
        pages/KeyVisualPage.qml
        pages/LabelPage.qml
        pages/ListTilePage.qml
        pages/ListDetailsViewPage.qml
        pages/MenuBarPage.qml
        pages/MenuFlyoutPage.qml
        pages/MenuFlyoutItemPage.qml
        pages/MenuPage.qml
        pages/MetadataControlPage.qml
        pages/MeterBarPage.qml
        pages/MultiWindowPage.qml
        pages/PitfallsPage.qml
        pages/AccessibilityPage.qml
        pages/I18nRtlPage.qml
        pages/RecipesHubPage.qml
        pages/PackagingConsumerPage.qml
        pages/QtCreatorPage.qml
        pages/PerformancePage.qml
        pages/DensityPage.qml
        pages/GraphicsBackendPage.qml
        pages/ExamplesTemplatesPage.qml
        pages/CiSmokePage.qml
        pages/FormsHubPage.qml
        pages/CommandsHubPage.qml
        pages/FeedbackHubPage.qml
        pages/KeyboardFirstPage.qml
        pages/OnScreenKeyboardPage.qml
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
        pages/NotificationBridgePage.qml
        pages/NotificationCenterPage.qml
        pages/NumberBoxPage.qml
        pages/PageIndicatorPage.qml
        pages/PanePage.qml
        pages/PasswordBoxPage.qml
        pages/PersonPicturePage.qml
        pages/PipsPagerPage.qml
        pages/PagerControlPage.qml
        pages/PivotPage.qml
        pages/PrintSharePage.qml
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
        pages/RichEditPage.qml
        pages/SearchRecipesPage.qml
        pages/SecurityTrustPage.qml
        pages/SegmentedControlPage.qml
        pages/SelectorBarPage.qml
        pages/SettingsPersistencePage.qml
        pages/SettingsCardPage.qml
        pages/SettingsComboSliderPage.qml
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
        pages/FileDropZonePage.qml
        pages/SystemIntegrationPage.qml
        pages/TabBarPage.qml
        pages/TableViewPage.qml
        pages/TabViewPage.qml
        pages/TeachingTipPage.qml
        pages/ThemeTransitionsPage.qml
        pages/StyleSpotCheckPage.qml
        pages/ThemeOverridesPage.qml
        pages/ThemePrefsPage.qml
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
        pages/TouchPointerPage.qml
        pages/ToggleButtonPage.qml
        pages/ToggleSplitButtonPage.qml
        pages/ToolBarPage.qml
        pages/ToolTipPage.qml
        pages/FileTreePage.qml
        pages/TreeDataGridPage.qml
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
        qwinui3_qtcompat
        qwinui3_theme
        qwinui3_style
        qwinui3_extras
        qwinui3_platform
)

if(NOT QWINUI3_BUILD_SHARED)
    target_link_libraries(qwinui3_gallery
        PRIVATE
            qwinui3_themeplugin
            qwinui3_styleplugin
            qwinui3_extrasplugin
            qwinui3_platformplugin
    )
endif()

# Drop GPL/Commercial Qt add-ons (e.g. Virtual Keyboard) if windeployqt copied them.
include(${CMAKE_SOURCE_DIR}/cmake/StripRestrictedQtModules.cmake)
qwinui3_strip_restricted_qt_modules(qwinui3_gallery)

# Dev layout: published exe lives in ${CMAKE_BINARY_DIR} while QML modules stay under
# src/*/QWinUI3. Keep Gallery on QmlImports so loadFromModule works from the build root.
if(WIN32)
    file(WRITE "${CMAKE_BINARY_DIR}/qt.conf"
"[Paths]
Prefix = .
Libraries = .
Binaries = .
Plugins = plugins
QmlImports = ${CMAKE_BINARY_DIR}/src/gallery,${CMAKE_BINARY_DIR}/src/platform/QWinUI3,${CMAKE_BINARY_DIR}/src/extras/QWinUI3,${CMAKE_BINARY_DIR}/src/theme/QWinUI3,qml
")
endif()

# Qt qml finalizers often leave the binary under build/src/gallery/. Always
# publish to the build root on every build (ALL), not only when re-linked —
# otherwise incremental Ninja skips POST_BUILD and build/qwinui3_gallery vanishes.
add_custom_target(publish_qwinui3_gallery ALL
    DEPENDS qwinui3_gallery
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:qwinui3_gallery>"
            "${CMAKE_BINARY_DIR}/$<TARGET_FILE_NAME:qwinui3_gallery>"
    COMMENT "Publish qwinui3_gallery to build root"
    VERBATIM
)

if(QWINUI3_HAS_WEBVIEW2 AND DEFINED QWINUI3_WEBVIEW2_DLL AND EXISTS "${QWINUI3_WEBVIEW2_DLL}")
    add_custom_command(TARGET qwinui3_gallery POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${QWINUI3_WEBVIEW2_DLL}"
                "$<TARGET_FILE_DIR:qwinui3_gallery>/WebView2Loader.dll"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${QWINUI3_WEBVIEW2_DLL}"
                "${CMAKE_BINARY_DIR}/WebView2Loader.dll"
        COMMENT "Copy WebView2Loader.dll beside gallery"
        VERBATIM
    )
endif()
