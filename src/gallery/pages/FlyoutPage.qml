import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Flyout.
//
// Lightweight contextual UI with title, isOpen / showAt(), and isLightDismissEnabled. API: docs/components/Flyout.md

CatalogPage {
    title: qsTr("Flyout")
    subtitle: qsTr("Lightweight contextual UI with title, isOpen / showAt(), and isLightDismissEnabled.")

    ControlExample {
        headerText: qsTr("A simple Flyout")
        qmlSource: "flyout.isOpen = true  // or showAt(btn)"

        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Placement"); color: Theme.textSecondary }
                ComboBox {
                    id: placeBox
                    model: [
                        { t: qsTr("Bottom"), v: Qt.AlignBottom },
                        { t: qsTr("Top"), v: Qt.AlignTop },
                        { t: qsTr("Left"), v: Qt.AlignLeft },
                        { t: qsTr("Right"), v: Qt.AlignRight }
                    ]
                    textRole: "t"
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
                CheckBox {
                    id: lightDismiss
                    text: qsTr("Light dismiss")
                    checked: true
                }
                CheckBox {
                    id: constrainBounds
                    text: qsTr("Constrain to bounds")
                    checked: true
                }
                ComboBox {
                    id: showModeBox
                    model: ["standard", "transient", "transientWithDismissOnPointerMoveAway"]
                    currentIndex: 0
                    Layout.preferredWidth: 220
                }
                Label {
                    text: flyout.isOpen ? qsTr("isOpen: true") : qsTr("isOpen: false")
                    color: Theme.textSecondary
                }
            }
            Button {
                id: flyoutBtn
                text: qsTr("Open flyout")
                onClicked: flyout.showAt(flyoutBtn, placeBox.model[placeBox.currentIndex].v)

                Flyout {
                    id: flyout
                    parent: flyoutBtn
                    title: qsTr("Quick tip")
                    subtitle: qsTr("Optional subtitle under the title.")
                    showMode: showModeBox.currentText
                    isLightDismissEnabled: lightDismiss.checked
                    shouldConstrainToRootBounds: constrainBounds.checked
                    Text {
                        text: qsTr("Flyout content")
                        color: Theme.textPrimary
                    }
                    Button {
                        text: qsTr("Hide")
                        highlighted: true
                        onClicked: flyout.hide()
                    }
                }
            }
        }
    }
}
