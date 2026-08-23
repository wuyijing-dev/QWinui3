import QtQuick

// PermissionGate — Show/enable children by role (2.71).
//
//   PermissionGate {
//       currentRole: "viewer"
//       allowedRoles: ["admin", "editor"]
//       mode: "hide"   // hide | disable
//       Button { text: qsTr("Delete") }
//   }
//
// @notes
//   Declarative UX gate only — enforce authorization on the server / app model.

Item {
    id: root

    property string currentRole: ""
    property var allowedRoles: []
    // hide | disable (case-insensitive)
    property string mode: "hide"
    readonly property bool allowed: _roleAllowed()
    readonly property string _modeNorm: String(mode || "hide").toLowerCase()

    default property alias contentData: root.data

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    visible: _modeNorm === "disable" ? true : allowed
    enabled: _modeNorm === "disable" ? allowed : true
    opacity: (_modeNorm === "disable" && !allowed) ? 0.45 : 1

    function _roleAllowed() {
        var roles = allowedRoles || []
        if (!roles.length)
            return true
        var cur = String(currentRole || "").toLowerCase()
        for (var i = 0; i < roles.length; ++i) {
            if (String(roles[i]).toLowerCase() === cur)
                return true
        }
        return false
    }
}
