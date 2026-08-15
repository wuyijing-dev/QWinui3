#!/usr/bin/env python3
"""Replace stubby QML header examples with real property + API usage."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_component_docs import (  # noqa: E402
    RE_HEADER_BLOCK,
    extract_api,
    parse_header_comments,
)

# Full usage bodies (no // prefixes). May include // --- API --- comment lines.
RICH: dict[str, str] = {
    "AnnotatedScrollBar": """\
AnnotatedScrollBar {
    id: scroll
    anchors.fill: parent
    labels: ["Intro", "Body", "End"]   // optional; empty → percentage via labelFormat
    labelFormat: "%1%"
    alwaysShowLabel: false
    Column {
        width: scroll.flickable.width
        Repeater {
            model: 40
            Label { text: "Row " + (index + 1); height: 36 }
        }
    }
}
// --- API ---
// scroll.scrollPosition   // 0..1
// scroll.currentLabel
// scroll.contentY / contentHeight / flickable
// inherits Control (padding, font, contentItem)
""",
    "AcrylicSurface": """\
AcrylicSurface {
    id: pane
    anchors.fill: parent
    elevated: true
    tintOpacity: 0.8
    Label { anchors.centerIn: parent; text: qsTr("Frosted") }
}
// --- API ---
// pane.elevated / tintOpacity
// children fill the acrylic surface
""",
    "AvatarGroup": """\
AvatarGroup {
    id: avatars
    model: [
        { displayName: "Ada" },
        { displayName: "Bob" },
        { displayName: "Cara" }
    ]
    maxVisible: 2
    onPersonClicked: (index) => { /* … */ }
    onOverflowClicked: { /* … */ }
}
// --- API ---
// avatars.overflowCount
""",
    "AppBarSeparator": """\
CommandBar {
    AppBarButton { text: qsTr("Add"); symbol: FluentIcons.Add }
    AppBarSeparator { }
    AppBarButton { text: qsTr("Share"); symbol: FluentIcons.Share }
}
""",
    "ContentDialogQueue": """\
// Show dialogs one-at-a-time through the singleton queue:
ContentDialogQueue.show(confirmDialog)
ContentDialogQueue.replaceCurrent(otherDialog)
ContentDialogQueue.cancel(confirmDialog)
ContentDialogQueue.clearQueue()
// --- API ---
// properties: pendingCount, busy
""",
    "GridTile": """\
GridTile {
    id: tile
    title: qsTr("Photos")
    subtitle: qsTr("12 items")
    symbol: FluentIcons.Photo
    onClicked: open()
}
// --- API ---
// inherits AbstractButton: text/enabled/clicked
""",
    "HeaderedContentControl": """\
HeaderedContentControl {
    id: block
    header: qsTr("Account")
    Label { text: qsTr("Body content") }
}
// --- API ---
// block.header / content
""",
    "HyperlinkButton": """\
HyperlinkButton {
    id: link
    text: qsTr("Learn more")
    navigateUri: "https://example.com"
    onClicked: Qt.openUrlExternally(navigateUri)
}
// --- API ---
// link.navigateUri / showExternalGlyph
""",
    "IconButton": """\
IconButton {
    id: btn
    symbol: FluentIcons.Settings
    onClicked: openSettings()
}
// --- API ---
// inherits Button: enabled, clicked()
""",
    "IconicButton": """\
IconicButton {
    id: btn
    text: qsTr("Open")
    symbol: FluentIcons.Open
    onClicked: open()
}
""",
    "InfoBarHost": """\
InfoBarHost {
    id: host
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
}
// later:
host.info(qsTr("Saved"))
host.error(qsTr("Failed"), qsTr("Retry"))
// --- API ---
// methods: info/success/warning/error, enqueue, clear
""",
    "KeyVisual": """\
KeyVisual {
    id: key
    text: "Ctrl"
}
// --- API ---
// key.text / keySize
""",
    "KeyChordVisual": """\
KeyChordVisual {
    id: chord
    keys: ["Ctrl", "K"]
}
// --- API ---
// chord.keys / chordText
""",
    "MeterBar": """\
