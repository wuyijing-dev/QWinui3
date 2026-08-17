import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AnnotatedScrollBar.
//
// Scrollbar thumb label bubble using ElevatedChrome (no corner flicker). API: docs/components/AnnotatedScrollBar.md

CatalogPage {
    title: qsTr("AnnotatedScrollBar")
    subtitle: qsTr("Percentage, chapter labels, and IME composition scroll hint (2.58).")

    ControlExample {
        headerText: qsTr("Percentage labels")
        qmlSource: "AnnotatedScrollBar {\n    id: scroll\n    anchors.fill: parent\n    labelFormat: \"%1%\"\n    Column {\n        width: scroll.flickable.width\n        Repeater {\n            model: 40\n            Label { text: \"Row \" + (index + 1); height: 36 }\n        }\n    }\n}\n// scroll.scrollPosition / currentLabel / contentY"
        AnnotatedScrollBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            contentWidth: width
            contentHeight: col.implicitHeight
            labelFormat: "%1%"
            Column {
                id: col
                width: parent.width
                spacing: 8
                Repeater {
                    model: 24
                    Rectangle {
                        width: col.width - 8
                        height: 36
                        radius: Theme.cornerControl
                        color: Theme.fillSubtle
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Row %1").arg(index + 1)
                            font.family: Theme.fontFamily
                            color: Theme.textPrimary
                        }
                    }
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Custom labels")
        qmlSource: "AnnotatedScrollBar {\n    labels: [\"A\", \"B\", \"C\"]\n}"
        AnnotatedScrollBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            labels: ["A", "B", "C", "D", "E", "F"]
            contentWidth: width
            contentHeight: 600
            Rectangle {
                width: parent.width
                height: 600
                gradient: Gradient {
                    GradientStop { position: 0; color: Theme.fillSubtle }
                    GradientStop { position: 1; color: Theme.fillSubtleSecondary }
                }
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Scroll to see letter labels")
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Offset labels (AnnotatedScrollBarLabel)")
        qmlSource: "labels: [\n  { content: \"Intro\", scrollOffset: 0 },\n  { content: \"Body\", scrollOffset: 0.4 },\n  { content: \"End\", scrollOffset: 0.9 }\n]"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            AnnotatedScrollBar {
                id: chapterScroll
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                alwaysShowLabel: true
                labelsInteractive: true
                detailLabel: qsTr("tap marker or bubble to jump")
                labels: [
                    { content: qsTr("Intro"), scrollOffset: 0 },
                    { content: qsTr("Body"), scrollOffset: 0.35 },
                    { content: qsTr("Appendix"), scrollOffset: 0.7 },
                    { content: qsTr("End"), scrollOffset: 0.95 }
                ]
                contentWidth: width
                contentHeight: chapterCol.implicitHeight
                Column {
                    id: chapterCol
                    width: parent.width
                    spacing: 12
                    Repeater {
                        model: [
                            qsTr("Intro — overview of the control"),
                            qsTr("Body — long scrolling content block A"),
                            qsTr("Body — long scrolling content block B"),
                            qsTr("Body — long scrolling content block C"),
                            qsTr("Appendix — notes and references"),
                            qsTr("Appendix — more detail"),
                            qsTr("End — summary")
                        ]
                        Rectangle {
                            required property string modelData
                            required property int index
                            width: chapterCol.width - 8
                            height: 72
                            radius: Theme.cornerControl
                            color: Theme.fillSubtle
                            Text {
                                anchors.fill: parent
                                anchors.margins: 12
                                text: modelData
                                wrapMode: Text.Wrap
                                font.family: Theme.fontFamily
                                color: Theme.textPrimary
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Jump Intro")
                    onClicked: chapterScroll.jumpToLabel(0)
                }
                Button {
                    text: qsTr("Jump Body")
                    onClicked: chapterScroll.jumpToLabel(1)
                }
                Button {
                    text: qsTr("Jump End")
                    onClicked: chapterScroll.jumpToLabel(3)
                }
                Label {
                    text: qsTr("Active: %1 (%2)")
                          .arg(chapterScroll.currentLabel)
                          .arg(chapterScroll.activeLabelIndex)
                    color: Theme.textSecondary
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("IME composition scroll hint (2.58)")
        qmlSource: "AnnotatedScrollBar { imeEngine: engine }\\n// ensureImeVisible on compose"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Bind imeEngine to the same KeyboardEngine as the footer dock. While composing, the scrollbar bubble shows preedit and scrollTo keeps the field visible. docs/osk-in-apps-258.md")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            KeyboardEngine {
                id: imeDemoEngine
            }
            AnnotatedScrollBar {
                id: imeScroll
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                imeEngine: imeDemoEngine
                onWindowChanged: {
                    if (Window.window)
                        imeDemoEngine.watch(Window.window)
                }
                Component.onCompleted: {
                    if (Window.window)
                        imeDemoEngine.watch(Window.window)
                }
                Column {
                    width: imeScroll.flickable.width
                    spacing: Theme.spacing
                    Repeater {
                        model: 8
                        Item { width: parent.width; height: Theme.dp(48) }
                    }
                    TextField {
                        width: parent.width - Theme.dp(16)
                        placeholderText: qsTr("Switch Gallery dock to 中文 — type pinyin here")
                    }
                    Repeater {
                        model: 8
                        Item { width: parent.width; height: Theme.dp(48) }
                    }
                }
            }
        }
    }
}
