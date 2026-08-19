import QtQuick

// MenuFlyoutSnapshotModel — Freeze dynamic menu label values at open time.
//
// @notes
//   QML property bindings on MenuFlyoutItem.text are hard to “freeze” generically.
//   Instead, this snapshot model exposes a frozen array that apps can feed
//   into menu items (e.g. via Repeater) when the menu opens.

QtObject {
    id: root

    // Source rows. Typically an Array of items like:
    //   [{ id: 1, title: "Copy", payload: {...} }, ...]
    property var source: []

    // Optional mapping function: (row) => string
    property var textFn: null

    // Optional mapping function: (row) => var (for payload)
    property var payloadFn: null

    // Last frozen snapshot rows (deep-ish copy).
    property var frozen: []

    function freeze() {
        var src = root.source || []
        var out = []
        for (var i = 0; i < src.length; ++i) {
            var row = src[i]
            if (row === undefined || row === null)
                continue
            var text = ""
            if (typeof root.textFn === "function")
                text = String(root.textFn(row))
            else if (row.text !== undefined)
                text = String(row.text)
            else if (row.title !== undefined)
                text = String(row.title)
            else
                text = String(row)

            var payload = row
            if (typeof root.payloadFn === "function")
                payload = root.payloadFn(row)

            out.push({ text: text, payload: payload })
        }
        root.frozen = out
        return out
    }
}