MeterBar {
    id: meter
    value: 64
    minimum: 0
    maximum: 100
}
// --- API ---
// meter.value / levels
""",
    "PersonPicture": """\
PersonPicture {
    id: avatar
    displayName: "Ada Lovelace"
    // source: "file:///…"
}
// --- API ---
// avatar.initials / displayName / source
""",
    "ProgressRing": """\
ProgressRing {
    id: ring
    indeterminate: true
    // value: 0.4 when determinate
}
// --- API ---
// ring.value / indeterminate
""",
    "RefreshContainer": """\
RefreshContainer {
    id: refresh
    onRefreshRequested: {
        load()
        refresh.endRefresh()
    }
    ListView { model: items; /* … */ }
}
// --- API ---
// refresh.beginRefresh() / endRefresh()
// signals: onRefreshRequested
""",
    "RelativePanel": """\
RelativePanel {
    id: panel
    width: 320; height: 200
    Rectangle {
        id: a; width: 80; height: 40; color: Theme.accent
        RelativePanel.alignLeftWithPanel: true
        RelativePanel.alignTopWithPanel: true
    }
    Rectangle {
        width: 80; height: 40; color: Theme.fillSecondary
        RelativePanel.rightOf: a
        RelativePanel.alignTopWith: a
    }
}
""",
    "Shimmer": """\
Shimmer {
    id: shim
    width: 200; height: 16
    active: true
}
// --- API ---
// shim.active
""",
    "SplitButton": """\
SplitButton {
    id: split
    text: qsTr("Save")
    onClicked: save()
    MenuFlyout {
        MenuFlyoutItem { text: qsTr("Save as…"); onClicked: saveAs() }
    }
}
// --- API ---
// split.open() / close() flyout half
// signals: onClicked (primary)
""",
    "StatusDot": """\
StatusDot {
    id: dot
    status: "available"   // available | busy | away | offline
}
// --- API ---
// dot.status / statusColor
""",
    "SwipeAction": """\
SwipeControl {
    SwipeAction {
        text: qsTr("Delete")
        symbol: FluentIcons.Delete
        onTriggered: remove()
    }
    Label { text: qsTr("Row") }
}
""",
    "SwitchCase": """\
SwitchPresenter {
    currentCase: "a"
    SwitchCase { value: "a"; Label { text: "A" } }
    SwitchCase { value: "b"; Label { text: "B" } }
}
""",
    "ToastHost": """\
ToastHost {
    id: toasts
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
}
toasts.info(qsTr("Hello"))
toasts.success(qsTr("Done"))
// --- API ---
// methods: info/success/warning/error, enqueue
""",
    "ToggleButton": """\
ToggleButton {
    id: toggle
    text: qsTr("Bold")
    checkable: true
    onToggled: apply()
}
// --- API ---
// toggle.checked / onToggled
""",
    "TokenizingTextBox": """\
TokenizingTextBox {
    id: tokens
    placeholderText: qsTr("Add people")
    onTokenAdded: (text) => { /* … */ }
    onTokenRemoved: (text) => { /* … */ }
}
// --- API ---
// tokens.addToken(text) / removeToken(text) / clear()
""",
    "WrapPanel": """\
WrapPanel {
    id: wrap
    width: parent.width
    itemSpacing: 8
    Repeater {
        model: 12
        Chip { text: "Tag " + index }
    }
}
// --- API ---
// wrap.itemSpacing / orientation
""",
    "FontIcon": """\
FontIcon {
    id: icon
    symbol: FluentIcons.Home
    fontSize: 20
}
// --- API ---
// icon.symbol / iconGlyph / fontSize
""",
    "MenuFlyoutItem": """\
MenuFlyout {
    MenuFlyoutItem {
        text: qsTr("Copy")
        symbol: FluentIcons.Copy
        onClicked: copy()
    }
}
""",
    "MenuFlyoutHeader": """\
MenuFlyout {
    MenuFlyoutHeader { text: qsTr("Actions") }
    MenuFlyoutItem { text: qsTr("Edit") }
}
""",
    "MenuFlyoutSeparator": """\
