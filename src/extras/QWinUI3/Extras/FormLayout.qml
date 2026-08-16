import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// FormLayout — Vertical form stack that collects field errorMessage values.
//
//   FormLayout {
//       id: form
//       ValidationSummary { id: summary }
//       HeaderedTextBox { id: nameField; header: qsTr("Name") }
//       NumberBox { id: ageField; header: qsTr("Age") }
//       Button {
//           text: qsTr("Submit")
//           onClicked: {
//               nameField.errorMessage = nameField.text.length ? "" : qsTr("Required")
//               if (form.validate()) { /* ok */ }
//           }
//       }
//   }
//   // --- API ---
//   // methods: validate(), clearErrors(), collectErrors()
//   // form.validate()
//   // form.clearErrors()
//   // form.collectErrors()
//
// @notes
//   ColumnLayout wrapper for HeaderedTextBox / NumberBox / PasswordBox.
//   labelWidth is pushed to descendants that expose a labelWidth property
//   (use headerPlacement: "left" on fields).
//   validate() gathers non-empty errorMessage (and hasError) from descendants.
//   Pair with ValidationSummary for a page-level error list.

T.Control {
    id: root

    // Preferred label column width for left-header fields (applied to descendants)
    property real labelWidth: 140
    // Vertical spacing between fields
    property real fieldSpacing: Theme.spacingLoose
    // Collected error strings after validate() / collectErrors()
    property var errors: []
    // Default children / field slot
    default property alias contentData: body.data

    implicitWidth: Math.max(280, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    Accessible.role: Accessible.Form

    contentItem: ColumnLayout {
        id: body
        spacing: root.fieldSpacing
        width: root.availableWidth

        onChildrenChanged: Qt.callLater(root.applyLabelWidth)
    }

    onLabelWidthChanged: applyLabelWidth()
    Component.onCompleted: applyLabelWidth()

    // Push labelWidth onto descendant fields that expose the property
    function applyLabelWidth() {
        function walk(item) {
            if (!item)
                return
            if (item !== root && item.hasOwnProperty("labelWidth"))
                item.labelWidth = root.labelWidth
            var kids = item.children || []
            for (var i = 0; i < kids.length; ++i)
                walk(kids[i])
            if (item.contentChildren) {
                for (var j = 0; j < item.contentChildren.length; ++j)
                    walk(item.contentChildren[j])
            }
        }
        walk(body)
    }

    // Walk visual children for errorMessage / hasError
    function _gatherFromItem(item, out) {
        if (!item)
            return
        if (item !== root && item.hasOwnProperty("errorMessage")) {
            var msg = String(item.errorMessage || "")
            var bad = msg.length > 0
            if (!bad && item.hasOwnProperty("hasError") && item.hasError)
                bad = true
            if (bad) {
                if (!msg.length && item.hasOwnProperty("header") && item.header)
                    msg = String(item.header) + ": " + qsTr("Invalid")
                else if (!msg.length)
                    msg = qsTr("Invalid field")
                out.push(msg)
            }
        }
        var kids = item.children || []
        for (var i = 0; i < kids.length; ++i)
            _gatherFromItem(kids[i], out)
        if (item.contentChildren) {
            for (var j = 0; j < item.contentChildren.length; ++j)
                _gatherFromItem(item.contentChildren[j], out)
        }
    }

    // Return string[] of current field errors (does not mutate fields)
    function collectErrors() {
        var out = []
        _gatherFromItem(body, out)
        errors = out
        return out
    }

    // Refresh errors; returns true when there are none
    function validate() {
        return collectErrors().length === 0
    }

    // Clear errorMessage on descendant fields that expose it
    function clearErrors() {
        function clearItem(item) {
            if (!item)
                return
            if (item !== root && item.hasOwnProperty("errorMessage"))
                item.errorMessage = ""
            var kids = item.children || []
            for (var i = 0; i < kids.length; ++i)
                clearItem(kids[i])
        }
        clearItem(body)
        errors = []
    }
}
