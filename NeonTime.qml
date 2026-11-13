import QtQuick
import "ClockModel.js" as Model

// Composition of the digit cells, colon and AM/PM block. Pure Qt Quick so the
// preview harness can render it without the Omarchy shell.
Item {
  id: root

  property date date: new Date()
  property bool use24Hour: true
  property bool showSeconds: false
  property color digitColor: "#ffd24a"
  property color glowColor: "#ffb000"
  property color hotColor: "#fff4b8"
  property real digitHeight: 22
  property bool vertical: false
  property int rollDuration: 200

  readonly property var parts: Model.timeParts(date, use24Hour, showSeconds)
  readonly property real gap: Math.max(1, Math.round(digitHeight * 0.08))
  readonly property real meridiemHeight: Math.max(6, Math.round(digitHeight * 0.62))

  implicitWidth: vertical ? verticalLayout.implicitWidth : horizontalLayout.implicitWidth
  implicitHeight: vertical ? verticalLayout.implicitHeight : digitHeight

  Row {
    id: horizontalLayout

    visible: !root.vertical
    height: root.digitHeight
    spacing: root.gap

    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.hourTens
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.hourUnits
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
    }

    NeonGlyph {
      height: root.digitHeight
      glyph: ":"
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
    }

    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.minuteTens
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.minuteUnits
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
    }

    NeonGlyph {
      height: root.digitHeight
      glyph: ":"
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      visible: root.showSeconds
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.secondTens
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
      visible: root.showSeconds
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.secondUnits
      digitColor: root.digitColor
      glowColor: root.glowColor
      hotColor: root.hotColor
      rollDuration: root.rollDuration
      visible: root.showSeconds
    }

    Item {
      width: root.parts.meridiem === "" ? 0 : meridiemRow.implicitWidth + root.gap
      height: root.digitHeight
      visible: root.parts.meridiem !== ""

      Row {
        id: meridiemRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 0 ? root.parts.meridiemLetters[0] : ""
          digitColor: root.digitColor
          glowColor: root.glowColor
          hotColor: root.hotColor
        }
        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 1 ? root.parts.meridiemLetters[1] : ""
          digitColor: root.digitColor
          glowColor: root.glowColor
          hotColor: root.hotColor
        }
      }
    }
  }

  Column {
    id: verticalLayout

    visible: root.vertical
    spacing: Math.max(1, Math.round(root.digitHeight * 0.08))

    Row {
      spacing: root.gap

      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.hourTens
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.hourUnits
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
    }

    Row {
      spacing: root.gap

      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.minuteTens
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.minuteUnits
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
    }

    Row {
      visible: root.showSeconds
      spacing: root.gap

      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.secondTens
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.secondUnits
        digitColor: root.digitColor
        glowColor: root.glowColor
        hotColor: root.hotColor
        rollDuration: root.rollDuration
      }
    }

    Item {
      width: parent.width
      height: root.meridiemHeight
      visible: root.parts.meridiem !== ""

      Row {
        anchors.centerIn: parent
        spacing: 0

        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 0 ? root.parts.meridiemLetters[0] : ""
          digitColor: root.digitColor
          glowColor: root.glowColor
          hotColor: root.hotColor
        }
        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 1 ? root.parts.meridiemLetters[1] : ""
          digitColor: root.digitColor
          glowColor: root.glowColor
          hotColor: root.hotColor
        }
      }
    }
  }
}
