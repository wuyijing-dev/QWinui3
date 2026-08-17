# RichEdit (2.61)

Experimental **rich-text editor** for mail, template, and long-note surfaces — closes **FL-005** without WebView2 hacks.

Related: [forms.md](forms.md) · [accessibility.md](accessibility.md) · [planning/friction-log.md](planning/friction-log.md) (**FL-005**) · Gallery **RichEdit** page.

Control: `import QWinUI3.Extras` · [`RichEdit.qml`](../src/extras/QWinUI3/Extras/RichEdit.qml) (**experimental**).

---

## Choosing

| Need | Prefer |
|------|--------|
| Plain multi-line notes | Style **`TextArea`** |
| Token chips (recipients, tags) | **`TokenizingTextBox`** |
| Bold / italic / lists / links + IME | **`RichEdit`** |
| Full Word / collaboration | App-owned engine — **out of scope** |

**Out of scope (2.61):** tables, images inline, track changes, cloud co-editing.

---

## Mail compose recipe

```qml
ColumnLayout {
    TokenizingTextBox {
        id: toField
        Layout.fillWidth: true
        header: qsTr("To")
    }
    TextField {
        id: subjectField
        Layout.fillWidth: true
        placeholderText: qsTr("Subject")
    }
    RichEdit {
        id: body
        Layout.fillWidth: true
        Layout.preferredHeight: 220
        placeholderText: qsTr("Write your message…")
        accessibleName: qsTr("Message body")
        onLinkActivated: (url) => Qt.openUrlExternally(url)
    }
}
```

Gallery: **RichEdit** page mirrors this layout.

---

## Formatting API

| Method | Effect |
|--------|--------|
| `toggleBold()` | Wrap selection with `<b>…</b>` |
| `toggleItalic()` | Wrap selection with `<i>…</i>` |
| `insertUnorderedList()` | Wrap selection with `<ul><li>…</li></ul>` |
| `insertLink(url)` | Wrap selection with `<a href="…">…</a>` |
| `clear()` | Empty document |
| `focusEditor()` | Move focus into the field |

Toolbar buttons call the same methods when `showToolbar: true` (default).

---

## Paste sanitization

| Property | Default | Note |
|----------|---------|------|
| `sanitizePaste` | `true` | Strips `<script>`, `<iframe>`, `on*` / `style` attributes, `javascript:` URLs |

Sanitize runs after text changes — not a full HTML parser. Review pasted content in security-sensitive apps.

---

## Accessibility

| API | Note |
|-----|------|
| `accessibleName` | Override when multiple editors share a page |
| `Accessible.multiLine` | Set on control |
| IME | Native **TextEdit** input method — preferred over WebView2 for CJK mail |

---

## App checklist

- [ ] Mark **`RichEdit`** experimental in product docs until promote gate
- [ ] Wire **`onLinkActivated`** — do not leave `javascript:` links executable
- [ ] Keep **`sanitizePaste: true`** for user-generated HTML paste
- [ ] Pair with **`TokenizingTextBox`** for recipients — not free-form To: strings only
- [ ] Do not embed WebView2 for the same field — duplicates IME/a11y paths

**Next:** **2.62** conditional **`SemanticZoom`** (**FL-006**)
