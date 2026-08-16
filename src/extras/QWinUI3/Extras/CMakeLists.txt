qt_add_library(qwinui3_extras ${QWINUI3_LIB_TYPE})

# ChartUtils must be a QML singleton — .js in QML_FILES triggers a Qt 6.8
# double-registration bug ("QWinUI3.Extras is ambiguous").
set_source_files_properties(ChartUtils.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(ContentDialogQueue.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)
set_source_files_properties(ConnectedAnimationService.qml PROPERTIES
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
        message(WARNING "QWINUI3_BUILD_MEDIA=ON but Qt6 Multimedia was not found; skipping MediaPlayerElement")
    endif()
endif()
set(QWINUI3_HAS_MEDIA ${QWINUI3_HAS_MEDIA} PARENT_SCOPE)

qt_add_qml_module(qwinui3_extras
    URI QWinUI3.Extras
    VERSION 1.0
    SOURCES
        ChartSeries.h
        ChartSeries.cpp
    QML_FILES
        AccentButton.qml
        AcrylicSurface.qml
        AppBarButton.qml
        AppBarSeparator.qml
        AppBarToggleButton.qml
        AnnotatedScrollBar.qml
        AvatarGroup.qml
        AutoSuggestBox.qml
        BreadcrumbBar.qml
        CalendarDatePicker.qml
        Chip.qml
        ChipGroup.qml
        ColorPicker.qml
        ColorPickerButton.qml
        CommandBar.qml
        CommandBarFlyout.qml
        CommandPalette.qml
        ContentCard.qml
        ContentDialog.qml
        ContentDialogQueue.qml
        ConnectedAnimation.qml
        ConnectedAnimationService.qml
        ContentThemeTransition.qml
        CopyButton.qml
        DataTable.qml
        DatePicker.qml
        DockPanel.qml
        DropDownButton.qml
        FormLayout.qml
        ValidationSummary.qml
        ItemsView.qml
        ItemsRepeater.qml
        EmptyState.qml
        EntranceThemeTransition.qml
        Expander.qml
        NotificationBridge.qml
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
        MetadataControl.qml
        MetadataItem.qml
        MeterBar.qml
        Sparkline.qml
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
        ChartCard.qml
        ChartLegend.qml
        ChartUtils.qml
        MultiSelectComboBox.qml
        NavigationView.qml
        NumberBox.qml
        PasswordBox.qml
        PersonPicture.qml
        PipsPager.qml
        PagerControl.qml
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
        KpiTile.qml
        RadioButtons.qml
        RadioMenuFlyoutItem.qml
        RatingControl.qml
        RefreshContainer.qml
        RelativePanel.qml
        SearchBox.qml
        SegmentedControl.qml
        SelectorBar.qml
        SettingsCard.qml
        SettingsExpander.qml
        SettingsGroup.qml
        SettingsToggleCard.qml
        SettingsComboCard.qml
        SettingsSliderCard.qml
        SettingsView.qml
        DetailRow.qml
        SwipeAction.qml
        Shimmer.qml
        SplitButton.qml
        StackPanel.qml
        StatusDot.qml
        StepBar.qml
        SwipeControl.qml
        SwitchCase.qml
        SwitchPresenter.qml
        TabView.qml
        TabViewTearOutWindow.qml
        TeachingTip.qml
        TextBlock.qml
        Timeline.qml
        TimePicker.qml
        TitleBar.qml
        Toast.qml
        ToastHost.qml
        TokenizingTextBox.qml
        ToggleButton.qml
        ToggleMenuFlyoutItem.qml
        ToggleSplitButton.qml
        TwoPaneView.qml
        UniformGrid.qml
        WindowChrome.qml
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
        ${QWINUI3_EXTRAS_MEDIA_QML}
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_extras
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
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
