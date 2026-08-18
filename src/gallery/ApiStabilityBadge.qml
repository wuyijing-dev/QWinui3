import QtQuick
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — API stability pill (2.45). Maps ControlCatalog.apiStabilityForComponent.

InfoBadge {
    id: root

    property string stability: "stable"

    visible: stability !== "stable" && displayLabel.length > 0
    text: displayLabel
    severity: {
        if (stability === "permanent-defer")
            return warning
        if (stability === "experimental")
            return attention
        return neutral
    }

    readonly property string displayLabel: ControlCatalog.apiStabilityLabel(stability)

    Accessible.name: displayLabel
}
