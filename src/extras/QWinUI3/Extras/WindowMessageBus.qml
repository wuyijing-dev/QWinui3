import QtQuick

// WindowMessageBus — Process-local typed channels between windows (2.72).
//
//   WindowMessageBus.post("theme", { dark: true })
//   WindowMessageBus.subscribe("theme", function (payload) { … })
//
// @notes
//   Same QGuiApplication only — not cross-process IPC.
//   post() snapshots the handler list so unsubscribe during delivery is safe.

pragma Singleton

QtObject {
    id: root

    property var _handlers: ({})

    function post(channel, payload) {
        var key = String(channel || "")
        if (!key.length)
            return
        var list = root._handlers[key]
        if (!list || !list.length)
            return
        // Copy — handlers may unsubscribe (or subscribe) while we deliver.
        var snapshot = list.slice()
        for (var i = 0; i < snapshot.length; ++i) {
            var fn = snapshot[i]
            if (typeof fn === "function")
                fn(payload)
        }
    }

    function subscribe(channel, handler) {
        var key = String(channel || "")
        if (!key.length || typeof handler !== "function")
            return function () {}
        if (!root._handlers[key])
            root._handlers[key] = []
        root._handlers[key].push(handler)
        return function () { root.unsubscribe(key, handler) }
    }

    function unsubscribe(channel, handler) {
        var key = String(channel || "")
        var list = root._handlers[key]
        if (!list)
            return
        for (var i = list.length - 1; i >= 0; --i) {
            if (list[i] === handler)
                list.splice(i, 1)
        }
        if (!list.length)
            delete root._handlers[key]
    }

    function clear(channel) {
        if (channel === undefined || channel === null || channel === "") {
            root._handlers = ({})
            return
        }
        delete root._handlers[String(channel)]
    }
}
