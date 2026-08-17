import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// FormLayout — Vertical form stack that collects field errorMessage values.
//
//   FormLayout {
//       id: form
//       labelWidth: 140
//       fieldHeaderPlacement: "left"
//       ValidationSummary { errors: form.errors }
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
//   // methods: validate(), validateDeferred(), beginValidate(), endValidate(),
//   //           clearErrors(), collectErrors(), focusFirstError(), applyDefaults(), applyLabelWidth()
//
// @notes
//   ColumnLayout host for HeaderedTextBox / HeaderedComboBox / NumberBox / PasswordBox /
//   RadioButtons / TokenizingTextBox / DetailRow.
//   Pushes labelWidth (+ optional fieldHeaderPlacement) onto children — fields do not
//   walk parents. Set formBound: false on a field to opt out.
//   Apps set field.errorMessage, then validate() / collectErrors() read descendants
//   (children + contentChildren). clearErrors() clears the same tree.
//   Pair with ValidationSummary. See docs/forms.md.
//   Accessibility (1.19): Accessible.Form + accessibleName; description lists error count.

T.Control {
    id: root

    Layout.fillWidth: true

    // Preferred label column width for left-header fields
    property real labelWidth: 140
    // Default headerPlacement pushed to formBound fields ("left"|"top"; empty = leave field)
    property string fieldHeaderPlacement: ""
    // Vertical spacing between fields
    property real fieldSpacing: Theme.spacingLoose
    // Collected error strings after validate() / collectErrors()
    property var errors: []
    // True while async validation runs (2.55 — pair with beginValidate/endValidate)
    property bool validating: false
    // Screen-reader name for the form region (1.19)
    property string accessibleName: qsTr("Form")
    // Default children / field slot
    default property alias contentData: body.data

    implicitWidth: Math.max(280, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    padding: 0
    Accessible.role: Accessible.Form
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Form")
    Accessible.description: errors && errors.length
                            ? qsTr("%1 validation errors").arg(errors.length)
                            : ""

    onLabelWidthChanged: Qt.callLater(function () { root.applyDefaults() })
    onFieldHeaderPlacementChanged: Qt.callLater(function () { root.applyDefaults() })

    contentItem: ColumnLayout {
        id: body
        spacing: root.fieldSpacing
        width: root.availableWidth
        onChildrenChanged: Qt.callLater(function () { root.applyDefaults() })
        Component.onCompleted: root.applyDefaults()
    }

    // Push labelWidth / fieldHeaderPlacement onto formBound descendants
    function applyDefaults() {
        _applyToItem(body)
    }

    // Compat alias of applyDefaults()
    function applyLabelWidth() {
        applyDefaults()
    }

    function _applyToItem(item) {
        if (!item || item === root)
            return
        var skip = item.formBound === false
        if (!skip) {
            if (item.hasOwnProperty("labelWidth"))
                item.labelWidth = root.labelWidth
            if (root.fieldHeaderPlacement.length && item.hasOwnProperty("headerPlacement"))
                item.headerPlacement = root.fieldHeaderPlacement
        }
        var kids = item.children || []
        for (var i = 0; i < kids.length; ++i)
            _applyToItem(kids[i])
        if (item.contentChildren) {
            for (var j = 0; j < item.contentChildren.length; ++j)
                _applyToItem(item.contentChildren[j])
        }
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

    // Clear errorMessage on descendant fields that expose it (+ NumberBox inputInvalid, 2.55)
    function clearErrors() {
        function clearItem(item) {
            if (!item)
                return
            if (item !== root) {
                if (item.hasOwnProperty("errorMessage"))
                    item.errorMessage = ""
                if (item.hasOwnProperty("inputInvalid"))
                    item.inputInvalid = false
            }
            var kids = item.children || []
            for (var i = 0; i < kids.length; ++i)
                clearItem(kids[i])
            if (item.contentChildren) {
                for (var j = 0; j < item.contentChildren.length; ++j)
                    clearItem(item.contentChildren[j])
            }
        }
        clearItem(body)
        errors = []
    }

    // Mark validating before async rules; pair with endValidate()
    function beginValidate() {
        validating = true
        clearErrors()
    }

    // Collect errors after async rules; clears validating and returns validate() result
    function endValidate() {
        var ok = validate()
        validating = false
        return ok
    }

    // Defer validate() to next event-loop tick (rules set in same handler)
    function validateDeferred(callback) {
        Qt.callLater(function () {
            var ok = validate()
            if (callback)
                callback(ok)
        })
    }

    // Focus first descendant field with an error (WinUI focus-first-error, 2.55)
    function focusFirstError() {
        var target = _firstErrorItem(body)
        if (!target)
            return false
        if (typeof target.focusField === "function")
            target.focusField()
        else if (typeof target.forceActiveFocus === "function")
            target.forceActiveFocus()
        return true
    }

    function _firstErrorItem(item) {
        if (!item)
            return null
        if (item !== root && item.hasOwnProperty("errorMessage")) {
            var msg = String(item.errorMessage || "")
            var bad = msg.length > 0
            if (!bad && item.hasOwnProperty("hasError") && item.hasError)
                bad = true
            if (bad)
                return item
        }
        var kids = item.children || []
        for (var i = 0; i < kids.length; ++i) {
            var hit = _firstErrorItem(kids[i])
            if (hit)
                return hit
        }
        if (item.contentChildren) {
            for (var j = 0; j < item.contentChildren.length; ++j) {
                var hit2 = _firstErrorItem(item.contentChildren[j])
                if (hit2)
                    return hit2
            }
        }
        return null
    }
}
