import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — WebView2Host (Windows + Edge WebView2 Runtime).

CatalogPage {
    id: page
    title: qsTr("WebView2")
    subtitle: qsTr("HWND-backed Edge WebView2 under QQuickItem. Optional: QWINUI3_BUILD_WEBVIEW2 + fetch_webview2.ps1.")

    property url demoUrl: "https://www.microsoft.com/edge/webview"

    // Probe compile-time availability (instance CONSTANT mirrors QWINUI3_HAS_WEBVIEW2).
    WebView2Host {
        id: probe
        width: 0
        height: 0
        visible: false
    }

    ControlExample {
        headerText: qsTr("Embedded browser")
        qmlSource: "WebView2Host {\n    source: \"https://…\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Back")
                    enabled: hostLoader.item && hostLoader.item.canGoBack
                    onClicked: hostLoader.item.goBack()
                }
                Button {
                    text: qsTr("Forward")
                    enabled: hostLoader.item && hostLoader.item.canGoForward
                    onClicked: hostLoader.item.goForward()
                }
                Button {
                    text: qsTr("Reload")
                    enabled: !!hostLoader.item
                    onClicked: hostLoader.item.reload()
                }
                TextField {
                    id: urlField
                    Layout.fillWidth: true
                    text: page.demoUrl
                    onAccepted: {
                        page.demoUrl = text
                        if (hostLoader.item)
                            hostLoader.item.source = page.demoUrl
                    }
                }
                AccentButton {
                    text: qsTr("Go")
                    onClicked: {
                        page.demoUrl = urlField.text
                        if (hostLoader.item)
                            hostLoader.item.source = page.demoUrl
                        else
                            Qt.openUrlExternally(page.demoUrl)
                    }
                }
                Button {
                    text: qsTr("Open externally")
                    onClicked: Qt.openUrlExternally(urlField.text)
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: {
                    if (!probe.available)
                        return qsTr("WebView2Host not built. On Windows run scripts/fetch_webview2.ps1 and configure -DQWINUI3_BUILD_WEBVIEW2=ON.")
                    if (hostLoader.item)
                        return (hostLoader.item.documentTitle || qsTr("(untitled)"))
                               + " — " + (hostLoader.item.statusMessage || "")
                    return qsTr("Loading host…")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 420
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                clip: true

                Loader {
                    id: hostLoader
                    anchors.fill: parent
                    anchors.margins: 1
                    active: probe.available
                    sourceComponent: webComp
                }

                EmptyState {
                    anchors.centerIn: parent
                    width: parent.width - 48
                    visible: !probe.available
                    title: qsTr("WebView2 unavailable")
                    message: qsTr("Requires Windows, Edge WebView2 Runtime, and the NuGet SDK (scripts/fetch_webview2.ps1).")
                    actionText: qsTr("Open in browser")
                    onActionClicked: Qt.openUrlExternally(page.demoUrl)
                }
            }
        }
    }

    Component {
        id: webComp
        WebView2Host {
            source: page.demoUrl
        }
    }
}
