pragma Singleton
import QtQuick

// TabViewDropHub — same-process registry so torn-out tabs can dock back.
//
// TabView registers on Completed; tear-out / drag-release asks hit(gx, gy).

QtObject {
    id: root

    property var _views: []

    function register(view) {
        if (!view)
            return
        var next = root._views.slice()
        if (next.indexOf(view) < 0)
            next.push(view)
        root._views = next
    }

    function unregister(view) {
        var next = []
        for (var i = 0; i < root._views.length; ++i) {
            if (root._views[i] && root._views[i] !== view)
                next.push(root._views[i])
        }
        root._views = next
    }

    function hit(gx, gy, except) {
        var list = root._views
        for (var i = list.length - 1; i >= 0; --i) {
            var v = list[i]
            if (!v || v === except)
                continue
            try {
                if (v.visible && typeof v.containsGlobal === "function"
                        && v.containsGlobal(gx, gy))
                    return v
            } catch (err) {
            }
        }
        return null
    }
}
