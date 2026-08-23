import QtQuick

// CommandRegistry — Scoped command store for CommandPalette auto-discovery.
//
//   CommandRegistry {
//       id: registry
//       Component.onCompleted: {
//           register({ id: "settings", title: qsTr("Settings"),
//                      scope: "global", action: openSettings })
//       }
//   }
//   CommandPalette { registry: registry }
//
//   // --- API ---
//   // scopes: global | window | page | focused
//   // methods: register(cmd), unregister(id), clearScope(scope),
//   //          commandsForPalette(), dispatch(id), setFocusedScope(id)
//   // signals: commandsChanged(), commandDispatched(var)
//
// @notes
//   Dispatch order for palette merge: focused → page → window → global (2.68 D4).
//   Later register() with the same id replaces the prior entry.

QtObject {
    id: root

    property string focusedScopeId: ""
    property string pageScopeId: ""
    property string windowScopeId: ""

    property var _byId: ({})
    property var _order: []

    signal commandsChanged()
    signal commandDispatched(var command)

    function _normalizeScope(scope) {
        var s = String(scope || "global").toLowerCase()
        if (s === "window" || s === "page" || s === "focused")
            return s
        return "global"
    }

    function register(cmd) {
        if (!cmd || typeof cmd !== "object")
            return false
        var id = cmd.id !== undefined ? String(cmd.id) : ""
        if (!id.length && cmd.title !== undefined)
            id = String(cmd.title)
        if (!id.length)
            return false
        var entry = {
            id: id,
            title: cmd.title !== undefined ? cmd.title : id,
            subtitle: cmd.subtitle,
            shortcut: cmd.shortcut,
            symbol: cmd.symbol,
            keywords: cmd.keywords,
            scope: _normalizeScope(cmd.scope),
            scopeId: cmd.scopeId !== undefined ? String(cmd.scopeId) : "",
            action: cmd.action,
            onTriggered: cmd.onTriggered
        }
        var map = Object.assign({}, root._byId)
        var order = root._order.slice()
        if (!map[id])
            order.push(id)
        map[id] = entry
        root._byId = map
        root._order = order
        commandsChanged()
        return true
    }

    function unregister(id) {
        var key = String(id || "")
        if (!key.length || !root._byId[key])
            return false
        var map = Object.assign({}, root._byId)
        delete map[key]
        var order = root._order.filter(function (x) { return x !== key })
        root._byId = map
        root._order = order
        commandsChanged()
        return true
    }

    function clearScope(scope) {
        var s = _normalizeScope(scope)
        var map = Object.assign({}, root._byId)
        var order = []
        for (var i = 0; i < root._order.length; ++i) {
            var id = root._order[i]
            var cmd = map[id]
            if (cmd && cmd.scope === s)
                delete map[id]
            else if (cmd)
                order.push(id)
        }
        root._byId = map
        root._order = order
        commandsChanged()
    }

    function setFocusedScope(id) {
        focusedScopeId = id !== undefined ? String(id) : ""
        commandsChanged()
    }

    function setPageScope(id) {
        pageScopeId = id !== undefined ? String(id) : ""
        commandsChanged()
    }

    function setWindowScope(id) {
        windowScopeId = id !== undefined ? String(id) : ""
        commandsChanged()
    }

    function _scopeActive(cmd) {
        if (!cmd)
            return false
        if (cmd.scope === "focused")
            return !cmd.scopeId.length || cmd.scopeId === focusedScopeId
        if (cmd.scope === "page")
            return !cmd.scopeId.length || cmd.scopeId === pageScopeId
        if (cmd.scope === "window")
            return !cmd.scopeId.length || cmd.scopeId === windowScopeId
        return true
    }

    function _scopeRank(scope) {
        if (scope === "focused")
            return 0
        if (scope === "page")
            return 1
        if (scope === "window")
            return 2
        return 3
    }

    // Commands visible to CommandPalette (highest-priority scope first)
    function commandsForPalette() {
        var rows = []
        for (var i = 0; i < root._order.length; ++i) {
            var cmd = root._byId[root._order[i]]
            if (cmd && _scopeActive(cmd))
                rows.push(cmd)
        }
        rows.sort(function (a, b) {
            return _scopeRank(a.scope) - _scopeRank(b.scope)
        })
        return rows
    }

    function dispatch(id) {
        var key = String(id || "")
        var cmd = root._byId[key]
        if (!cmd || !_scopeActive(cmd))
            return false
        if (typeof cmd.action === "function")
            cmd.action()
        else if (typeof cmd.onTriggered === "function")
            cmd.onTriggered()
        commandDispatched(cmd)
        return true
    }

    function commandCount() {
        return root._order.length
    }
}
