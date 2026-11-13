// Skeleton geometry for the neon glyphs. Coordinates are in a 200-unit-tall
// view box; NeonGlyph scales the whole box to the bar. Each character is a
// centre-line path: outlined style strokes it thinly, filled style strokes the
// same path thickly, so both styles share one shape and one animation.
//
// Paths use round caps and joins. Digits all use the same 148-unit-wide box so
// a changing digit never widens or narrows its cell.

var HEIGHT = 200

var FILLED_COLON = "M 24 52 L 36 52 Q 44 52 44 60 L 44 76 Q 44 84 36 84 L 24 84 Q 16 84 16 76 L 16 60 Q 16 52 24 52 Z M 24 116 L 36 116 Q 44 116 44 124 L 44 140 Q 44 148 36 148 L 24 148 Q 16 148 16 140 L 16 124 Q 16 116 24 116 Z"

var GLYPHS = {
  "0": {
    width: 148,
    path: "M 52 24 L 96 24 Q 124 24 124 52 L 124 148 Q 124 176 96 176 L 52 176 Q 24 176 24 148 L 24 52 Q 24 24 52 24 Z M 40 132 L 108 68"
  },
  "1": {
    width: 148,
    path: "M 74 176 L 74 40 L 52 58"
  },
  "2": {
    width: 148,
    path: "M 28 48 Q 28 24 52 24 L 96 24 Q 124 24 124 52 L 124 80 Q 124 104 96 104 L 52 104 Q 24 104 24 128 L 24 152 Q 24 176 48 176 L 116 176"
  },
  "3": {
    width: 148,
    path: "M 36 24 L 96 24 Q 124 24 124 52 L 124 148 Q 124 176 96 176 L 36 176 M 36 100 L 104 100"
  },
  "4": {
    width: 148,
    path: "M 24 24 L 24 92 Q 24 100 32 100 L 124 100 M 124 24 L 124 176"
  },
  "5": {
    width: 148,
    path: "M 124 24 L 52 24 Q 24 24 24 52 L 24 88 Q 24 104 40 104 L 94 104 Q 124 104 124 132 L 124 148 Q 124 176 96 176 L 24 176"
  },
  "6": {
    width: 148,
    path: "M 116 24 L 52 24 Q 24 24 24 52 L 24 148 Q 24 176 52 176 L 96 176 Q 124 176 124 148 L 124 124 Q 124 100 96 100 L 36 100 Q 24 100 24 112"
  },
  "7": {
    width: 148,
    path: "M 28 24 L 96 24 Q 124 24 118 48 L 72 176"
  },
  "8": {
    width: 148,
    path: "M 52 24 L 96 24 Q 124 24 124 52 L 124 148 Q 124 176 96 176 L 52 176 Q 24 176 24 148 L 24 52 Q 24 24 52 24 Z M 24 100 L 124 100"
  },
  "9": {
    width: 148,
    path: "M 52 24 L 96 24 Q 124 24 124 52 L 124 76 Q 124 100 96 100 L 52 100 Q 24 100 24 76 L 24 52 Q 24 24 52 24 Z M 124 100 L 124 148 Q 124 176 96 176 L 28 176"
  },
  ":": {
    width: 64,
    path: "M 24 56 L 36 56 Q 44 56 44 64 L 44 72 Q 44 80 36 80 L 24 80 Q 16 80 16 72 L 16 64 Q 16 56 24 56 Z M 24 120 L 36 120 Q 44 120 44 128 L 44 136 Q 44 144 36 144 L 24 144 Q 16 144 16 136 L 16 128 Q 16 120 24 120 Z"
  },
  "A": {
    width: 148,
    path: "M 24 176 L 24 52 Q 24 24 52 24 L 96 24 Q 124 24 124 52 L 124 176 M 24 104 L 124 104"
  },
  "P": {
    width: 148,
    path: "M 24 176 L 24 24 L 96 24 Q 124 24 124 52 L 124 76 Q 124 104 96 104 L 24 104"
  },
  "M": {
    width: 148,
    path: "M 24 176 L 24 24 L 74 104 L 124 24 L 124 176"
  }
}

function pathFor(glyph) {
  var entry = GLYPHS[String(glyph)]
  return entry ? entry.path : ""
}

function widthFor(glyph) {
  var entry = GLYPHS[String(glyph)]
  return entry ? entry.width : 0
}

function filledColonPath(glyph) {
  return String(glyph) === ":" ? FILLED_COLON : ""
}

function normalizedStyle(style) {
  return String(style) === "filled" ? "filled" : "outlined"
}

if (typeof module !== "undefined") {
  module.exports = {
    HEIGHT: HEIGHT,
    GLYPHS: GLYPHS,
    pathFor: pathFor,
    widthFor: widthFor,
    filledColonPath: filledColonPath,
    normalizedStyle: normalizedStyle
  }
}
