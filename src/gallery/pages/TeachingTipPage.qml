import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TeachingTip.
//
// Contextual tip with symbol, ElevatedChrome, and AccentButton action.
// Recipe: docs/feedback.md · dialogs: docs/dialogs-flyouts.md

CatalogPage {
    title: qsTr("TeachingTip")
    subtitle: qsTr("Coach mark; focus returns to target on close. Recipe: docs/feedback.md.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// TeachingTip — coach mark\n// OnboardingCoachPage — sequence\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("TeachingTip is for first-run coaching, not confirms. Closing returns focus to the target control. For multi-step tours + don’t-show-again persistence, open the Onboarding coach recipe.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Open Onboarding coach")
                onClicked: openComp("OnboardingCoachPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("A simple TeachingTip")
        qmlSource: "TeachingTip {\n    symbol: FluentIcons.Info\n    target: tipTarget\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Button {
                id: tipTarget
                text: qsTr("Show teaching tip")
                onClicked: {
                    tip.shouldConstrainToRootBounds = constrainBounds.checked
                    tip.isOpen = true
                }
            }

            Label {
                id: tipStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }

            TeachingTip {
                id: tip
                target: tipTarget
                preferredPlacement: Qt.AlignTop
                placementMargin: 16
                tailVisibility: true
                symbol: FluentIcons.Info
                title: qsTr("Quick tip")
                subtitle: qsTr("TeachingTip can place above, below, left, or right of the target.")
                actionButton: Button {
                    text: qsTr("Custom ActionButton")
                    onClicked: {
                        tipStatus.text = qsTr("Custom ActionButton clicked")
                        tip.close()
                    }
                }
                closeButtonContent: qsTr("Dismiss")
                onActionClicked: tipTarget.text = qsTr("Tip dismissed")
                onCloseButtonClicked: tipStatus.text = qsTr("Close button clicked")
                onClosedByUser: tipStatus.text = qsTr("Closed by user")

                heroContent: Rectangle {
                    width: tip.width - 24
                    height: 80
                    radius: Theme.cornerControl
                    gradient: Gradient {
                        GradientStop { position: 0; color: Theme.accent }
                        GradientStop { position: 1; color: Theme.accentDark1 }
                    }
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Hero content")
                        color: Theme.textOnAccent
                        font.weight: Theme.fontWeightSemiBold
                    }
                }
                Label {
                    text: qsTr("Optional Content slot below the subtitle.")
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                    width: tip.width - 24
                }
            }

            RowLayout {
                spacing: Theme.spacing
                CheckBox {
                    id: constrainBounds
                    text: qsTr("ShouldConstrainToRootBounds")
                    checked: true
                }
                Button {
                    text: qsTr("Below")
                    onClicked: {
                        tip.preferredPlacement = Qt.AlignBottom
                        tip.tailVisibility = true
                        tip.shouldConstrainToRootBounds = constrainBounds.checked
                        tip.isOpen = true
                    }
                }
                Button {
                    text: qsTr("Right")
                    onClicked: {
                        tip.preferredPlacement = Qt.AlignRight
                        tip.tailVisibility = true
                        tip.shouldConstrainToRootBounds = constrainBounds.checked
                        tip.isOpen = true
                    }
                }
                Button {
                    text: qsTr("No tail")
                    onClicked: {
                        tip.tailVisibility = false
                        tip.shouldConstrainToRootBounds = constrainBounds.checked
                        tip.isOpen = true
                    }
                }
            }
        }
    }
}
