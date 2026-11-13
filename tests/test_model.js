var assert = require("assert")
var fs = require("fs")
var path = require("path")
var Model = require(path.join(__dirname, "..", "ClockModel.js"))
var Glyphs = require(path.join(__dirname, "..", "Glyphs.js"))
var Palette = require(path.join(__dirname, "..", "Palette.js"))

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
assert.ok(Model.tooltipFor(true, false, "yellow", "large").indexOf("24-hour") !== -1)
assert.ok(Model.tooltipFor(false, true, "red", "small").indexOf("12-hour") !== -1)
assert.ok(Model.tooltipFor(false, true, "red", "small").indexOf("red") !== -1)
assert.ok(Model.tooltipFor(false, true, "red", "small").indexOf("small") !== -1)

// Size names and factors: large preserves the original proportions, and the
// three steps are strictly ordered in both orientations.
assert.deepStrictEqual(Model.DIGIT_SIZES, ["small", "medium", "large"])
assert.strictEqual(Model.normalizedDigitSize("small"), "small")
assert.strictEqual(Model.normalizedDigitSize("MEDIUM"), "medium")
assert.strictEqual(Model.normalizedDigitSize("huge"), "large")
assert.strictEqual(Model.normalizedDigitSize(undefined), "large")
assert.strictEqual(Model.horizontalSizeFactor("large"), 0.82)
assert.strictEqual(Model.verticalSizeFactor("large"), 0.57)
assert.ok(Model.horizontalSizeFactor("small") < Model.horizontalSizeFactor("medium"))
assert.ok(Model.horizontalSizeFactor("medium") < Model.horizontalSizeFactor("large"))
assert.ok(Model.verticalSizeFactor("small") < Model.verticalSizeFactor("medium"))
assert.ok(Model.verticalSizeFactor("medium") < Model.verticalSizeFactor("large"))

// Every glyph the clock can render has a path and a positive box width.
var requiredGlyphs = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", "A", "P", "M"]
requiredGlyphs.forEach(function(glyph) {
  assert.ok(Glyphs.pathFor(glyph).length > 0, "missing path for " + glyph)
  assert.ok(Glyphs.widthFor(glyph) > 0, "missing width for " + glyph)
})

// Palette: named colours including light-bar white and black, yellow fallback,
// and complete paint triples.
assert.deepStrictEqual(Palette.ORDER, ["yellow", "green", "red", "purple", "orange", "white", "black"])
Palette.ORDER.forEach(function(name) {
  var color = Palette.colorFor(name)
  assert.ok(color.body && color.glow && color.hot, "incomplete palette for " + name)
})
assert.strictEqual(Palette.normalizedColor("red"), "red")
assert.strictEqual(Palette.normalizedColor("RED"), "red")
assert.strictEqual(Palette.normalizedColor("cyan"), "yellow")
assert.strictEqual(Palette.normalizedColor(undefined), "yellow")
assert.strictEqual(Palette.labelFor("purple"), "Purple")
assert.strictEqual(Palette.labelFor("black"), "Black")

// Manifest options must stay in step with the panel's palette and size order.
var manifest = JSON.parse(fs.readFileSync(path.join(__dirname, "..", "manifest.json"), "utf8"))
var schema = manifest.barWidget.schema
var colorSchema = schema.filter(function(entry) { return entry.key === "digitColor" })[0]
var sizeSchema = schema.filter(function(entry) { return entry.key === "digitSize" })[0]
assert.ok(colorSchema, "manifest is missing digitColor")
assert.deepStrictEqual(colorSchema.options, Palette.ORDER)
assert.ok(Palette.ORDER.indexOf(manifest.barWidget.defaults.digitColor) !== -1)
assert.ok(sizeSchema, "manifest is missing digitSize")
assert.deepStrictEqual(sizeSchema.options, Model.DIGIT_SIZES)
assert.strictEqual(sizeSchema.defaultValue, "large")
assert.strictEqual(manifest.barWidget.defaults.digitSize, "large")
assert.ok(!schema.some(function(entry) { return entry.key === "digitStyle" }), "digitStyle should be gone")

console.log("Model tests passed: format, meridiem, seconds, ticks, glyphs, palette, sizes, manifest.")
