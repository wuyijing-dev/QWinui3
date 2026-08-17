import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — WebView2Host (stable 1.18). Recipe: docs/webview2.md

CatalogPage {
    id: page
    title: qsTr("WebView2")
    subtitle: qsTr("Stable Windows host (1.18). Lifecycle / clip / focus / Runtime — docs/webview2.md. Trust: docs/security-trust.md (1.64).")

    property url demoUrl: "https://www.microsoft.com/edge/webview"

    WebView2Host {
        id: probe
        width: 0
        height: 0
        visible: false
    }

    readonly property bool showHost: probe.available && probe.runtimeInstalled
    readonly property bool showMissingRuntime: probe.available && !probe.runtimeInstalled
    readonly property bool showNotBuilt: !probe.available
    property bool hostLoaderReady: false

    Component.onCompleted: Qt.callLater(function () {
        if (page && page.showHost)
            page.hostLoaderReady = true
    })

    ControlExample {
        headerText: qsTr("Trust boundary (1.64)")
        qmlSource: "// Gate source / navigate — host does not cancel nav\\n// docs/security-trust.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("WebView2Host does not enforce a navigation allowlist. Production apps must validate URLs before assigning source. User data lives under AppLocalDataLocation/WebView2Host. Full notes: docs/security-trust.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Integration recipe (1.18 stable)")
        qmlSource: "WebView2Host {\n    source: \"https://…\"\n    // clip ancestors for ScrollView\n    // docs/webview2.md\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("1) fetch_webview2.ps1 + QWINUI3_BUILD_WEBVIEW2=ON\n"
                           + "2) Install Evergreen WebView2 Runtime if runtimeInstalled is false\n"
                           + "3) Place WebView2Host in a clip:true host; geometry follows ScrollView via mapToScene\n"
                           + "4) Tab into the control to MoveFocus into the browser; destroy happens on page leave")
            }
        }
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
                    text: qsTr("Focus browser")
                    enabled: hostLoader.item && hostLoader.item.ready
                    onClicked: hostLoader.item.focusBrowser()
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
                    if (page.showNotBuilt)
                        return qsTr("WebView2Host not built. On Windows run scripts/fetch_webview2.ps1 and configure -DQWINUI3_BUILD_WEBVIEW2=ON.")
                    if (page.showMissingRuntime)
                        return qsTr("Runtime missing — install Evergreen WebView2, then Retry.")
                    if (hostLoader.item)
                        return (hostLoader.item.documentTitle || qsTr("(untitled)"))
                               + " — " + (hostLoader.item.statusMessage || "")
                               + (hostLoader.item.ready ? "" : qsTr(" (starting…)"))
                    return qsTr("Loading host…")
                }
            }

            ProgressBar {
                Layout.fillWidth: true
                visible: hostLoader.item && (hostLoader.item.loading || (!hostLoader.item.ready && page.showHost))
                indeterminate: true
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
                    active: page.showHost && page.hostLoaderReady
                    sourceComponent: webComp
                }

                EmptyState {
                    anchors.centerIn: parent
                    width: parent.width - 48
                    visible: page.showNotBuilt
                    title: qsTr("WebView2 not built")
                    message: qsTr("Requires Windows + NuGet SDK (scripts/fetch_webview2.ps1) and QWINUI3_BUILD_WEBVIEW2=ON.")
                    actionText: qsTr("Open in browser")
                    onActionClicked: Qt.openUrlExternally(page.demoUrl)
                }

                EmptyState {
                    anchors.centerIn: parent
                    width: parent.width - 48
                    visible: page.showMissingRuntime
                    title: qsTr("WebView2 Runtime missing")
                    message: qsTr("Install the Evergreen Runtime, then click Retry. Apps should mirror this EmptyState when runtimeInstalled is false.")
                    actionText: qsTr("Get Runtime")
                    secondaryActionText: qsTr("Retry")
                    onActionClicked: Qt.openUrlExternally(probe.runtimeDownloadUrl)
                    onSecondaryActionClicked: probe.refreshRuntimeProbe()
                }
            }
        }
    }

    Component {
        id: webComp
        WebView2Host {
            source: page.demoUrl
            Accessible.name: qsTr("Embedded web view")
            Accessible.description: statusMessage
        }
    }
}