MenuFlyout {
    MenuFlyoutItem { text: qsTr("Cut") }
    MenuFlyoutSeparator { }
    MenuFlyoutItem { text: qsTr("Delete") }
}
""",
    "RadioMenuFlyoutItem": """\
MenuFlyout {
    RadioMenuFlyoutItem { text: qsTr("Left"); checked: true }
    RadioMenuFlyoutItem { text: qsTr("Right") }
}
""",
    "ToggleMenuFlyoutItem": """\
MenuFlyout {
    ToggleMenuFlyoutItem { text: qsTr("Word wrap"); checked: true }
}
""",
    "MetadataItem": """\
MetadataControl {
    MetadataItem { label: qsTr("Author"); value: "Ada" }
    MetadataItem { label: qsTr("Size"); value: "12 KB" }
}
""",
    "BlankWindow": """\
BlankWindow {
    id: win
    title: qsTr("App")
    width: 800; height: 600
    Label { anchors.centerIn: parent; text: qsTr("Hello") }
}
// --- API ---
// inherits ShellWindow chrome API (title, backdrop, …)
""",
    "ToolShellWindow": """\
ToolShellWindow {
    id: tool
    title: qsTr("Inspector")
    width: 360; height: 480
}
// --- API ---
// WindowHelper.ParadigmTool flags
""",
    "CompactOverlayShellWindow": """\
CompactOverlayShellWindow {
    id: pip
    title: qsTr("Now playing")
    width: 320; height: 180
}
// --- API ---
// always-on-top compact overlay presenter
""",
    "DatePicker": """\
DatePicker {
    id: date
    selectedDate: new Date()
    onAccepted: apply(date.selectedDate)
}
// --- API ---
// date.year / month / day / selectedDate
""",
    "TimePicker": """\
TimePicker {
    id: time
    selectedTime: new Date()
    clockFormat: "12"
    onAccepted: apply(time.selectedTime)
}
// --- API ---
// time.hour / minute / selectedTime
""",
    "Button": """\
Button {
    id: btn
    text: qsTr("OK")
    onClicked: accept()
}
// --- API ---
// style-only Fluent chrome; API is Qt Quick Controls Button
""",
    "CheckBox": """\
CheckBox {
    id: box
    text: qsTr("Remember me")
    checked: true
    onToggled: save()
}
""",
    "ComboBox": """\
ComboBox {
    id: combo
    model: ["Red", "Green", "Blue"]
    onActivated: (index) => apply(index)
}
""",
    "TextField": """\
TextField {
    id: field
    placeholderText: qsTr("Name")
    onAccepted: submit(field.text)
}
""",
    "Switch": """\
Switch {
    id: sw
    text: qsTr("Dark mode")
    onToggled: Theme.dark = sw.checked
}
""",
    "RadioButton": """\
RadioButton {
    id: radio
    text: qsTr("Option A")
    checked: true
}
""",
    "Dialog": """\
Dialog {
    id: dlg
    title: qsTr("Notice")
    standardButtons: Dialog.Ok
    onAccepted: close()
}
dlg.open()
""",
    "Popup": """\
Popup {
    id: pop
    modal: true
    contentItem: Label { text: qsTr("Hi") }
}
pop.open()
""",
    "Slider": """\
Slider {
    id: slider
    from: 0; to: 100; value: 40
    onMoved: apply(slider.value)
}
""",
    "ProgressBar": """\
ProgressBar {
    id: bar
    indeterminate: false
    value: 0.6
}
""",
    "SpinBox": """\
SpinBox {
    id: spin
    from: 0; to: 10; value: 3
}
""",
    "ScrollView": """\
ScrollView {
    id: scroller
    anchors.fill: parent
    Column { /* tall content */ }
}
""",
    "BusyIndicator": """\
BusyIndicator { id: busy; running: true }
""",
    "DelayButton": """\
DelayButton {
    id: hold
    text: qsTr("Hold to confirm")
    delay: 1000
    onActivated: confirm()
}
""",
    "Dial": """\
Dial {
    id: dial
    from: 0; to: 100; value: 35
    onMoved: apply(dial.value)
}
""",
    "Drawer": """\
