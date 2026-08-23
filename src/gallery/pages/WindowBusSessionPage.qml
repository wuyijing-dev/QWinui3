import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — WindowMessageBus + SessionTimeout (2.72).

CatalogPage {
    id: page
    title: qsTr("Window bus & session")
    subtitle: qsTr("Process-local WindowMessageBus + SessionTimeout idle signals (2.72).")

    property string lastBus: qsTr("(none)")
    property string sessionStatus: qsTr("Armed — poke to reset")

    Component.onCompleted: {
        WindowMessageBus.subscribe("gallery.demo", function (payload) {
            page.lastBus = JSON.stringify(payload)
        })
    }

    ControlExample {
        headerText: qsTr("WindowMessageBus")
        qmlSource: "WindowMessageBus.post(\"gallery.demo\", { n: 1 })"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Button {
                text: qsTr("Post demo message")
                onClicked: WindowMessageBus.post("gallery.demo", {
                    t: Date.now(),
                    note: qsTr("hello")
                })
            }
            Label {
                text: qsTr("Last payload: %1").arg(page.lastBus)
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("SessionTimeout (short demo)")
        qmlSource: "SessionTimeout { idleMs: 8000; warningMs: 3000 }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            SessionTimeout {
                id: session
                idleMs: 8000
                warningMs: 3000
                enabled: arm.checked
                onWarning: page.sessionStatus = qsTr("Warning — about to time out")
                onTimedOut: page.sessionStatus = qsTr("Timed out")
                onResumed: page.sessionStatus = qsTr("Resumed")
            }
            CheckBox {
                id: arm
                text: qsTr("Enable idle timer (8s / warn 3s)")
                checked: false
            }
            RowLayout {
                Button {
                    text: qsTr("Poke activity")
                    onClicked: {
                        session.poke()
                        page.sessionStatus = qsTr("Poked — timer reset")
                    }
                }
                Button {
                    text: qsTr("Reset")
                    onClicked: {
                        session.reset()
                        page.sessionStatus = qsTr("Reset")
                    }
                }
            }
            Label {
                text: page.sessionStatus
                color: Theme.textSecondary
                Layout.fillWidth: true
            }
        }
    }
}
