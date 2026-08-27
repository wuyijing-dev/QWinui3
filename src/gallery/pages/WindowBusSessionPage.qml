import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — WindowMessageBus + SessionTimeout.

CatalogPage {
    id: page
    title: qsTr("Window bus & session")
    subtitle: qsTr("Process-local WindowMessageBus + SessionTimeout idle signals.")

    property string lastBus: qsTr("(none)")
    property string sessionStatus: qsTr("Armed — poke to reset")
    property var _busUnsub: null

    Component.onCompleted: {
        page._busUnsub = WindowMessageBus.subscribe("gallery.demo", function (payload) {
            if (page)
                page.lastBus = JSON.stringify(payload)
        })
    }
    Component.onDestruction: {
        if (typeof page._busUnsub === "function")
            page._busUnsub()
        page._busUnsub = null
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
                        + (arm.checked
                           ? qsTr(" · remaining %1s").arg(Math.ceil(session.remainingMs / 1000))
                           : "")
                color: Theme.textSecondary
                Layout.fillWidth: true
            }
        }
    }
}
