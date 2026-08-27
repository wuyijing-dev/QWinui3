include("${CMAKE_SOURCE_DIR}/cmake/KeymanCore.cmake")

qt_add_library(qwinui3_extras ${QWINUI3_LIB_TYPE})

# ChartUtils must be a QML singleton — .js in QML_FILES triggers a Qt 6.8
# double-registration bug ("QWinUI3.Extras is ambiguous").
set_source_files_properties(ChartUtils.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(FeedbackSeverity.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(GaugeUtils.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(ContentDialogQueue.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(ConnectedAnimationService.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(WindowMessageBus.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(TabViewDropHub.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

set(QWINUI3_EXTRAS_MEDIA_QML)
set(QWINUI3_HAS_MEDIA OFF)
if(QWINUI3_BUILD_MEDIA)
    find_package(Qt6 COMPONENTS Multimedia QUIET)
    if(TARGET Qt6::Multimedia)
        set(QWINUI3_EXTRAS_MEDIA_QML MediaPlayerElement.qml)
        set(QWINUI3_HAS_MEDIA ON)
    else()
        message(WARNING "QWINUI3_BUILD_MEDIA=ON but Qt6 Multimedia was not found; shipping MediaPlayerElement stub")
        set(QWINUI3_EXTRAS_MEDIA_QML MediaPlayerElementStub.qml)
        set_source_files_properties(MediaPlayerElementStub.qml PROPERTIES
            QT_QML_SOURCE_TYPENAME MediaPlayerElement
        )
    endif()
else()
    set(QWINUI3_EXTRAS_MEDIA_QML MediaPlayerElementStub.qml)
    set_source_files_properties(MediaPlayerElementStub.qml PROPERTIES
        QT_QML_SOURCE_TYPENAME MediaPlayerElement
    )
endif()
set(QWINUI3_HAS_MEDIA ${QWINUI3_HAS_MEDIA} PARENT_SCOPE)

qt_add_qml_module(qwinui3_extras
    URI QWinUI3.Extras
    VERSION 1.0
    QML_FILES
        AccentButton.qml
        AcrylicSurface.qml
        AppBarButton.qml
        AppBarSeparator.qml
        AppBarToggleButton.qml
        AnnotatedScrollBar.qml
        AnimatedIcon.qml
        AvatarGroup.qml
        AutoSuggestBox.qml
        BreadcrumbBar.qml
        CalendarDatePicker.qml
        CalendarView.qml
        Chip.qml
        ChipGroup.qml
        ColorPicker.qml
        ColorPickerButton.qml
        CommandBar.qml
        CommandBarPreset.qml
        AppBarPreset.qml
        CommandBarFlyout.qml
        CommandPalette.qml
        CommandPaletteHost.qml
        CommandRegistry.qml
        ContentCard.qml
        ContentDialog.qml
        ContentDialogQueue.qml
        ConnectedAnimation.qml
        ConnectedAnimationService.qml
        ContentThemeTransition.qml
        CopyButton.qml
        DataTable.qml
        DataTableFilterOverlay.qml
        DashboardShell.qml
        DatePicker.qml
        DockPanel.qml
        DropDownButton.qml
        FormLayout.qml
        FormSection.qml
        ValidationSummary.qml
        ItemsView.qml
        ItemsViewEmptyStateHelper.qml
        ItemsRepeater.qml
        ItemsWrapGrid.qml
        EmptyState.qml
        EntranceThemeTransition.qml
        ErrorBoundary.qml
        Expander.qml
        NotificationBridge.qml
        NotificationCenter.qml
        RepositionThemeTransition.qml
        FlipView.qml
        Flyout.qml
        FontIcon.qml
        GridTile.qml
        HeaderedContentControl.qml
        HeaderedTextBox.qml
        HeaderedComboBox.qml
        HyperlinkButton.qml
        IconButton.qml
        PanelFloatHost.qml
        IconicButton.qml
        InfoBadge.qml
        InfoBar.qml
        InfoBarHost.qml
        InfoButton.qml
        KeyVisual.qml
        KeyChordVisual.qml
        ListTile.qml
        ListDetailsView.qml
        MenuFlyout.qml
        MenuFlyoutHeader.qml
        MenuFlyoutItem.qml
        MenuFlyoutSeparator.qml
        MenuFlyoutPresenter.qml
        MenuFlyoutAutoMaxHeight.qml
        MenuFlyoutSnapshotModel.qml
        ContextMenuAtItem.qml
        RightClickAnchorHelper.qml
        FlyoutKeyboardFocusTrap.qml
        MetadataControl.qml
        MetadataItem.qml
        MaskedTextField.qml
        MatchHighlightText.qml
        MeterBar.qml
        Sparkline.qml
        ChartCard.qml
        ChartUtils.qml
        FeedbackSeverity.qml
        MetricCompareRow.qml
        LiveMetricStrip.qml
        MultiSelectComboBox.qml
        NavigationView.qml
        NumberBox.qml
        OfflineBanner.qml
        OperationRetry.qml
        PasswordBox.qml
        PermissionGate.qml
        PersonPicture.qml
        PipsPager.qml
        PagerControl.qml
        ConfirmWithReason.qml
        Pivot.qml
        ProgressButton.qml
        ProgressRing.qml
        RadialGauge.qml
        LinearGauge.qml
        ArcGauge.qml
        SegmentedGauge.qml
        ZoneGauge.qml
        RingGauge.qml
        TankGauge.qml
        ThermometerGauge.qml
        CompassGauge.qml
        VuMeter.qml
        DualRingGauge.qml
        TachometerGauge.qml
        BatteryGauge.qml
        FuelGauge.qml
        GaugeDragLayer.qml
        GaugeUtils.qml
        QuarterGauge.qml
        DigitGauge.qml
        CylinderGauge.qml
        LedRingGauge.qml
        PressureGauge.qml
        SpeedometerGauge.qml
        CoolantGauge.qml
        BoostGauge.qml
        VoltageGauge.qml
        GearIndicator.qml
        OdometerGauge.qml
        TelltaleBar.qml
        TpmsGauge.qml
        GMeterGauge.qml
        AutomotiveCluster.qml
        KpiTile.qml
        RadioButtons.qml
        RadioMenuFlyoutItem.qml
        RatingControl.qml
        RatingStars.qml
        RecentFiles.qml
        RefreshContainer.qml
        RelativePanel.qml
        RichEdit.qml
        SearchBox.qml
        SearchBoxRecipe.qml
        UnifiedSearchSurface.qml
        SegmentedControl.qml
        SelectorBar.qml
        SemanticZoom.qml
        SensitiveField.qml
        SettingsCard.qml
        SettingsExpander.qml
        SettingsGroup.qml
        SettingsToggleCard.qml
        SettingsComboCard.qml
        SettingsSliderCard.qml
        SettingsView.qml
        ThemeAppearanceSettings.qml
        ThemePersistenceCard.qml
        ThemeSyncCard.qml
        GeometryAndPrefsGuard.qml
        ThemePrefs.qml
        DetailRow.qml
        SwipeAction.qml
        Shimmer.qml
        Skeleton.qml
        SplitButton.qml
        StackPanel.qml
        StatusDot.qml
        StepBar.qml
        SessionRestore.qml
        SplitWorkspace.qml
        LayoutPreset.qml
        SessionTimeout.qml
        Wizard.qml
        WindowMessageBus.qml
        SwipeControl.qml
        SwitchCase.qml
        SwitchPresenter.qml
        TabView.qml
        TabViewDropHub.qml
        TabViewTearOutWindow.qml
        TeachingTip.qml
        TextBlock.qml
        Timeline.qml
        TimePicker.qml
        TitleBar.qml
        TitleBarToolbar.qml
        TitleBarCommandBar.qml
        Toast.qml
        ToastHost.qml
        ToolbarOverflowInspector.qml
        CommandBarKeyHints.qml
        TokenizingTextBox.qml
        ToggleButton.qml
        ToggleMenuFlyoutItem.qml
        ToggleSplitButton.qml
        TwoPaneView.qml
        UniformGrid.qml
        WindowChrome.qml
        StandardTitleChrome.qml
        ShellWindowSupport.qml
        ShellWindow.qml
        BlankWindow.qml
        NavigationWindow.qml
        MenuStatusWindow.qml
        DialogShellWindow.qml
        ToolShellWindow.qml
        CompactOverlayShellWindow.qml
        StatusBar.qml
        WrapPanel.qml
        ActionCard.qml
        FileDropZone.qml
        FileTree.qml
        TreeDataGrid.qml
        ${QWINUI3_EXTRAS_MEDIA_QML}
    IMPORTS
        QtCore
        TARGET qwinui3_theme
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_extras
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Gui
        qwinui3_theme
        qwinui3_style
        qwinui3_platform
        qwinui3_qtcompat
)

if(QWINUI3_HAS_MEDIA)
    target_link_libraries(qwinui3_extras PUBLIC Qt6::Multimedia)
    if(TARGET Qt6::MultimediaQuick)
        target_link_libraries(qwinui3_extras PUBLIC Qt6::MultimediaQuick)
    endif()
endif()

# --- QWinUI3.Extras.Charts (3.35 S12) — imported only when charts are used ---
qt_add_library(qwinui3_extras_charts ${QWINUI3_LIB_TYPE})
get_target_property(_qwinui3_extras_qml_out qwinui3_extras QT_QML_MODULE_OUTPUT_DIRECTORY)
if(NOT _qwinui3_extras_qml_out)
    set(_qwinui3_extras_qml_out "${CMAKE_CURRENT_BINARY_DIR}")
endif()

qt_add_qml_module(qwinui3_extras_charts
    URI QWinUI3.Extras.Charts
    VERSION 1.0
    OUTPUT_DIRECTORY "${_qwinui3_extras_qml_out}/Charts"
    SOURCES
        ChartSeries.h
        ChartSeries.cpp
    QML_FILES
        LineChart.qml
        AreaChart.qml
        BarChart.qml
        HorizontalBarChart.qml
        StackedBarChart.qml
        DonutChart.qml
        PieChart.qml
        ScatterChart.qml
        HeatmapChart.qml
        RadarChart.qml
        WaterfallChart.qml
        BulletChart.qml
        ComboChart.qml
        FunnelChart.qml
        CandlestickChart.qml
        HistogramChart.qml
        BoxPlotChart.qml
        ParetoChart.qml
        BandChart.qml
        TreemapChart.qml
        PolarAreaChart.qml
        ViolinChart.qml
        ErrorBarChart.qml
        WaffleChart.qml
        LollipopChart.qml
        DumbbellChart.qml
        SunburstChart.qml
        ChartEmptyState.qml
        ChartLegend.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
)

target_link_libraries(qwinui3_extras_charts
    PUBLIC
        Qt6::Quick
        qwinui3_extras
        qwinui3_theme
        qwinui3_qtcompat
)

# --- QWinUI3.Extras.Osk (3.35 S12) — Keyman / IME / floating keyboard ---
qt_add_library(qwinui3_extras_osk ${QWINUI3_LIB_TYPE})

qt_add_qml_module(qwinui3_extras_osk
    URI QWinUI3.Extras.Osk
    VERSION 1.0
    OUTPUT_DIRECTORY "${_qwinui3_extras_qml_out}/Osk"
    SOURCES
        KeyboardEngine.h
        KeyboardEngine.cpp
        PinyinLexicon.h
        PinyinLexicon.cpp
        OskUserLexicon.h
        OskUserLexicon.cpp
        OskSpeechService.h
        OskSpeechService.cpp
        OskHandwritingService.h
        OskHandwritingService.cpp
        HangulComposer.h
        HangulComposer.cpp
        RomajiKana.h
        RomajiKana.cpp
    QML_FILES
        ImeCandidateBar.qml
        OskHandwritingPad.qml
        OskPanelButton.qml
        OskSettingsFlyout.qml
        OskVoiceBar.qml
        OnScreenKeyboard.qml
        OnScreenKeyboardWindow.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_extras
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_extras_osk
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        qwinui3_extras
        qwinui3_theme
        qwinui3_platform
        qwinui3_qtcompat
)

qt_add_resources(qwinui3_extras_osk "qwinui3_pinyin_lexicon"
    PREFIX "/QWinUI3"
    FILES
        keyboards/pinyin_lexicon.tsv
        keyboards/pinyin_words.tsv
)

if(WIN32)
    target_link_libraries(qwinui3_extras_osk PRIVATE user32 ole32 oleaut32 uuid sapi)
endif()

if(QWINUI3_HAS_MEDIA)
    target_link_libraries(qwinui3_extras_osk PUBLIC Qt6::Multimedia)
    target_compile_definitions(qwinui3_extras_osk PRIVATE QWINUI3_OSK_MULTIMEDIA=1)
    if(TARGET Qt6::MultimediaQuick)
        target_link_libraries(qwinui3_extras_osk PUBLIC Qt6::MultimediaQuick)
    endif()
endif()

if(QWINUI3_HAVE_KEYMAN)
    target_link_libraries(qwinui3_extras_osk PUBLIC qwinui3_keymancore)
    target_compile_definitions(qwinui3_extras_osk PUBLIC QWINUI3_HAVE_KEYMAN=1)
    qt_add_resources(qwinui3_extras_osk "qwinui3_keyman_keyboards"
        PREFIX "/QWinUI3"
        FILES
            keyboards/basic_kbdus.kmx
            keyboards/basic_kbduk.kmx
            keyboards/basic_kbdgr.kmx
            keyboards/basic_kbdfr.kmx
            keyboards/basic_kbdes.kmx
            keyboards/basic_kbdit.kmx
            keyboards/basic_kbdpo.kmx
            keyboards/basic_kbdpl.kmx
            keyboards/basic_kbdsw.kmx
            keyboards/basic_kbdtuq.kmx
            keyboards/basic_kbdru.kmx
            keyboards/basic_kbda1.kmx
    )
endif()
