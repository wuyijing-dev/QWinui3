pragma Singleton
import QtQuick
import QtCore

// Item root: Settings cannot be a child of QtObject (no default property).
Item {
    id: root

    property var recentIds: []
    property var favoriteIds: []
    readonly property int maxRecent: 12

    Settings {
        id: store
        category: "GalleryHistory"
        property string recent: "[]"
        property string favorites: "[]"
    }

    Component.onCompleted: {
        recentIds = parseList(store.recent)
        favoriteIds = parseList(store.favorites)
    }

    function parseList(text) {
        try {
            var v = JSON.parse(text || "[]")
            return Array.isArray(v) ? v : []
        } catch (e) {
            return []
        }
    }

    function persist() {
        store.recent = JSON.stringify(recentIds)
        store.favorites = JSON.stringify(favoriteIds)
    }

    function recordVisit(component) {
        if (!component || component === "HomePage" || component === "SettingsPage")
            return
        var next = recentIds.filter(function (c) { return c !== component })
        next.unshift(component)
        if (next.length > maxRecent)
            next = next.slice(0, maxRecent)
        recentIds = next
        persist()
    }

    function isFavorite(component) {
        return favoriteIds.indexOf(component) >= 0
    }

    function toggleFavorite(component) {
        if (!component)
            return false
        var next = favoriteIds.slice()
        var i = next.indexOf(component)
        if (i >= 0)
            next.splice(i, 1)
        else
            next.unshift(component)
        favoriteIds = next
        persist()
        return isFavorite(component)
    }

    function resolveControls(ids) {
        var out = []
        for (var i = 0; i < ids.length; ++i) {
            var item = ControlCatalog.findByComponent(ids[i])
            if (item)
                out.push(item)
        }
        return out
    }

    function recentControls() {
        var list = resolveControls(recentIds)
        if (list.length)
            return list
        return ControlCatalog.ensureControls().filter(function (c) {
            return ["ButtonPage", "ToggleButtonPage", "NavigationViewPage",
                    "InfoBarPage", "TabViewPage", "AcrylicSurfacePage"].indexOf(c.component) >= 0
        })
    }

    function favoriteControls() {
        return resolveControls(favoriteIds)
    }
}
