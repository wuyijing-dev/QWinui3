qt_add_library(qwinui3_style STATIC)

qt_add_qml_module(qwinui3_style
    URI QWinUI3
    VERSION 1.0
    QML_FILES
        ApplicationWindow.qml
        BusyIndicator.qml
        Button.qml
        CheckBox.qml
        CheckDelegate.qml
        ComboBox.qml
        DayOfWeekRow.qml
        DelayButton.qml
        Dial.qml
        Dialog.qml
        DialogButtonBox.qml
        Drawer.qml
        FocusStroke.qml
        SelectionPip.qml
        Frame.qml
        GroupBox.qml
        HorizontalHeaderView.qml
        ItemDelegate.qml
        Label.qml
        Menu.qml
        MenuBar.qml
        MenuBarItem.qml
        MenuItem.qml
        MenuSeparator.qml
        MonthGrid.qml
        Page.qml
        PageIndicator.qml
        Pane.qml
        Popup.qml
        ProgressBar.qml
        RadioButton.qml
        RadioDelegate.qml
        RangeSlider.qml
        RoundButton.qml
        ScrollBar.qml
        ScrollIndicator.qml
        ScrollView.qml
        Slider.qml
        SpinBox.qml
        SplitView.qml
        StackView.qml
        Switch.qml
        SwitchDelegate.qml
        SwipeDelegate.qml
        SwipeView.qml
        TabBar.qml
        TabButton.qml
        TextArea.qml
        TextField.qml
        ToolBar.qml
        ToolButton.qml
        ToolSeparator.qml
        ToolTip.qml
        TreeViewDelegate.qml
        Tumbler.qml
        VerticalHeaderView.qml
    IMPORTS
        TARGET qwinui3_theme
        TARGET qwinui3_platform
)

target_link_libraries(qwinui3_style
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        qwinui3_theme
        qwinui3_platform
)
