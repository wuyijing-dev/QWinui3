import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// Tiny find_package consumer (1.61) — docs/packaging-consumer.md Path C.

StandardWindow {
    id: window
    width: 480
    height: 280
    visible: true
    title: qsTr("find_package consumer")
    backdrop: WindowHelper.BackdropSolid

    header: PlatformTitleBar {
        targetWindow: window
        showCaptionButtons: window.showCaptionButtons
        TitleBar {
            anchors.fill: parent
            embedded: true
            dragWindow: window
            useSystemMove: true
            title: window.title
            subtitle: qsTr("QWinUI3Config.cmake sketch")
            symbol: FluentIcons.AllApps
            isPaneToggleButtonVisible: false
            isBackButtonVisible: false
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.spacing
        Label {
            text: qsTr("find_package(QWinUI3) OK")
            font.pixelSize: Theme.fontTitle
            color: Theme.textPrimary
        }
        Label {
            text: qsTr("Shared kit + Bootstrap — not a vcpkg/Conan port.")
            color: Theme.textSecondary
            wrapMode: Text.WordWrap
            width: 360
        }
    }
}