Drawer {
    id: drawer
    edge: Qt.LeftEdge
    Label { anchors.centerIn: parent; text: qsTr("Menu") }
}
drawer.open()
""",
    "Frame": """\
Frame {
    Label { text: qsTr("Framed content") }
}
""",
    "GroupBox": """\
GroupBox {
    title: qsTr("Options")
    Column {
        CheckBox { text: qsTr("A") }
        CheckBox { text: qsTr("B") }
    }
}
""",
    "Label": """\
Label {
    text: qsTr("Caption")
    font.pixelSize: Theme.fontBody
}
""",
    "Page": """\
Page {
    header: Label { text: qsTr("Title"); leftPadding: 16; topPadding: 12 }
    Label { anchors.centerIn: parent; text: qsTr("Content") }
}
""",
    "Pane": """\
Pane {
    padding: Theme.paddingControlH
    Label { text: qsTr("Pane body") }
}
""",
    "PageIndicator": """\
PageIndicator { id: dots; count: 5; currentIndex: 2 }
""",
    "RangeSlider": """\
RangeSlider {
    id: range
    from: 0; to: 100
    first.value: 20
    second.value: 80
}
""",
    "RoundButton": """\
RoundButton { id: round; text: "+"; onClicked: add() }
""",
    "ScrollBar": """\
Flickable {
    ScrollBar.vertical: ScrollBar { }
}
""",
    "ScrollIndicator": """\
Flickable {
    ScrollIndicator.vertical: ScrollIndicator { }
}
""",
    "SplitView": """\
SplitView {
    orientation: Qt.Horizontal
    Rectangle { SplitView.preferredWidth: 200; color: Theme.bgCard }
    Rectangle { SplitView.fillWidth: true; color: Theme.bgLayer }
}
""",
    "StackView": """\
StackView {
    id: stack
    anchors.fill: parent
    initialItem: page1
}
stack.push(page2)
""",
    "SwipeView": """\
SwipeView {
    id: pages
    anchors.fill: parent
    Item { Label { text: "1" } }
    Item { Label { text: "2" } }
}
""",
    "TabBar": """\
TabBar {
    TabButton { text: qsTr("Home") }
    TabButton { text: qsTr("Settings") }
}
""",
    "TabButton": """\
TabBar {
    TabButton { text: qsTr("One") }
    TabButton { text: qsTr("Two") }
}
""",
    "TextArea": """\
TextArea {
    id: area
    placeholderText: qsTr("Notes")
    wrapMode: TextEdit.Wrap
}
""",
    "ToolBar": """\
ToolBar {
    Row {
        ToolButton { text: qsTr("Back") }
        ToolSeparator { }
        ToolButton { text: qsTr("Forward") }
    }
}
""",
    "ToolButton": """\
ToolButton { id: tool; text: qsTr("Edit"); onClicked: edit() }
""",
    "ToolSeparator": """\
ToolBar {
    ToolButton { text: qsTr("A") }
    ToolSeparator { }
    ToolButton { text: qsTr("B") }
}
""",
    "ToolTip": """\
Button {
    text: qsTr("Hover")
    ToolTip.visible: hovered
    ToolTip.text: qsTr("Help")
}
""",
    "Tumbler": """\
Tumbler { id: tumbler; model: 24; currentIndex: 8 }
""",
    "Menu": """\
Button {
    text: qsTr("Open")
    onClicked: menu.open()
    Menu {
        id: menu
        MenuItem { text: qsTr("New"); onTriggered: create() }
        MenuSeparator { }
        MenuItem { text: qsTr("Quit"); onTriggered: Qt.quit() }
    }
}
""",
    "MenuItem": """\
Menu {
    MenuItem { text: qsTr("Copy"); onTriggered: copy() }
}
""",
    "MenuSeparator": """\
Menu {
    MenuItem { text: qsTr("A") }
    MenuSeparator { }
    MenuItem { text: qsTr("B") }
}
""",
    "MenuBar": """\
ApplicationWindow {
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem { text: qsTr("Exit") }
        }
    }
}
""",
    "MenuBarItem": """\
