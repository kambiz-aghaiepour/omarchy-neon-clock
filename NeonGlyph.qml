import QtQuick
import QtQuick.Shapes
import "Glyphs.js" as Glyphs

// One neon character, drawn as a centre-line path with a hot core and two
// wider translucent strokes that read as tube glow. The same skeleton is used
// for both styles: outlined is a thin tube, filled is a fat one.
Item {
  id: root

  property string glyph: "0"
  property string style: "outlined"
  property color glowColor: "#1fc8ff"
  property color outlinedColor: "#5fe2ff"
  property color filledColor: "#35d4ff"
  property bool glowEnabled: true

  readonly property string normalizedStyle: Glyphs.normalizedStyle(style)
  readonly property bool filled: normalizedStyle === "filled"
  readonly property bool filledColon: filled && glyph === ":"
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
      strokeWidth: root.filled ? 84 : 46
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
      strokeWidth: root.filled ? 62 : 30
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }

    // Tube body.
    ShapePath {
      strokeColor: root.filledColon ? "transparent"
        : root.filled ? root.filledColor : root.outlinedColor
      strokeWidth: root.glyph === ":" && !root.filled ? 9
        : root.filled ? 46
        : (root.glyph === "A" || root.glyph === "P" || root.glyph === "M") ? 14
        : 12
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }

    // Filled colon dots are solid pads, not fat rings: fill their outline
    // instead of stroking the loop, so no pinhole survives at the centre.
    ShapePath {
      strokeColor: "transparent"
      fillColor: root.filledColon ? root.filledColor : "transparent"
      PathSvg { path: Glyphs.filledColonPath(root.glyph) }
    }

    // Hot centre. Outlined tubes get a near-white filament, which is what
    // makes them read as outline rather than flat colour at bar sizes. Filled
    // tubes stay uniform: a bright core stripe would make them look like fat
    // outlines instead of solid neon.
    ShapePath {
      strokeColor: root.filled ? "transparent" : Qt.rgba(1.0, 1.0, 1.0, 0.95)
      strokeWidth: root.filled ? 0 : 3.5
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: Glyphs.pathFor(root.glyph) }
    }
  }
}
