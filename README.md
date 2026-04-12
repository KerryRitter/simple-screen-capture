# simple-screen-capture

Screenshot, GIF, and screencast capture for Linux (X11) with a floating menu.

## Features

- **Screenshot** — select any area, copied to clipboard as Base64 or binary PNG, saved to `~/Pictures/Screenshots`
- **Record GIF** — select any area, records and converts to an optimised GIF
- **Record Screen** — select any area, records as MP4 (with optional audio)
- Persistent resizable region selector — the capture area is visible *before* you commit
- Triggered by a global keyboard shortcut: `Ctrl+Shift+Alt+R`

## Install

Download the latest `.deb` from [Releases](../../releases/latest), then:

```bash
sudo apt install ./simple-screen-capture_*.deb
capture-setup
```

`capture-setup` is a one-time per-user step that wires up the keyboard shortcut.

## Dependencies

Pulled in automatically by apt:

`rofi` `maim` `ffmpeg` `xclip` `optipng` `xbindkeys` `python3-gi` `libnotify-bin` `x11-utils`

## Build from source

```bash
bash build.sh 1.0.0
sudo apt install ./simple-screen-capture_1.0.0_all.deb
```
