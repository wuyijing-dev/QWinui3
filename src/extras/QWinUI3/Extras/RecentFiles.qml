import QtQuick
import QtCore
import QWinUI3.Platform

// RecentFiles — Persist recent paths in Settings + shell recent docs (2.77).
//
//   RecentFiles {
//       id: recent
//       maxCount: 12
//       category: "RecentFiles"
//   }
//   recent.add("/path/to/file")
//   recent.list()  // string array
//   recent.clear()
//
// @notes
//   Paths stored under Settings; add() also calls WindowHelper.addToRecentDocuments.

QtObject {
    id: root

    property string category: "RecentFiles"
    property int maxCount: 12
    property bool notifyShell: true

    signal changed()

    Settings {
        id: store
        category: root.category
        property string pathsJson: "[]"
    }

    function list() {
        try {
            var arr = JSON.parse(store.pathsJson || "[]")
            return Array.isArray(arr) ? arr : []
        } catch (e) {
            return []
        }
    }

    function add(path) {
        var p = String(path || "").trim()
        if (!p.length)
            return
        var items = list().filter(function (x) { return x !== p })
        items.unshift(p)
        if (items.length > maxCount)
            items = items.slice(0, maxCount)
        store.pathsJson = JSON.stringify(items)
        if (notifyShell)
            WindowHelper.addToRecentDocuments(p)
        changed()
    }

    function clear() {
        store.pathsJson = "[]"
        if (notifyShell)
            WindowHelper.clearRecentDocuments()
        changed()
    }

    function remove(path) {
        var p = String(path || "")
        var items = list().filter(function (x) { return x !== p })
        store.pathsJson = JSON.stringify(items)
        changed()
    }
}
