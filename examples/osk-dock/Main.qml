import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Copy-ready embedded OSK dock host (2.58). Recipe: docs/osk-in-apps-258.md
// One shared KeyboardEngine for dock + IME scroll hints — not the Gallery tree.

StandardWindow {
    id: window
    width: 640
    height: 720
    visible: true
    title: qsTr("OSK dock example")
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "OskDockExample"

    property bool oskVisible: true

    KeyboardEngine {
        id: sharedEngine
        hardwareInput: true
        systemWide: false
    }

    Component.onCompleted: sharedEngine.watch(window)

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("examples/osk-dock · 2.58")
        }
    }

    AnnotatedScrollBar {
        id: scroll
        anchors.fill: parent
        anchors.bottomMargin: oskVisible ? osk.implicitHeight : 0
        imeEngine: sharedEngine
        labels: [
            { content: qsTr("Profile"), scrollOffset: 0 },
            { content: qsTr("Notes"), scrollOffset: 0.55 }
        ]

        ColumnLayout {
            width: scroll.flickable.width - 2 * Theme.spacingSection
            x: Theme.spacingSection
            spacing: Theme.spacingSection

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }

            Text {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Footer dock + shared KeyboardEngine. Switch to 中文, type pinyin in a field below — candidates float above the dock; the scroll area keeps the field visible.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            FormLayout {
                Layout.fillWidth: true
                labelWidth: 120

                HeaderedTextBox {
                    id: nameField
                    header: qsTr("Display name")
                    placeholderText: qsTr("Alex Chen")
                }

                HeaderedTextBox {
                    id: emailField
                    header: qsTr("Email")
                    placeholderText: qsTr("alex@example.com")
                }

                TextArea {
                    id: notesField
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.dp(120)
                    placeholderText: qsTr("Long notes — scroll follows IME composition (AnnotatedScrollBar.ensureImeVisible).")
                    wrapMode: TextArea.Wrap
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: oskVisible ? qsTr("Hide dock") : qsTr("Show dock")
                    onClicked: oskVisible = !oskVisible
                }
                ComboBox {
                    Layout.fillWidth: true
                    model: sharedEngine.layoutLabels
                    currentIndex: sharedEngine.layoutIndex
                    onActivated: sharedEngine.layoutIndex = index
                }
            }

            Item { Layout.preferredHeight: Theme.dp(48); Layout.fillWidth: true }
        }
    }

    OnScreenKeyboard {
        id: osk
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: window.oskVisible
        sharedEngine: sharedEngine
        candidateBarPlacement: "floating"
        hardwareInput: true
        systemWide: false
        onCloseRequested: window.oskVisible = false
    }
}
