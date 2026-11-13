import QtQuick
import qs.Commons
import qs.Ui
import "ClockModel.js" as Model

// Standalone neon digital clock. It intentionally does not reuse the
// omarchy.clock id or its settings: both clocks can live in the bar at once.
BarWidget {
  id: root
  moduleName: "io.github.kambiz.neon-clock"

  readonly property bool use24Hour: setting("use24Hour", true) !== false
  readonly property bool showSeconds: setting("showSeconds", false) === true
  readonly property string digitStyle: setting("digitStyle", "outlined") === "filled" ? "filled" : "outlined"

  // The clock owns the popup state so the bar's popout coordinator sees one
  // stable identity for this widget.
  property bool panelOpen: false
  readonly property bool opened: panelOpen

  property date now: new Date()

  readonly property int contentPadding: Math.max(2, Math.round(Style.space(3)))
  readonly property real digitHeight: vertical
    ? Math.max(10, Math.round(barSize * 0.62))
    : Math.max(12, barSize - 2)

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  readonly property Item anchorItem: button

  function setOption(key, value) {
    var entry = { id: root.moduleName }
    for (var name in root.settings)
      if (name !== "id") entry[name] = root.settings[name]
    entry[key] = value

    // Local first so the digits change on the click; the bar writes the same
    // value to shell.json and echoes it back.
    root.settings = entry
    if (root.bar && root.bar.shell && typeof root.bar.shell.updateEntryInline === "function")
      root.bar.shell.updateEntryInline(root.moduleName, entry)
  }

  function cycleStyle() {
    root.setOption("digitStyle", root.digitStyle === "filled" ? "outlined" : "filled")
  }

  function open() { root.panelOpen = true }
  function close() { root.panelOpen = false }
  function togglePanel() { root.panelOpen = !root.panelOpen }

  function injectPanel() {
    var panel = panelLoader.item
    if (panel) panel.hostWidget = root
  }

  onBarChanged: injectPanel()

  Timer {
    id: ticker
    repeat: true
    running: true

    readonly property int step: root.showSeconds ? 1000 : 60000

    function arm() {
      interval = Model.msUntilNextTick(Date.now(), step)
      restart()
    }

    onStepChanged: arm()
    onTriggered: {
      root.now = new Date()
      arm()
    }
    Component.onCompleted: arm()
  }

  WidgetButton {
    id: button

    anchors.fill: parent
    bar: root.bar
    text: ""
    labelVisible: false
    hasVisualContent: true
    fixedWidth: root.vertical
      ? root.barSize
      : time.implicitWidth + root.contentPadding * 2
    fixedHeight: root.vertical
      ? time.implicitHeight + root.contentPadding * 2
      : root.barSize
    tooltipText: Model.tooltipFor(root.use24Hour, root.showSeconds, root.digitStyle)
    pressFeedbackButtons: Qt.NoButton

    onPressed: function(mouseButton) {
      if (mouseButton === Qt.RightButton) root.togglePanel()
      else if (mouseButton === Qt.LeftButton) root.cycleStyle()
    }

    NeonTime {
      id: time

      anchors.centerIn: parent
      date: root.now
      use24Hour: root.use24Hour
      showSeconds: root.showSeconds
      digitStyle: root.digitStyle
      digitHeight: root.digitHeight
      vertical: root.vertical
      rollDuration: Style.duration(200)
    }
  }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("ControlPanel.qml")
    visible: false
    onLoaded: root.injectPanel()
  }
}
