import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — CheckBox (WinUI two-state, three-state select-all, description).

CatalogPage {
    title: qsTr("CheckBox")
    subtitle: qsTr("Two-state, three-state, description — docs/components/CheckBox.md")

    ControlExample {
        headerText: qsTr("A 2-state CheckBox")
        qmlSource: "CheckBox { text: \"Two-state CheckBox\" }\nCheckBox { text: \"Checked\"; checked: true }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            CheckBox { text: qsTr("Two-state CheckBox") }
            CheckBox { text: qsTr("Checked"); checked: true }
            CheckBox { text: qsTr("Disabled"); enabled: false }
            CheckBox { text: qsTr("Disabled checked"); checked: true; enabled: false }
        }
    }

    ControlExample {
        headerText: qsTr("A CheckBox with a description")
        qmlSource: "CheckBox {\n    text: \"Send diagnostic data\"\n    description: \"Helps improve the product.\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            CheckBox {
                Layout.fillWidth: true
                text: qsTr("Send diagnostic data")
                description: qsTr("Optional usage data helps improve reliability. You can change this later.")
                checked: true
            }
            CheckBox {
                Layout.fillWidth: true
                header: qsTr("Email me product tips")
                description: qsTr("About once a month. Unsubscribe anytime.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("A 3-state CheckBox (select all)")
        qmlSource: "CheckBox {\n    text: \"Select all\"\n    tristate: true\n    checkState: Qt.PartiallyChecked\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Parent is three-state. Toggle children, or click Select all to check / clear the group.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            CheckBox {
                id: selectAll
                text: qsTr("Select all")
                isThreeState: true
                property bool _applying: false

                // From Unchecked or PartiallyChecked → Checked (select all);
                // from Checked → Unchecked (clear all). Skip the partial hop on click.
                nextCheckState: function () {
                    if (checkState === Qt.Checked)
                        return Qt.Unchecked
                    return Qt.Checked
                }

                function refreshFromChildren() {
                    if (_applying)
                        return
                    var n = (opt1.checked ? 1 : 0) + (opt2.checked ? 1 : 0) + (opt3.checked ? 1 : 0)
                    _applying = true
                    if (n === 0)
                        checkState = Qt.Unchecked
                    else if (n === 3)
                        checkState = Qt.Checked
                    else
                        checkState = Qt.PartiallyChecked
                    _applying = false
                }

                onCheckStateChanged: {
                    if (_applying)
                        return
                    if (checkState === Qt.PartiallyChecked)
                        return
                    _applying = true
                    var on = checkState === Qt.Checked
                    opt1.checked = on
                    opt2.checked = on
                    opt3.checked = on
                    _applying = false
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.checkSize + Theme.spacing
                spacing: Theme.spacing
                CheckBox {
                    id: opt1
                    text: qsTr("Option 1")
                    checked: true
                    onCheckedChanged: selectAll.refreshFromChildren()
                }
                CheckBox {
                    id: opt2
                    text: qsTr("Option 2")
                    onCheckedChanged: selectAll.refreshFromChildren()
                }
                CheckBox {
                    id: opt3
                    text: qsTr("Option 3")
                    checked: true
                    onCheckedChanged: selectAll.refreshFromChildren()
                }
            }
            Component.onCompleted: selectAll.refreshFromChildren()
        }
    }
}
