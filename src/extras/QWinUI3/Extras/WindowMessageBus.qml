import QtQuick

// WindowMessageBus — Process-local typed channels between windows (2.72).
//
//   WindowMessageBus.post("theme", { dark: true })
//   WindowMessageBus.subscribe("theme", function (payload) { … })
//
// @notes
//   Same QGuiApplication only — not cross-process IPC.

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
        for (var i = 0; i < list.length; ++i) {
            var fn = list[i]
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
    }

    function clear(channel) {
        if (channel === undefined || channel === null || channel === "") {
            root._handlers = ({})
            return
        }
        delete root._handlers[String(channel)]
    }
}
