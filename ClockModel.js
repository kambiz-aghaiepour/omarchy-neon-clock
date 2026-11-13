// Pure time formatting and tick scheduling for the neon clock. Kept free of
// QML so the display rules can be tested with Node.

function pad2(value) {
  var number = Math.max(0, Math.floor(value))
  return (number < 10 ? "0" : "") + number
}

function meridiemFor(hours) {
  return hours < 12 ? "AM" : "PM"
}

// Returns the character cells the bar paints. `secondTens` and `secondUnits`
// are always present so the widget can keep stable cells when seconds are
// toggled; the caller hides them instead of rebuilding the row.
function timeParts(date, use24Hour, showSeconds) {
  var hours = date.getHours()
  var displayHour = use24Hour ? hours : (hours % 12 === 0 ? 12 : hours % 12)
  var meridiem = use24Hour ? "" : meridiemFor(hours)
  var minute = pad2(date.getMinutes())
  var second = pad2(date.getSeconds())
  var hour = pad2(displayHour)

  return {
    hourTens: hour.charAt(0),
    hourUnits: hour.charAt(1),
    minuteTens: minute.charAt(0),
    minuteUnits: minute.charAt(1),
    secondTens: second.charAt(0),
    secondUnits: second.charAt(1),
    meridiem: meridiem,
    meridiemLetters: meridiem === "" ? [] : [meridiem.charAt(0), meridiem.charAt(1)],
    showsSeconds: !!showSeconds
  }
}

// Milliseconds until the next whole `step` boundary. Epoch milliseconds never
// repeat, so the delay stays inside one step across daylight-saving changes.
function msUntilNextTick(nowMs, step) {
  var safeStep = Math.max(1, Math.floor(step))
  return safeStep - (nowMs % safeStep)
}

function tooltipFor(use24Hour, showSeconds, digitColor) {
  var time = use24Hour ? "24-hour" : "12-hour"
  var seconds = showSeconds ? "seconds on" : "seconds off"
  return "Neon Clock · " + time + ", " + seconds + ", " + String(digitColor) + " · right-click for options"
}

if (typeof module !== "undefined") {
  module.exports = {
    pad2: pad2,
    meridiemFor: meridiemFor,
    timeParts: timeParts,
    msUntilNextTick: msUntilNextTick,
    tooltipFor: tooltipFor
  }
}
