import QtQuick
import qs.Commons
import qs.Commons as Commons
import qs.Ui
import "Palette.js" as Palette

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

  readonly property string activeColor: hostWidget ? hostWidget.digitColor : "yellow"

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

    Column {
      width: column.width
      spacing: Style.spacing.xs

      Text {
        text: "Digit color · " + Palette.labelFor(root.activeColor)
        textFormat: Text.PlainText
        color: Commons.Color.foreground
        font.family: Style.font.family
        font.pixelSize: Style.font.body
        font.bold: true
      }

      Row {
        spacing: Style.spacing.sm

        Repeater {
          model: Palette.ORDER

          delegate: Item {
            id: swatch

            required property string modelData

            readonly property bool selected: root.activeColor === modelData

            width: Style.space(30)
            height: width

            Rectangle {
              anchors.fill: parent
              radius: width / 2
              color: "transparent"
              border.width: swatch.selected ? 2 : 1
              border.color: swatch.selected
                ? Commons.Color.foreground
                : Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.28)
            }

            Rectangle {
              anchors.centerIn: parent
              width: parent.width - Style.space(8)
              height: width
              radius: width / 2
              color: Palette.colorFor(swatch.modelData).body
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: if (root.hostWidget) root.hostWidget.setOption("digitColor", swatch.modelData)
            }
          }
        }
      }
    }
  }
}
