import QtQuick
import ".."
import "../Palette.js" as Palette

// Motion proof: changes a digit, then grabs the cell 100 ms into the 200 ms
// roll. The capture should show the old glyph above the new one, both clipped
// by the cell.
Item {
  id: root

  width: 220
  height: 260

  Rectangle {
    anchors.fill: parent
    color: "#070d14"
  }

  NeonDigit {
    id: digit

    anchors.centerIn: parent
    width: 150
    height: 190
    glyph: "7"
    digitColor: Palette.colorFor("red").body
    glowColor: Palette.colorFor("red").glow
    hotColor: Palette.colorFor("red").hot
    rollDuration: 200
  }

  Timer {
    interval: 250
    running: true
    onTriggered: digit.glyph = "2"
  }

  Timer {
    interval: 350
    running: true
    onTriggered: root.grabToImage(function(result) {
      result.saveToFile("roll-frame.png")
      Qt.exit(0)
    })
  }
}
