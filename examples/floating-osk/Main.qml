import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Copy-ready floating OSK host (1.84). Recipe: docs/on-screen-keyboard.md
// Do not copy the Gallery tree. Keyman Core ships in the clone (third_party/keyman).

StandardWindow {
    id: window
    width: 560
    height: 420
    visible: true
    title: qsTr("Floating OSK example")
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "FloatingOskExample"

    OnScreenKeyboardWindow {
        id: oskWin
        // Windows: SendInput into the focused desktop app (default on this host).
        // Linux: supportsSystemWide is false — keyboard still floats, in-app only.
        systemWide: Qt.platform.os === "windows"
        keyboardSize: "default"
    }

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("examples/floating-osk · 1.84")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingSection
        spacing: Theme.spacing

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: qsTr("Host OnScreenKeyboardWindow in your app — not the Gallery. Open the floating keyboard, then click another window (Notepad) before tapping keys. Elevated / UWP / some games may ignore SendInput.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }

        RowLayout {
            Layout.fillWidth: true
            Button {
                text: qsTr("Open floating keyboard")
                highlighted: true
                onClicked: oskWin.openFloating()
            }
            Button {
                text: qsTr("Close")
                enabled: oskWin.visible
                onClicked: oskWin.closeFloating()
            }
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            color: Theme.textSecondary
            text: qsTr("systemWide: %1 · supportsSystemWide: %2")
                  .arg(oskWin.systemWide ? qsTr("on") : qsTr("off"))
                  .arg(oskWin.supportsSystemWide ? qsTr("yes") : qsTr("no"))
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: qsTr("In-app field (used when systemWide is off)")
        }

        Item { Layout.fillHeight: true }
    }
}
