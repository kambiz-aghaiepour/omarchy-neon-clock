import QtQuick

// A fixed-size digit cell that rolls vertically when its glyph changes: the
// new character enters from below while the old one leaves above. Clipping is
// on the cell, not the bar, so the motion never paints over its neighbours.
Item {
  id: root

  property string glyph: ""
  property color digitColor: "#ffd24a"
  property color glowColor: "#ffb000"
  property color hotColor: "#fff4b8"
  property int rollDuration: 200

  implicitWidth: entering.implicitWidth
  implicitHeight: entering.implicitHeight
  clip: true

  QtObject {
    id: internal
    property string shown: ""
    property string leaving: ""
  }

  NeonGlyph {
    id: leaving

    x: (root.width - width) / 2
    y: 0
    height: root.height
    glyph: internal.leaving
    digitColor: root.digitColor
    glowColor: root.glowColor
    hotColor: root.hotColor
    visible: internal.leaving !== ""
  }

  NeonGlyph {
    id: entering

    x: (root.width - width) / 2
    y: 0
    height: root.height
    glyph: internal.shown
    digitColor: root.digitColor
    glowColor: root.glowColor
    hotColor: root.hotColor
  }

  onGlyphChanged: {
    var previous = internal.shown
    internal.shown = glyph
    if (previous === "" || previous === glyph) {
      internal.leaving = ""
      return
    }
    if (roll.running) roll.stop()
    internal.leaving = previous
    entering.y = root.height
    leaving.y = 0
    if (root.rollDuration <= 0 || root.height <= 0) {
      entering.y = 0
      internal.leaving = ""
      return
    }
    roll.restart()
  }

  Component.onCompleted: {
    if (internal.shown === "" && glyph !== "") {
      internal.shown = glyph
      entering.y = 0
    }
  }

  ParallelAnimation {
    id: roll

    NumberAnimation {
      target: entering
      property: "y"
      from: root.height
      to: 0
      duration: root.rollDuration
      easing.type: Easing.OutCubic
    }

    NumberAnimation {
      target: leaving
      property: "y"
      from: 0
      to: -root.height
      duration: root.rollDuration
      easing.type: Easing.OutCubic
    }

    onFinished: internal.leaving = ""
  }
}
