import QtQuick
import QtQuick.Shapes
import "Glyphs.js" as Glyphs

// One outlined neon character, drawn as a centre-line path with a hot
// filament and two wider translucent strokes that read as tube glow.
Item {
  id: root

  property string glyph: "0"
  property color digitColor: "#ffd24a"
  property color glowColor: "#ffb000"
  property color hotColor: "#fff4b8"
  property bool glowEnabled: true

  readonly property real viewWidth: Glyphs.widthFor(glyph)
  readonly property real unit: height / Glyphs.HEIGHT

  width: viewWidth * unit
  implicitWidth: width
  implicitHeight: height

  Shape {
    id: shape

    width: root.viewWidth
    height: Glyphs.HEIGHT
    scale: root.unit
    transformOrigin: Item.TopLeft
    preferredRendererType: Shape.CurveRenderer
    antialiasing: true

    // Wide halo. Alpha lives in the colour so all four paths can share one
    // Shape: ShapePath has no opacity property of its own.
    ShapePath {
      strokeColor: root.glowEnabled
        ? Qt.rgba(root.glowColor.r, root.glowColor.g, root.glowColor.b, 0.18)
        : "transparent"
      strokeWidth: 46
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }

    // Tight halo.
    ShapePath {
      strokeColor: root.glowEnabled
        ? Qt.rgba(root.glowColor.r, root.glowColor.g, root.glowColor.b, 0.34)
        : "transparent"
      strokeWidth: 30
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }

    // Tube body.
    ShapePath {
      strokeColor: root.digitColor
      strokeWidth: root.glyph === ":" ? 9
        : (root.glyph === "A" || root.glyph === "P" || root.glyph === "M") ? 14
        : 12
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }

    // Hot filament. It is a pale tint of the chosen colour rather than pure
    // white, so red stays red and purple stays purple at bar sizes.
    ShapePath {
      strokeColor: Qt.rgba(root.hotColor.r, root.hotColor.g, root.hotColor.b, 0.92)
      strokeWidth: 3.5
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }
  }
}
