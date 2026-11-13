import QtQuick
import ".."

// Offscreen preview: renders both digit styles at inspection size and at bar
// size. Run ./preview/run to write preview/neon-clock-preview.png.
Item {
  id: root

  width: 940
  height: 680

  property date sample: new Date(2026, 10, 12, 21, 47, 36)

  Rectangle {
    anchors.fill: parent
    color: "#070d14"

    Column {
      anchors.centerIn: parent
      spacing: 26

      Row {
        spacing: 28
        Text {
          width: 130
          text: "outlined"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: root.sample
          use24Hour: true
          showSeconds: true
          digitStyle: "outlined"
          digitHeight: 82
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "filled"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: root.sample
          use24Hour: true
          showSeconds: true
          digitStyle: "filled"
          digitHeight: 82
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "12-hour, bar size"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: new Date(2026, 10, 12, 9, 5, 0)
          use24Hour: false
          showSeconds: false
          digitStyle: "outlined"
          digitHeight: 22
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "filled, bar size"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: new Date(2026, 10, 12, 9, 5, 0)
          use24Hour: false
          showSeconds: false
          digitStyle: "filled"
          digitHeight: 22
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "vertical bar"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: new Date(2026, 10, 12, 9, 5, 42)
          use24Hour: false
          showSeconds: true
          digitStyle: "outlined"
          digitHeight: 17
          vertical: true
        }
      }
    }

    Column {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 22
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8

      Row {
        spacing: 2
        Repeater {
          model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", "A", "P", "M"]
          delegate: NeonGlyph {
            height: 34
            glyph: modelData
            style: "outlined"
          }
        }
      }

      Row {
        spacing: 2
        Repeater {
          model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", "A", "P", "M"]
          delegate: NeonGlyph {
            height: 34
            glyph: modelData
            style: "filled"
          }
        }
      }
    }
  }

  Timer {
    interval: 400
    running: true
    onTriggered: root.grabToImage(function(result) {
      result.saveToFile("neon-clock-preview.png")
      Qt.exit(0)
    })
  }
}
