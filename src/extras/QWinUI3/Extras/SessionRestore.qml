import QtQuick
import QtCore
import QWinUI3.Platform

// SessionRestore — Persist window geometry + nav page + table scroll/selection (2.70 D8).
//
//   SessionRestore {
//       id: session
//       category: "MyAppSession"
//       window: mainWindow
//       navigationView: nav
//       dataTable: table
//   }
//   Component.onCompleted: session.restore()
//   Component.onDestruction: session.save()
//
//   // --- API ---
//   // methods: save(), restore(), clear()
//   // properties: category, window, navigationView, dataTable, enabled
//
// @notes
//   Geometry still uses WindowHelper when window.geometryPersistenceKey is set;
//   this type stores nav currentKey + DataTable selectedIndex / contentY.

QtObject {
    id: root

    property string category: "SessionRestore"
    property var window: null
    property var navigationView: null
    property var dataTable: null
    property bool enabled: true

    Settings {
        id: store
        category: root.category
        property string navKey: ""
        property int tableIndex: -1
        property real tableContentY: 0
    }

    function save() {
        if (!enabled)
            return
        if (window && window.geometryPersistenceEnabled && typeof window.saveGeometry === "function")
            window.saveGeometry()
        else if (window && window.geometryPersistenceKey && window.geometryPersistenceKey.length)
            WindowHelper.saveWindowGeometry(window, window.geometryPersistenceKey)

        if (navigationView && navigationView.currentKey !== undefined)
            store.navKey = String(navigationView.currentKey || "")
        if (dataTable) {
            store.tableIndex = dataTable.selectedIndex !== undefined ? dataTable.selectedIndex : -1
            if (dataTable.contentItem && dataTable.contentItem.contentY !== undefined)
                store.tableContentY = dataTable.contentItem.contentY
        }
    }

    function restore() {
        if (!enabled)
            return false
        var ok = false
        if (window && window.geometryPersistenceEnabled && typeof window.restoreGeometry === "function")
            ok = !!window.restoreGeometry()
        else if (window && window.geometryPersistenceKey && window.geometryPersistenceKey.length)
            ok = !!WindowHelper.restoreWindowGeometry(window, window.geometryPersistenceKey)

        if (navigationView && store.navKey.length) {
            if (typeof navigationView.selectKey === "function")
                navigationView.selectKey(store.navKey, "none")
            ok = true
        }
        if (dataTable) {
            Qt.callLater(function () {
                if (store.tableIndex >= 0 && typeof dataTable.select === "function")
                    dataTable.select(store.tableIndex)
                if (dataTable.contentItem && store.tableContentY > 0)
                    dataTable.contentItem.contentY = store.tableContentY
            })
            ok = true
        }
        return ok
    }

    function clear() {
        store.navKey = ""
        store.tableIndex = -1
        store.tableContentY = 0
        if (window && typeof window.clearGeometry === "function")
            window.clearGeometry()
        else if (window && window.geometryPersistenceKey && window.geometryPersistenceKey.length)
            WindowHelper.clearWindowGeometry(window.geometryPersistenceKey)
    }
}
