import QtQuick
import "ClockModel.js" as Model

// Composition of the digit cells, colon and AM/PM block. Pure Qt Quick so the
// preview harness can render it without the Omarchy shell.
Item {
  id: root

  property date date: new Date()
  property bool use24Hour: true
  property bool showSeconds: false
  property string digitStyle: "outlined"
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
      style: root.digitStyle
      rollDuration: root.rollDuration
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.hourUnits
      style: root.digitStyle
      rollDuration: root.rollDuration
    }

    NeonGlyph {
      height: root.digitHeight
      glyph: ":"
      style: root.digitStyle
    }

    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.minuteTens
      style: root.digitStyle
      rollDuration: root.rollDuration
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.minuteUnits
      style: root.digitStyle
      rollDuration: root.rollDuration
    }

    NeonGlyph {
      height: root.digitHeight
      glyph: ":"
      style: root.digitStyle
      visible: root.showSeconds
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.secondTens
      style: root.digitStyle
      rollDuration: root.rollDuration
      visible: root.showSeconds
    }
    NeonDigit {
      height: root.digitHeight
      glyph: root.parts.secondUnits
      style: root.digitStyle
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
          style: root.digitStyle
        }
        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 1 ? root.parts.meridiemLetters[1] : ""
          style: root.digitStyle
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
        style: root.digitStyle
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.hourUnits
        style: root.digitStyle
        rollDuration: root.rollDuration
      }
    }

    Row {
      spacing: root.gap

      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.minuteTens
        style: root.digitStyle
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.minuteUnits
        style: root.digitStyle
        rollDuration: root.rollDuration
      }
    }

    Row {
      visible: root.showSeconds
      spacing: root.gap

      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.secondTens
        style: root.digitStyle
        rollDuration: root.rollDuration
      }
      NeonDigit {
        height: root.digitHeight
        glyph: root.parts.secondUnits
        style: root.digitStyle
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
          style: root.digitStyle
        }
        NeonGlyph {
          height: root.meridiemHeight
          glyph: root.parts.meridiemLetters.length > 1 ? root.parts.meridiemLetters[1] : ""
          style: root.digitStyle
        }
      }
    }
  }
}
