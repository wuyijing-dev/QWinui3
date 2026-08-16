import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NumberBox.

CatalogPage {
    title: qsTr("NumberBox")
    subtitle: qsTr("Spin / wheel / validationMode. FormLayout: docs/pickers.md (1.28).")

    ControlExample {
        headerText: qsTr("Header + wheel")
        qmlSource: "NumberBox {\n    header: \"Quantity\"\n    acceptWheel: true\n}"
        NumberBox {
            Layout.preferredWidth: 220
            header: qsTr("Quantity")
            description: qsTr("Scroll or use ↑/↓ (smallChange). Ctrl+wheel / PageUp uses largeChange.")
            value: 5
            minimum: 0
            maximum: 100
            smallChange: 1
            largeChange: 10
            spinButtonPlacementMode: "inline"
            acceptWheel: true
        }
    }
    ControlExample {
        headerText: qsTr("Compact (hover to reveal)")
        qmlSource: "NumberBox {\n    spinButtonPlacementMode: \"compact\"\n}"
        NumberBox {
            Layout.preferredWidth: 220
            header: qsTr("Opacity")
            value: 1.5
            minimum: 0
            maximum: 10
            stepSize: 0.5
            decimals: 1
            suffix: "×"
            spinButtonPlacementMode: "compact"
        }
    }
    ControlExample {
        headerText: qsTr("Validation")
        qmlSource: "NumberBox {\n    validationMode: \"invalidInputOverValue\"\n}"
        ColumnLayout {
            spacing: Theme.spacing
            NumberBox {
                Layout.preferredWidth: 220
                header: qsTr("Score")
                value: 3
                minimum: 0
                maximum: 10
                largeChange: 2
                spinButtonPlacementMode: "hidden"
                validationMode: "invalidInputOverValue"
                errorMessage: ""
            }
            Label {
                text: qsTr("Out-of-range Enter flashes critical border. Wheel and PageUp/PageDown supported.")
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
    ControlExample {
        headerText: qsTr("Expression + wrap")
        qmlSource: "NumberBox {\n    acceptsExpression: true\n    isWrapEnabled: true\n}"
        ColumnLayout {
            spacing: Theme.spacing
            NumberBox {
                Layout.preferredWidth: 220
                header: qsTr("Formula")
                description: qsTr("Try 2+3*4 then Enter (AcceptsExpression).")
                value: 10
                minimum: 0
                maximum: 100
                acceptsExpression: true
                spinButtonPlacementMode: "inline"
            }
            NumberBox {
                Layout.preferredWidth: 220
                header: qsTr("Wrapped spin")
                description: qsTr("Spin past 10 wraps to 0 (IsWrapEnabled).")
                value: 8
                minimum: 0
                maximum: 10
                isWrapEnabled: true
                stepSize: 1
            }
        }
    }
}
