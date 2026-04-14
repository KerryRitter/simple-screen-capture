# simple-screen-capture

Screenshot, GIF, and screencast capture for Ubuntu/PopOS (X11) with a floating GTK menu.

## Install

```bash
bash <(curl -fsSL https://github.com/KerryRitter/simple-screen-capture/releases/latest/download/install.sh)
```

Press `Ctrl+Shift+Alt+4` to open the capture menu.

## Features

- **Screenshot** — select any area, copied to clipboard as Base64 or binary PNG, saved to `~/Pictures/Screenshots`
- **Record GIF** — select any area, records and converts to an optimised GIF
- **Record Screen** — select any area, records as MP4 (with optional audio)
- **Smart Slice** — automatically extracts key screenshots from a recording when notable screen changes are detected (tunable sensitivity slider)
- Persistent resizable region selector — the capture area is always visible before you commit
- Per-mode region memory — each mode remembers its last capture area

## Build from source

```bash
bash build.sh 1.7.0
sudo apt install ./simple-screen-capture_1.7.0_all.deb
simple-screen-capture --setup
```
