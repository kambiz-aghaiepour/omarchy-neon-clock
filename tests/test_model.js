var assert = require("assert")
var path = require("path")
var Model = require(path.join(__dirname, "..", "ClockModel.js"))
var Glyphs = require(path.join(__dirname, "..", "Glyphs.js"))

function at(hours, minutes, seconds) {
  return new Date(2026, 10, 12, hours, minutes, seconds || 0)
}

// 24-hour mode keeps midnight and noon as 00 and 12.
var midnight24 = Model.timeParts(at(0, 5, 9), true, true)
assert.strictEqual(midnight24.hourTens + midnight24.hourUnits, "00")
assert.strictEqual(midnight24.minuteTens + midnight24.minuteUnits, "05")
assert.strictEqual(midnight24.secondTens + midnight24.secondUnits, "09")
assert.strictEqual(midnight24.meridiem, "")

// 12-hour mode maps midnight/noon to 12 and emits a meridiem pair.
var midnight12 = Model.timeParts(at(0, 30), false, false)
assert.strictEqual(midnight12.hourTens + midnight12.hourUnits, "12")
assert.deepStrictEqual(midnight12.meridiemLetters, ["A", "M"])

var noon12 = Model.timeParts(at(12, 30), false, false)
assert.strictEqual(noon12.hourTens + noon12.hourUnits, "12")
assert.deepStrictEqual(noon12.meridiemLetters, ["P", "M"])

var evening12 = Model.timeParts(at(23, 59, 59), false, true)
assert.strictEqual(evening12.hourTens + evening12.hourUnits, "11")
assert.deepStrictEqual(evening12.meridiemLetters, ["P", "M"])
assert.strictEqual(evening12.secondTens + evening12.secondUnits, "59")

// Seconds cells stay addressable when hidden so QML keeps stable cells.
var minutesOnly = Model.timeParts(at(9, 8, 7), true, false)
assert.strictEqual(minutesOnly.secondTens, "0")
assert.strictEqual(minutesOnly.secondUnits, "7")
assert.strictEqual(minutesOnly.showsSeconds, false)

// Tick scheduling: always inside one step, including exact boundaries.
assert.strictEqual(Model.msUntilNextTick(0, 1000), 1000)
assert.strictEqual(Model.msUntilNextTick(999, 1000), 1)
assert.strictEqual(Model.msUntilNextTick(61000, 60000), 59000)

// Tooltip names the actual state.
assert.ok(Model.tooltipFor(true, false, "outlined").indexOf("24-hour") !== -1)
assert.ok(Model.tooltipFor(false, true, "filled").indexOf("12-hour") !== -1)
assert.ok(Model.tooltipFor(false, true, "filled").indexOf("filled") !== -1)

// Every glyph the clock can render has a path and a positive box width.
var required = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", "A", "P", "M"]
required.forEach(function(glyph) {
  assert.ok(Glyphs.pathFor(glyph).length > 0, "missing path for " + glyph)
  assert.ok(Glyphs.widthFor(glyph) > 0, "missing width for " + glyph)
})
assert.strictEqual(Glyphs.normalizedStyle("filled"), "filled")
assert.strictEqual(Glyphs.normalizedStyle("anything-else"), "outlined")
assert.ok(Glyphs.filledColonPath(":").length > 0)
assert.strictEqual(Glyphs.filledColonPath("8"), "")

console.log("Model tests passed: format, meridiem, seconds, ticks, glyphs.")
