import QtQuick
import QWinUI3.Extras

// SensitiveField — Masked field with reveal toggle for tokens / secrets (2.79).
//
//   SensitiveField {
//       header: qsTr("API token")
//       placeholderText: qsTr("••••••••")
//   }
//
// @notes
//   Thin PasswordBox alias for non-login secrets (API keys, tokens). Same reveal UX.

PasswordBox {
    id: root
    passwordRevealMode: "peek"
    Accessible.name: header.length ? header : qsTr("Sensitive value")
}
