import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Wizard — Multi-step flow host (StepBar + content + Back/Next).
//
//   Wizard {
//       id: wizard
//       model: [
//           { title: qsTr("Account"), content: accountStep },
//           { title: qsTr("Review"), content: reviewStep }
//       ]
//       stepValidators: [function () { return emailField.acceptableInput }, null]
//       onFinished: { /* … */ }
//   }
//
//   // --- API ---
//   // currentIndex / stepCount / canGoBack / canGoNext / isLastStep
//   // methods: next(), previous(), goTo(index), finish(), cancel()
//   // signals: finished(), cancelled(), stepChanged(int)
//
// @notes
//   Per-step validation via stepValidators[i]() → bool (2.68 D3).
//   model entries: string title, or { title, description?, content|sourceComponent }.

T.Control {
    id: root

    property var model: []
    property int currentIndex: 0
    property alias selectedIndex: root.currentIndex
    // Array of functions returning bool; missing/null = always valid
    property var stepValidators: []
    property bool showStepBar: true
    property bool cancelVisible: true
    property string nextText: qsTr("Next")
    property string backText: qsTr("Back")
    property string finishText: qsTr("Finish")
    property string cancelText: qsTr("Cancel")
    // Default content when a step has no content / sourceComponent
    property Component defaultStepContent: null

    readonly property int stepCount: model ? model.length : 0
    readonly property bool canGoBack: currentIndex > 0
    readonly property bool isLastStep: stepCount > 0 && currentIndex >= stepCount - 1
    readonly property bool canGoNext: _stepValid(currentIndex)

    signal finished()
    signal cancelled()
    signal stepChanged(int index)

    implicitWidth: 480
    implicitHeight: 360
    padding: Theme.spacing
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Wizard")
    Accessible.description: stepCount > 0
                            ? qsTr("Step %1 of %2").arg(currentIndex + 1).arg(stepCount)
                            : ""

    function _titleOf(entry) {
        if (entry === undefined || entry === null)
            return ""
        if (typeof entry === "string")
            return entry
        if (entry.title !== undefined)
            return entry.title
        return String(entry)
    }

    function _stepTitles() {
        var out = []
        var m = model || []
        for (var i = 0; i < m.length; ++i)
            out.push(_titleOf(m[i]))
        return out
    }

    function _stepValid(index) {
        var validators = stepValidators || []
        if (index < 0 || index >= validators.length || !validators[index])
            return true
        try {
            return !!validators[index]()
        } catch (e) {
            return false
        }
    }

    function _entryContent(entry) {
        if (!entry || typeof entry !== "object")
            return null
        if (entry.content !== undefined)
            return entry.content
        if (entry.sourceComponent !== undefined)
            return entry.sourceComponent
        return null
    }

    function goTo(index) {
        if (index < 0 || index >= stepCount)
            return false
        if (index > currentIndex) {
            for (var i = currentIndex; i < index; ++i) {
                if (!_stepValid(i))
                    return false
            }
        }
        currentIndex = index
        stepChanged(index)
        return true
    }

    function next() {
        if (!canGoNext)
            return false
        if (isLastStep) {
            finish()
            return true
        }
        return goTo(currentIndex + 1)
    }

    function previous() {
        if (!canGoBack)
            return false
        return goTo(currentIndex - 1)
    }

    function finish() {
        if (!_stepValid(currentIndex))
            return false
        finished()
        return true
    }

    function cancel() {
        cancelled()
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        StepBar {
            id: stepBar
            visible: root.showStepBar && root.stepCount > 0
            Layout.fillWidth: true
            model: root._stepTitles()
            currentIndex: root.currentIndex
            isInteractive: true
            onStepActivated: function (index) {
                root.goTo(index)
            }
        }

        StackLayout {
            id: stepStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentIndex

            Repeater {
                model: root.stepCount
                Loader {
                    required property int index
                    active: true
                    sourceComponent: {
                        var entry = root.model[index]
                        var c = root._entryContent(entry)
                        return c || root.defaultStepContent
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Button {
                visible: root.cancelVisible
                text: root.cancelText
                onClicked: root.cancel()
            }
            Item { Layout.fillWidth: true }
            Button {
                text: root.backText
                enabled: root.canGoBack
                onClicked: root.previous()
            }
            AccentButton {
                text: root.isLastStep ? root.finishText : root.nextText
                enabled: root.canGoNext
                onClicked: root.next()
            }
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        radius: Theme.cornerCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}
