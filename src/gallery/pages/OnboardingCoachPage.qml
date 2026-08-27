import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — sequenced TeachingTip onboarding coach.
//
// One tip at a time → Next advances → Done / Esc ends.
// “Don’t show again” persists via QtCore Settings (Gallery org).
// Recipe: docs/feedback.md · docs/multi-window-onboarding.md · keyboard: docs/keyboard.md

CatalogPage {
    id: page
    title: qsTr("Onboarding coach")
    subtitle: qsTr("Sequenced TeachingTips + don’t-show-again — docs/feedback.md.")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    Settings {
        id: coachStore
        category: "OnboardingCoach"
        property bool dismissed: false
        // separate from WindowGeometry/* (multi-window apps)
        property bool mainTourDismissed: dismissed
    }

    property int stepIndex: -1
    property bool advancing: false
    property bool pendingFinish: false
    property string statusText: coachStore.dismissed
                                 ? qsTr("Coach suppressed (don’t show again). Reset to re-enable.")
                                 : qsTr("Ready — Start tour for a 3-step coach mark sequence.")

    readonly property var steps: [
        {
            title: qsTr("Welcome"),
            subtitle: qsTr("Step 1 of 3 — this tip anchors to the first control. Focus returns here when you dismiss."),
            placement: Qt.AlignBottom
        },
        {
            title: qsTr("Primary action"),
            subtitle: qsTr("Step 2 of 3 — only one TeachingTip is open at a time. Prefer Next over stacking tips."),
            placement: Qt.AlignBottom
        },
        {
            title: qsTr("You’re set"),
            subtitle: qsTr("Step 3 of 3 — check Don’t show again to persist via Settings, then Done."),
            placement: Qt.AlignTop
        }
    ]

    function targetForStep(i) {
        if (i === 0)
            return step1Btn
        if (i === 1)
            return step2Btn
        return step3Btn
    }

    function startTour() {
        if (tip.isOpen)
            tip.close()
        advancing = false
        pendingFinish = false
        dontShowAgain.checked = false
        page.statusText = qsTr("Tour running…")
        showStep(0)
    }

    function showStep(i) {
        if (i < 0 || i >= steps.length) {
            finishTour(dontShowAgain.checked)
            return
        }
        stepIndex = i
        var s = steps[i]
        var anchor = targetForStep(i)
        tip.target = anchor
        tip.title = s.title
        tip.subtitle = s.subtitle
        tip.preferredPlacement = s.placement
        tip.actionText = (i === steps.length - 1) ? qsTr("Done") : qsTr("Next")
        tip.symbol = FluentIcons.Lightbulb
        if (anchor && typeof anchor.forceActiveFocus === "function")
            anchor.forceActiveFocus()
        Qt.callLater(function () {
            tip.isOpen = true
        })
    }

    function finishTour(persistDismiss) {
        stepIndex = -1
        advancing = false
        pendingFinish = false
        if (tip.isOpen)
            tip.close()
        if (persistDismiss) {
            coachStore.dismissed = true
            page.statusText = qsTr("Tour finished — don’t show again saved.")
        } else {
            page.statusText = qsTr("Tour finished. Start tour again anytime (unless suppressed).")
        }
    }

    function resetPreference() {
        coachStore.dismissed = false
        dontShowAgain.checked = false
        page.statusText = qsTr("Preference cleared — Start tour to run again.")
    }

    ControlExample {
        headerText: qsTr("Multi-window apps")
        qmlSource: "// Defer tour until main ShellWindow visible\n// docs/multi-window-onboarding.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Run the coach on the primary shell only — after it is visible. Do not anchor tips to ToolShellWindow or mid-spawn owned dialogs. Persist mainTourDismissed in this Settings category, not geometryPersistenceKey. Z-order recipe: Gallery Multi-window.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Open Multi-window")
                onClicked: page.openComp("MultiWindowPage")
            }
        }
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// sequenced TeachingTip\n// Settings { dismissed }\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use a short TeachingTip sequence for first-run coach marks. Persist “don’t show again” with QtCore Settings (or your store). Not for confirms (ContentDialog) or durable page status (InfoBar) or transient acks (Toast). Focus: open tip → Close gets focus → dismiss returns focus to target — then advance to the next target.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("3-step coach tour")
        qmlSource: "TeachingTip { target: stepN }\nSettings { category: \"OnboardingCoach\" }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                AccentButton {
                    id: step1Btn
                    text: qsTr("1 · Welcome")
                    Accessible.name: qsTr("Welcome step target")
                    onClicked: page.statusText = qsTr("Welcome control activated.")
                }
                Button {
                    id: step2Btn
                    text: qsTr("2 · Primary")
                    Accessible.name: qsTr("Primary action step target")
                    onClicked: page.statusText = qsTr("Primary control activated.")
                }
                Button {
                    id: step3Btn
                    text: qsTr("3 · Finish")
                    Accessible.name: qsTr("Finish step target")
                    onClicked: page.statusText = qsTr("Finish control activated.")
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Start tour")
                    enabled: !tip.isOpen && page.stepIndex < 0
                    onClicked: page.startTour()
                }
                Button {
                    text: qsTr("Skip / end")
                    enabled: page.stepIndex >= 0 || tip.isOpen
                    onClicked: page.finishTour(dontShowAgain.checked)
                }
                Button {
                    text: qsTr("Reset don’t-show-again")
                    onClicked: page.resetPreference()
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: page.statusText
                color: Theme.textSecondary
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: coachStore.dismissed
                      ? qsTr("Stored: dismissed = true (auto-offer off).")
                      : qsTr("Stored: dismissed = false.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textTertiary
            }

            TeachingTip {
                id: tip
                preferredPlacement: Qt.AlignBottom
                isLightDismissEnabled: true
                tailVisibility: true

                CheckBox {
                    id: dontShowAgain
                    text: qsTr("Don’t show again")
                    Accessible.name: qsTr("Don’t show this coach again")
                }

                onActionClicked: {
                    page.advancing = true
                    if (page.stepIndex >= page.steps.length - 1)
                        page.pendingFinish = true
                }
                onClosed: {
                    if (page.advancing) {
                        page.advancing = false
                        if (page.pendingFinish) {
                            page.pendingFinish = false
                            page.finishTour(dontShowAgain.checked)
                        } else {
                            var next = page.stepIndex + 1
                            Qt.callLater(function () { page.showStep(next) })
                        }
                    } else if (page.stepIndex >= 0) {
                        // Esc / outside / Close — end tour; honor checkbox if set.
                        page.finishTour(dontShowAgain.checked)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (!coachStore.dismissed)
            page.statusText = qsTr("First-run coach available — press Start tour (3 steps).")
    }
}
