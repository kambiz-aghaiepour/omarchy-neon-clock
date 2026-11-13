// Digit colours available in the control panel. Each entry carries the tube
// body, the glow behind it, and the hot filament colour, so a colour change
// stays a single lookup and never needs Qt colour maths at paint time.

var ORDER = ["yellow", "green", "red", "purple", "orange", "white", "black"]

var COLORS = {
  yellow: { body: "#ffd24a", glow: "#ffb000", hot: "#fff4b8" },
  green:  { body: "#65ff96", glow: "#00e676", hot: "#d2ffe0" },
  red:    { body: "#ff5d6c", glow: "#ff1744", hot: "#ffd3d8" },
  purple: { body: "#c77dff", glow: "#a855f7", hot: "#efd9ff" },
  orange: { body: "#ffa94d", glow: "#ff7a00", hot: "#ffe3c2" },
  white:  { body: "#ffffff", glow: "#dfefff", hot: "#ffffff" },
  black:  { body: "#050505", glow: "#000000", hot: "#3a3a3a" }
}

function normalizedColor(name) {
  var key = String(name || "").toLowerCase()
  return Object.prototype.hasOwnProperty.call(COLORS, key) ? key : "yellow"
}

function colorFor(name) {
  return COLORS[normalizedColor(name)]
}

function labelFor(name) {
  var key = normalizedColor(name)
  return key.charAt(0).toUpperCase() + key.slice(1)
}

if (typeof module !== "undefined") {
  module.exports = {
    ORDER: ORDER,
    COLORS: COLORS,
    normalizedColor: normalizedColor,
    colorFor: colorFor,
    labelFor: labelFor
  }
}
