# Neon Clock

[![Built for Omarchy: Plugin](https://raw.githubusercontent.com/tcballard/omarchy-badges/75975e5b5bf75e7ede3764bcd2950046f7abfe2c/badges/v1/omarchy-plugin.svg)](https://github.com/tcballard/omarchy-badges)

A standalone neon digital clock for the Omarchy bar. It does not replace the
built-in clock: both can be placed in the bar at the same time.

![Neon Clock in the Omarchy bar](screenshots/neon-clock-upper-left.png)

## Features

- Outlined neon digits in yellow, green, red, purple, light blue, orange, white, or black.
  White and black suit light bars.
- Three digit sizes: small, medium, large.
- 24-hour or 12-hour display; 12-hour mode adds AM/PM.
- Optional seconds.
- Every changed digit rolls up: the new digit enters from below while the old
  one leaves above.
- Digits, colon and AM/PM scale to the bar and support horizontal and vertical
  bars.
- No font, package, network, or privileged setup; glyphs are vector paths.

## Controls

Right-click the clock to open the control panel:

- 24-hour or 12-hour time.
- Show or hide seconds.
- Digit color: yellow, green, red, purple, light blue, orange, white, black.
- Digit size: small, medium, large.

![Neon Clock control panel](screenshots/neon-clock-controls.png)

Settings are stored inline on this plugin's entry in
`~/.config/omarchy/shell.json`:

```json
{
  "id": "io.github.kambiz.neon-clock",
  "use24Hour": true,
  "showSeconds": false,
  "digitColor": "yellow",
  "digitSize": "large"
}
```

## Requirements

- Omarchy 4 with Quattro shell-plugin support.
- No additional package, authentication, or privileged setup is required.

## Installation

```bash
omarchy plugin add https://github.com/kambiz-aghaiepour/omarchy-neon-clock.git --enable
```

For a local checkout:

```bash
omarchy plugin add "$(pwd)" --enable
```

## Validation and tests

```bash
./tests/run
omarchy plugin validate .
```

`./tests/run` validates the manifest, runs the pure formatting, glyph, palette
and manifest-consistency tests with Node when available, and lints the
standalone QML. The preview harness is separate:

```bash
./preview/run
```

It writes `preview/neon-clock-preview.png` using the offscreen Qt platform.

## Architecture

| File | Role |
| --- | --- |
| `BarWidget.qml` | Hosted bar entry: ticking, settings, click handling, popup lifecycle. |
| `NeonTime.qml` | Horizontal and vertical layout of digits, colon, and meridiem. |
| `NeonDigit.qml` | One clipped cell with the vertical roll animation. |
| `NeonGlyph.qml` | Outlined neon renderer: glow, tube body, and hot filament. |
| `Glyphs.js` | Centre-line paths for `0`–`9`, `:`, `A`, `P`, `M`. |
| `Palette.js` | Named digit colors and their body, glow, and filament values. |
| `ClockModel.js` | Time formatting, AM/PM, tick alignment, digit-size factors, tooltip text. |
| `ControlPanel.qml` | Right-click `PopupCard` with the time, color, and size controls. |

## Update

```bash
omarchy plugin update io.github.kambiz.neon-clock
```

## Removal

```bash
omarchy plugin remove io.github.kambiz.neon-clock
```

The plugin stores no data outside normal Omarchy shell configuration.

## Security

Omarchy plugins run as unsandboxed code inside `omarchy-shell`. Review this
repository before enabling it. The plugin launches no processes and reads no
files.

## License

MIT © 2026 Kambiz
