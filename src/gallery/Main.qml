import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: qsTr("QWinUI3 Gallery")
    backdrop: WindowHelper.BackdropSolid

    // Eager init — NavigationView.onCompleted runs before Main.onCompleted,
    // so deferring buildNavModel() left Home with an empty stack.
    property var navModel: buildNavModel()
    property var searchResults: []

    function buildNavModel() {
        var items = []
        items.push({
            type: "item",
            key: "home",
            title: qsTr("Home"),
            icon: "\uE80F",
            component: "HomePage",
            description: qsTr("Gallery home")
        })
        for (var c = 0; c < ControlCatalog.categories.length; ++c) {
            var cat = ControlCatalog.categories[c]
            var children = []
            var list = ControlCatalog.controlsInCategory(cat.key)
            for (var i = 0; i < list.length; ++i) {
                var ctrl = list[i]
                children.push({
                    type: "item",
                    title: ctrl.title,
                    icon: ctrl.icon,
                    description: ctrl.description || "",
                    category: ctrl.category,
                    component: ctrl.component
                })
            }
            items.push({
                type: "group",
                key: cat.key,
                title: cat.title,
                icon: cat.icon || "\uE8F4",
                children: children
            })
        }
        return items
    }

    function navigateToControl(item, mode) {
        if (!item)
            return
        if (mode === "center")
            nav.openFromCenter(item.component)
        else
            nav.navigateToTitle(item.title, mode || "slide")
    }

    header: PlatformTitleBar {
        id: platformTitle
        targetWindow: window
        showCaptionButtons: window.showCaptionButtons
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize

        TitleBar {
            id: titleBar
            anchors.fill: parent
            embedded: true
            dragWindow: window
            useSystemMove: true
            trailingReserve: 0
            title: qsTr("QWinUI3 Gallery")
            searchModel: window.searchResults
            onSearchTextEdited: function (text) {
                window.searchResults = ControlCatalog.search(text)
            }
            onSearchActivated: function (item) {
                window.navigateToControl(item, "center")
            }
            onWidthChanged: platformTitle.reportHitTest()
            onHeightChanged: platformTitle.reportHitTest()
        }
    }

    Component.onCompleted: {
        Qt.callLater(function () { platformTitle.reportHitTest() })
    }

    NavigationView {
        id: nav
        anchors.fill: parent
        model: window.navModel
        headerText: qsTr("QWinUI3")
        footerText: qsTr("Settings")
        footerIcon: "\uE713"
        footerComponent: "SettingsPage"
        pageModule: "QWinUI3.Gallery"
        currentKey: "home"
    }
}
