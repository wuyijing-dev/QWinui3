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
    subtitle: qsTr("Stable Windows host (1.18). Multi-exe safe user-data (per-pid). Field matrix + policy — docs/webview2.md.")

    property url demoUrl: "https://www.microsoft.com/edge/webview"
    property string navStatus: ""

    readonly property var allowedHosts: [
        "microsoft.com",
        "www.microsoft.com",
        "learn.microsoft.com"
    ]

    function _hostFromUrl(urlString) {
        var s = String(urlString)
        var m = s.match(/^https?:\/\/([^/?#]+)/i)
        if (!m)
            return ""
        return m[1].toLowerCase().replace(/^www\./, "")
    }

    function hostAllowed(urlString) {
        var host = page._hostFromUrl(urlString)
        if (!host.length)
            return false
        for (var i = 0; i < page.allowedHosts.length; ++i) {
            var h = String(page.allowedHosts[i]).toLowerCase()
            if (host === h || host.endsWith("." + h))
                return true
        }
        return false
    }

    function navigateSafe(urlString) {
        if (!page.hostAllowed(urlString)) {
            page.navStatus = qsTr("Blocked %1 — Gallery demo allowlist only (docs/security-trust.md Pattern C).")
                .arg(page._hostFromUrl(urlString) || urlString)
            return false
        }
        page.navStatus = ""
        page.demoUrl = urlString
        if (hostLoader.item)
            hostLoader.item.source = page.demoUrl
        return true
    }

    property bool _runtimeProbed: false
    property bool _runtimeInstalled: false

    // Capability-only host (0×0, invisible) — no runtime COM probe in ctor (2.85 S3).
    WebView2Host {
        id: cap
        width: 0
        height: 0
        visible: false
    }

    readonly property bool showNotBuilt: !cap.available
    readonly property bool runtimeInstalled: _runtimeInstalled
    readonly property bool showHost: cap.available && _runtimeInstalled
    readonly property bool showMissingRuntime: cap.available && _runtimeProbed && !_runtimeInstalled
    property bool hostLoaderReady: false

    function probeRuntime() {
        if (_runtimeProbed)
            return
        _runtimeProbed = true
        _runtimeInstalled = cap.checkRuntimeInstalled()
        if (showHost)
            hostLoaderReady = true
    }

    function refreshRuntimeProbe() {
        _runtimeInstalled = cap.checkRuntimeInstalled()
        _runtimeProbed = true
        if (showHost)
            hostLoaderReady = true
    }

    Timer {
        interval: 1
        running: true
        repeat: false
        onTriggered: {
            page.probeRuntime()
            if (page.showHost)
                page.hostLoaderReady = true
        }
    }

    ControlExample {
        headerText: qsTr("Field matrix (2.32)")
        qmlSource: "// docs/webview2.md — SDK / Runtime / clip / DPI\n// Smoke compiles page; no HWND in CI"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Built + Runtime → ready host. SDK only → EmptyState + Retry. Not built / Linux → available false. ScrollView hosts need clip:true. Navigation: Pattern A/B/C below — host never cancels in-page links.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Trust boundary (2.13 / 2.32)")
        qmlSource: "// Pattern C host allowlist — docs/security-trust.md\\nfunction navigateSafe(url) { … }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("WebView2Host does not enforce navigation policy. This page gates the URL field with an allowlist (Microsoft hosts only). User data: AppLocalDataLocation/WebView2Host. Patterns A–C: docs/security-trust.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Download policy (2.36)")
        qmlSource: "// Policy D — tight allowlist\\n// Policy E — Qt.openUrlExternally after hostAllowed\\n// docs/security-trust.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("WebView2Host does not intercept DownloadStarting. Policy D: this page’s host allowlist blocks most drive-by download hosts. Policy E: use explicit buttons + hostAllowed before Qt.openUrlExternally. Policy F: native handler + AppDataLocation — not in the kit.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
                text: qsTr("Open externally still requires the same host check as Navigate — do not bypass allowlist for downloads.")
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
                    onAccepted: page.navigateSafe(text)
                }
                AccentButton {
                    text: qsTr("Go")
                    onClicked: {
                        if (!page.navigateSafe(urlField.text))
                            page.navStatus = qsTr("Navigation blocked — allowlist only (2.36 Policy E).")
                    }
                }
                Button {
                    text: qsTr("Focus browser")
                    enabled: hostLoader.item && hostLoader.item.ready
                    onClicked: hostLoader.item.focusBrowser()
                }
                Button {
                    text: qsTr("Open externally")
                    onClicked: {
                        if (page.hostAllowed(urlField.text))
                            Qt.openUrlExternally(urlField.text)
                        else
                            page.navStatus = qsTr("Blocked external open — allowlist only (2.36 Policy E).")
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                visible: page.navStatus.length > 0
                color: Theme.systemCritical
                text: page.navStatus
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
                    onActionClicked: Qt.openUrlExternally(cap.runtimeDownloadUrl)
                    onSecondaryActionClicked: page.refreshRuntimeProbe()
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
