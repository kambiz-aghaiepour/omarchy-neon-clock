import QtQuick
import ".."
import "../Palette.js" as Palette
import "../ClockModel.js" as Model

// Offscreen preview: renders the bar-size clock, the three digit sizes, every
// digit colour (black on a light tile), the vertical layout, and the full
// glyph set. Run ./preview/run to write preview/neon-clock-preview.png.
Item {
  id: root

  width: 940
  height: 660

  property date sample: new Date(2026, 10, 12, 21, 47, 36)

  Rectangle {
    anchors.fill: parent
    color: "#070d14"

    Column {
      anchors.top: parent.top
      anchors.topMargin: 24
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 18

      Row {
        spacing: 28
        Text {
          width: 130
          text: "yellow, large"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: root.sample
          use24Hour: true
          showSeconds: true
          digitHeight: 70
          digitColor: Palette.colorFor("yellow").body
          glowColor: Palette.colorFor("yellow").glow
          hotColor: Palette.colorFor("yellow").hot
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "bar size, 12-hour"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        NeonTime {
          date: new Date(2026, 10, 12, 9, 5, 0)
          use24Hour: false
          showSeconds: false
          digitHeight: 21
          digitColor: Palette.colorFor("yellow").body
          glowColor: Palette.colorFor("yellow").glow
          hotColor: Palette.colorFor("yellow").hot
        }
      }

      Row {
        spacing: 28
        Text {
          width: 130
          text: "digit sizes"
          color: "#6f8a9a"
          font.pixelSize: 14
        }
        Row {
          spacing: 18

          Repeater {
            model: Model.DIGIT_SIZES

            delegate: Column {
              id: sizeColumn
              required property string modelData
              spacing: 4

              Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.titleCase(sizeColumn.modelData)
                color: "#6f8a9a"
                font.pixelSize: 13
              }
              NeonTime {
                date: root.sample
                use24Hour: true
                showSeconds: false
                digitHeight: Math.round(26 * Model.horizontalSizeFactor(sizeColumn.modelData))
                digitColor: Palette.colorFor("yellow").body
                glowColor: Palette.colorFor("yellow").glow
                hotColor: Palette.colorFor("yellow").hot
              }
            }
          }
        }
      }

      Row {
        spacing: 14

        Repeater {
          model: Palette.ORDER

          delegate: Column {
            id: colorColumn
            required property string modelData
            spacing: 4

            Text {
              anchors.horizontalCenter: parent.horizontalCenter
              text: Palette.labelFor(colorColumn.modelData)
              color: "#6f8a9a"
              font.pixelSize: 13
            }

            Item {
              width: neon.implicitWidth + 16
              height: neon.height + 12

              Rectangle {
                anchors.fill: parent
                radius: 6
                color: colorColumn.modelData === "black" ? "#e8e8e8" : "#0b1118"
              }

              NeonTime {
                id: neon
                anchors.centerIn: parent
                date: root.sample
                use24Hour: true
                showSeconds: false
                digitHeight: 24
                digitColor: Palette.colorFor(colorColumn.modelData).body
                glowColor: Palette.colorFor(colorColumn.modelData).glow
                hotColor: Palette.colorFor(colorColumn.modelData).hot
              }
            }
          }
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
          digitHeight: 15
          vertical: true
          digitColor: Palette.colorFor("yellow").body
          glowColor: Palette.colorFor("yellow").glow
          hotColor: Palette.colorFor("yellow").hot
        }
      }
    }

    Column {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 20
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 8

      Row {
        spacing: 2
        Repeater {
          model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", "A", "P", "M"]
          delegate: NeonGlyph {
            height: 34
            glyph: modelData
            digitColor: Palette.colorFor("yellow").body
            glowColor: Palette.colorFor("yellow").glow
            hotColor: Palette.colorFor("yellow").hot
          }
        }
      }
    }
  }

  function titleCase(value) {
    var text = String(value || "")
    return text.charAt(0).toUpperCase() + text.slice(1)
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
