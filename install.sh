#!/usr/bin/env bash
set -euo pipefail

PLATFORM=$(uname -s)
REPO="KerryRitter/simple-screen-capture"
INSTALL_DIR="/usr/local/bin"

install_macos() {
  echo "Checking dependencies..."
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is required. Install from https://brew.sh then re-run this script."
    exit 1
  fi

  MISSING=()
  command -v ffmpeg  &>/dev/null || MISSING+=(ffmpeg)
  command -v optipng &>/dev/null || MISSING+=(optipng)
  if (( ${#MISSING[@]} )); then
    echo "Installing: ${MISSING[*]}"
    brew install "${MISSING[@]}"
  fi

  # Python tkinter (needed for the region selector UI)
  if ! python3 -c "import tkinter" 2>/dev/null; then
    echo "Installing python-tk..."
    brew install python-tk 2>/dev/null || \
      brew install python-tk@$(python3 --version | sed 's/Python \([0-9]\.[0-9]*\).*/\1/') 2>/dev/null || true
  fi

  echo "Downloading simple-screen-capture..."
  TMP_DIR=$(mktemp -d /tmp/simple-screen-capture-XXXXXX)
  trap 'rm -rf "$TMP_DIR"' EXIT

  SCRIPTS=(simple-screen-capture capture-region capture-stop capture-upload)
  for script in "${SCRIPTS[@]}"; do
    curl -fsSL \
      "https://raw.githubusercontent.com/${REPO}/main/src/${script}" \
      -o "${TMP_DIR}/${script}"
    chmod +x "${TMP_DIR}/${script}"
  done

  echo "Installing to ${INSTALL_DIR}..."
  for script in "${SCRIPTS[@]}"; do
    sudo cp "${TMP_DIR}/${script}" "${INSTALL_DIR}/${script}"
  done

  echo ""
  echo "Done! Run: simple-screen-capture --setup"
  echo "(For a global hotkey, see the instructions printed by --setup-shortcut)"
}

install_linux() {
  TMP=$(mktemp /tmp/simple-screen-capture-XXXXXX.deb)
  trap 'rm -f "$TMP"' EXIT

  echo "Downloading simple-screen-capture..."
  curl -fsSL "https://github.com/${REPO}/releases/latest/download/$(
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
      | grep '"name".*\.deb' | head -1 | sed 's/.*"name": "\(.*\)".*/\1/'
  )" -o "$TMP"

  echo "Installing..."
  sudo apt install -y "$TMP"

  if [[ -n "${CAPTURE_CONFIG:-}" ]]; then
    echo "Setting up shortcut..."
    simple-screen-capture --setup-shortcut
    echo "Importing shared R2 config..."
    simple-screen-capture --import-config "$CAPTURE_CONFIG"
  else
    simple-screen-capture --setup
  fi

  echo ""
  echo "Done. Press Ctrl+Shift+Alt+4 to open the capture panel."
}

if [[ "$PLATFORM" == "Darwin" ]]; then
  install_macos
else
  install_linux
fi
