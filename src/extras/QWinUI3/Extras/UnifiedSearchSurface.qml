import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// UnifiedSearchSurface — unify TitleBar search + Navigation pane search + custom middle search
//
// Usage (NavigationWindow):
//
// NavigationWindow {
//     id: win
//     isPaneSearchEnabled: true
//     paneSearchModel: [{ title: "Home", component: "HomePage" }]
//
//     UnifiedSearchSurface {
//         id: s
//         anchors.fill: parent
//         hostWindow: win
//         mode: UnifiedSearchSurface.Pane
//         searchModel: win.paneSearchModel
//         placeholderText: qsTr("Search photos")
//         panePlaceholderText: qsTr("Filter library")
//         onSearchTextEdited: (t) => model.filter(t)
//         onSearchActivated: (item) => open(item)
//     }
// }
//
// @notes
//   This component is an adapter: it routes host search signals into a single unified event stream.
//   Middle mode disables host built-in search and places a SearchBox into titleBarContent.

Item {
    id: root

    enum SearchSurfaceMode { Global, Pane, Middle }

    // Shell host: pass ShellWindow or NavigationWindow instance.
    property var hostWindow: null

    // Unified behavior mode.
    property SearchSurfaceMode mode: SearchSurfaceMode.Global

    // Suggestions / suggestions model (rows).
    property var searchModel: []

    // Placeholder for Global/TitleBar channel.
    property string placeholderText: qsTr("Search")

    // Placeholder for Pane channel.
    property string panePlaceholderText: qsTr("Search")

    // Placeholder for Middle channel SearchBox.
    property string middlePlaceholderText: qsTr("Search")

    // Search UI enabled.
    property bool enabled: true

    // Current query text (adapter-level).
    property string searchText: ""

    // --- API ---
    // Unified event stream:
    signal searchTextEdited(string text)
    signal searchActivated(var item)
    signal searchSubmitted(string query)

    // --- Internal ---
    SearchBoxRecipe {
        id: middleBox
        placeholderText: root.middlePlaceholderText
        model: root.searchModel

        onTextChanged: {
            if (!root.enabled)
                return
            root.searchText = middleBox.text
            root.searchTextEdited(root.searchText)
        }
        onAccepted: function (t) {
            if (!root.enabled)
                return
            root.searchActivated(t)
            root.searchSubmitted(t)
        }
        onSuggestionChosen: function (item) {
            if (!root.enabled)
                return
            root.searchActivated(item)
        }
        onCleared: function () {
            root.searchText = ""
            root.searchTextEdited("")
        }
    }

    // When in Middle mode we own titleBarContent and keep host search disabled.
    function _applyMiddleMode() {
        if (!root.hostWindow)
            return
        root.hostWindow.searchEnabled = false
        root.hostWindow.titleBarContent = middleBox
    }

    function _applyGlobalMode() {
        if (!root.hostWindow)
            return
        root.hostWindow.titleBarContent = null
        root.hostWindow.searchEnabled = true
        root.hostWindow.searchModel = root.searchModel
        root.hostWindow.searchPlaceholder = root.placeholderText
    }

    function _applyPaneMode() {
        if (!root.hostWindow)
            return
        root.hostWindow.titleBarContent = null
        root.hostWindow.searchEnabled = false
        root.hostWindow.isPaneSearchEnabled = true
        root.hostWindow.paneSearchModel = root.searchModel
        root.hostWindow.paneSearchPlaceholder = root.panePlaceholderText
    }

    function _syncHost() {
        if (!root.hostWindow)
            return
        root.searchText = ""
        switch (root.mode) {
        case SearchSurfaceMode.Global:
            _applyGlobalMode()
            break
        case SearchSurfaceMode.Pane:
            _applyPaneMode()
            break
        case SearchSurfaceMode.Middle:
            _applyMiddleMode()
            break
        default:
            _applyGlobalMode()
            break
        }
    }

    onModeChanged: Qt.callLater(_syncHost)
    Component.onCompleted: Qt.callLater(_syncHost)

    // Keep placeholders/model in sync while staying in the same mode.
    onSearchModelChanged: {
        if (!root.hostWindow)
            return
        if (root.mode === SearchSurfaceMode.Global)
            root.hostWindow.searchModel = root.searchModel
        else if (root.mode === SearchSurfaceMode.Pane)
            root.hostWindow.paneSearchModel = root.searchModel
    }

    onPlaceholderTextChanged: {
        if (root.hostWindow && root.mode === SearchSurfaceMode.Global)
            root.hostWindow.searchPlaceholder = root.placeholderText
    }

    onPanePlaceholderTextChanged: {
        if (root.hostWindow && root.mode === SearchSurfaceMode.Pane)
            root.hostWindow.paneSearchPlaceholder = root.panePlaceholderText
    }

    // Bridge host signals -> unified signals
    Connections {
        id: bridge
        target: root.hostWindow
        ignoreUnknownSignals: true

        function onSearchTextEdited(text) {
            if (!root.enabled)
                return
            if (root.mode !== SearchSurfaceMode.Global)
                return
            root.searchText = text
            root.searchTextEdited(text)
        }

        function onSearchActivated(item) {
            if (!root.enabled)
                return
            if (root.mode !== SearchSurfaceMode.Global)
                return
            root.searchActivated(item)
        }

        function onPaneSearchTextEdited(text) {
            if (!root.enabled)
                return
            if (root.mode !== SearchSurfaceMode.Pane)
                return
            root.searchText = text
            root.searchTextEdited(text)
        }

        function onPaneSearchActivated(text) {
            if (!root.enabled)
                return
            if (root.mode !== SearchSurfaceMode.Pane)
                return
            root.searchActivated(text)
            root.searchSubmitted(text)
        }
    }
}

