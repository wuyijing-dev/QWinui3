import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Touch, pen & pointer cookbook (1.57).
// Recipe: docs/touch-pointer.md · docs/density.md · docs/accessibility.md

CatalogPage {
    id: page
    title: qsTr("Touch & pointer")
    subtitle: qsTr("Targets · scroll vs drag · pen hover notes — docs/touch-pointer.md (1.57).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    readonly property real minTarget: Theme.controlHeight

    ControlExample {
        headerText: qsTr("When to use (1.57)")
        qmlSource: "Theme.density / Theme.controlHeight\ndocs/touch-pointer.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Finger-first shells stay on Theme.density \"standard\" (or bump uiScale). Compact shrinks controlHeight (~0.85×). Do not rely on hover-only UI — fingers have no hover; stylus hover is optional preview only. No ink/handwriting product in 1.57.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("Live: density=%1 · uiScale=%2 · controlHeight=%3 (min target)")
                    .arg(Theme.density)
                    .arg(Theme.uiScale)
                    .arg(page.minTarget)
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Density")
                    onClicked: page.openComp("DensityPage")
                }
                Button {
                    text: qsTr("Theme overrides")
                    highlighted: true
                    onClicked: page.openComp("ThemeOverridesPage")
                }
                Button {
                    text: qsTr("Accessibility")
                    onClicked: page.openComp("AccessibilityPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Target size demo")
        qmlSource: "implicitHeight: Math.max(…, Theme.controlHeight)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Boxes show Theme.controlHeight. Primary buttons and icon-only hits should meet this floor.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
            }
            RowLayout {
                spacing: Theme.spacing
                Rectangle {
                    width: page.minTarget
                    height: page.minTarget
                    radius: Theme.cornerControl
                    color: Theme.fillSubtle
                    border.color: Theme.accent
                    border.width: 1
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("%1²").arg(Math.round(page.minTarget))
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                    }
                }
                Button {
                    text: qsTr("Standard")
                    implicitHeight: Math.max(implicitHeight, page.minTarget)
                }
                IconButton {
                    symbol: FluentIcons.Settings
                    toolTipText: qsTr("Settings")
                    Accessible.name: qsTr("Settings")
                }
                AccentButton {
                    text: qsTr("Primary")
                    implicitHeight: Math.max(implicitHeight, page.minTarget)
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Scroll vs drag vs click")
        qmlSource: "FileDropZone · SwipeControl · RefreshContainer\ndocs/drag-drop.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keep flick scrolling on the scrollable. FileDropZone must keep Browse (touch often has no OS file drag). SwipeControl should also expose a menu/button path. Avoid hover-only discovery.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontBody
            }
            Repeater {
                model: [
                    { label: qsTr("FileDropZone"), page: "FileDropZonePage" },
                    { label: qsTr("SwipeControl"), page: "SwipeControlPage" },
                    { label: qsTr("RefreshContainer"), page: "RefreshContainerPage" },
                    { label: qsTr("Slider"), page: "SliderPage" },
                    { label: qsTr("NavigationView"), page: "NavigationViewPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Finger checklist")
        qmlSource: "docs/touch-pointer.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            CheckBox { text: qsTr("density standard (or uiScale bump) for finger-first") }
            CheckBox { text: qsTr("Primary / icon-only hits ≥ Theme.controlHeight") }
            CheckBox { text: qsTr("No required UI only on hovered") }
            CheckBox { text: qsTr("FileDropZone Browse works without drag") }
            CheckBox { text: qsTr("Swipe reveal has a non-swipe alternative") }
            CheckBox { text: qsTr("Nav / list / settings rows easy to tap") }
            CheckBox { text: qsTr("Keyboard chords still work on touch PCs (docs/keyboard.md)") }
        }
    }
}
