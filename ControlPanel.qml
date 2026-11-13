import QtQuick
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// Right-click control panel for the neon clock. The bar injects the widget so
// every control persists through the same inline shell.json entry the digits
// read; the panel owns no state of its own.
PopupCard {
  id: root

  property var hostWidget: null

  anchorItem: hostWidget ? hostWidget.anchorItem : null
  bar: hostWidget ? hostWidget.bar : null
  owner: hostWidget
  open: hostWidget ? hostWidget.panelOpen : false

  contentWidth: fittedContentWidth(Style.space(264))
  contentHeight: fittedContentHeight(column.implicitHeight)

  Column {
    id: column

    anchors.fill: parent
    spacing: Style.spacing.md

    Text {
      text: "Neon Clock"
      textFormat: Text.PlainText
      color: Commons.Color.foreground
      font.family: Style.font.family
      font.pixelSize: Style.font.subtitle
      font.bold: true
    }

    Toggle {
      width: column.width
      label: "24-hour clock"
      description: "Off shows 12-hour time with AM/PM."
      checked: root.hostWidget ? root.hostWidget.use24Hour : true
      onClicked: if (root.hostWidget) root.hostWidget.setOption("use24Hour", !root.hostWidget.use24Hour)
    }

    Toggle {
      width: column.width
      label: "Show seconds"
      description: "Adds a seconds pair and rolls it every second."
      checked: root.hostWidget ? root.hostWidget.showSeconds : false
      onClicked: if (root.hostWidget) root.hostWidget.setOption("showSeconds", !root.hostWidget.showSeconds)
    }

    Toggle {
      width: column.width
      label: "Filled digits"
      description: "Off draws outlined neon tubes; on fills them in."
      checked: root.hostWidget ? root.hostWidget.digitStyle === "filled" : false
      onClicked: if (root.hostWidget)
        root.hostWidget.setOption("digitStyle", root.hostWidget.digitStyle === "filled" ? "outlined" : "filled")
    }
  }
}