MenuBar {
    MenuBarItem {
        text: qsTr("Edit")
        menu: Menu { MenuItem { text: qsTr("Undo") } }
    }
}
""",
    "ItemDelegate": """\
ListView {
    model: 5
    delegate: ItemDelegate {
        text: "Item " + index
        width: ListView.view.width
        onClicked: select(index)
    }
}
""",
    "CheckDelegate": """\
ListView {
    model: 3
    delegate: CheckDelegate {
        text: "Option " + index
        width: ListView.view.width
    }
}
""",
    "RadioDelegate": """\
ListView {
    model: 3
    delegate: RadioDelegate {
        text: "Choice " + index
        width: ListView.view.width
    }
}
""",
    "SwitchDelegate": """\
ListView {
    model: 3
    delegate: SwitchDelegate {
        text: "Flag " + index
        width: ListView.view.width
    }
}
""",
    "SwipeDelegate": """\
ListView {
    model: 3
    delegate: SwipeDelegate {
        text: "Row " + index
        swipe.right: Label { text: qsTr("Delete"); padding: 12 }
    }
}
""",
    "DialogButtonBox": """\
Dialog {
    footer: DialogButtonBox {
        standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel
    }
}
""",
    "ApplicationWindow": """\
ApplicationWindow {
    id: win
    width: 1024; height: 720
    title: qsTr("App")
    visible: true
}
""",
    "DialogWindow": """\
DialogWindow {
    id: dlg
    title: qsTr("Prompt")
    width: 420; height: 280
}
""",
    "ToolWindow": """\
ToolWindow {
    id: tool
    title: qsTr("Tools")
    width: 320; height: 480
}
""",
    "CompactOverlayWindow": """\
CompactOverlayWindow {
    id: pip
    title: qsTr("PiP")
    width: 320; height: 180
}
""",
    "DayOfWeekRow": """\
DayOfWeekRow { locale: Qt.locale() }
""",
    "HorizontalHeaderView": """\
HorizontalHeaderView { syncView: table; clip: true }
""",
    "VerticalHeaderView": """\
VerticalHeaderView { syncView: table; clip: true }
""",
    "TreeViewDelegate": """\
TreeView {
    delegate: TreeViewDelegate { }
}
""",
    "MonthGrid": """\
MonthGrid {
    id: grid
    month: (new Date()).getMonth()
    year: (new Date()).getFullYear()
    onClicked: (date) => pick(date)
}
""",
}


def commentize(usage: str) -> str:
    lines = []
    for line in usage.splitlines():
        if not line.strip():
            lines.append("//")
        else:
            lines.append("//   " + line)
    return "\n".join(lines)


def rewrite(path: Path, name: str, summary: str, usage: str) -> bool:
    text = path.read_text(encoding="utf-8")
    m = RE_HEADER_BLOCK.match(text)
    if not m:
        return False
    new_header = f"// {name} — {summary}\n//\n{commentize(usage)}\n"
    new_text = text[: m.start("header")] + new_header + text[m.end("header") :]
    if new_text == text:
        return False
    path.write_text(new_text, encoding="utf-8", newline="\n")
    return True


def main() -> None:
    dirs = [
        ROOT / "src/extras/QWinUI3/Extras",
        ROOT / "src/style/QWinUI3",
        ROOT / "src/platform/QWinUI3/Platform",
        ROOT / "src/theme/QWinUI3/Theme",
    ]
    n = 0
    for d in dirs:
        for path in sorted(d.glob("*.qml")):
            name = path.stem
            if name not in RICH:
                continue
            summary, old, _ = parse_header_comments(path.read_text(encoding="utf-8"), name)
            if not summary:
                summary = RICH[name].splitlines()[0][:60]
            # Prefer existing summary line from file
            text = path.read_text(encoding="utf-8")
            summary2, _, _ = parse_header_comments(text, name)
            summary = summary2 or summary
            if rewrite(path, name, summary, RICH[name]):
                print(f"RICH {path.relative_to(ROOT)}")
                n += 1
    print(f"Upgraded {n} stubby examples")


if __name__ == "__main__":
    main()
