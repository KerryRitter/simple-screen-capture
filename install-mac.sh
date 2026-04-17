#!/usr/bin/env bash
# install-mac.sh — install simple-screen-capture on macOS
set -euo pipefail

REPO="KerryRitter/simple-screen-capture"
INSTALL_DIR="/usr/local/bin"
SCRIPTS=(simple-screen-capture capture-region capture-stop capture-upload)

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew is required."
  echo "Install it from https://brew.sh then re-run this script."
  exit 1
fi

# ── system deps ───────────────────────────────────────────────────────────────
MISSING=()
command -v ffmpeg  &>/dev/null || MISSING+=(ffmpeg)
command -v optipng &>/dev/null || MISSING+=(optipng)
if (( ${#MISSING[@]} )); then
  echo "Installing: ${MISSING[*]}"
  brew install "${MISSING[@]}"
fi

# tkinter (needed for the region-selector UI)
if ! python3 -c "import tkinter" &>/dev/null; then
  PY_VER=$(python3 --version 2>&1 | sed 's/Python \([0-9]\.[0-9]*\).*/\1/')
  echo "Installing python-tk@${PY_VER}..."
  brew install "python-tk@${PY_VER}" 2>/dev/null || brew install python-tk 2>/dev/null || true
fi

# ── download & install scripts ────────────────────────────────────────────────
TMP_DIR=$(mktemp -d /tmp/simple-screen-capture-XXXXXX)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading simple-screen-capture..."
for script in "${SCRIPTS[@]}"; do
  curl -fsSL \
    "https://raw.githubusercontent.com/${REPO}/main/src/${script}" \
    -o "${TMP_DIR}/${script}"
  chmod +x "${TMP_DIR}/${script}"
done

echo "Installing to ${INSTALL_DIR} (may prompt for sudo)..."
for script in "${SCRIPTS[@]}"; do
  sudo install -m 755 "${TMP_DIR}/${script}" "${INSTALL_DIR}/${script}"
done

# ── first-time setup ──────────────────────────────────────────────────────────
echo ""
if [[ -n "${CAPTURE_CONFIG:-}" ]]; then
  echo "Importing shared S3/R2 config..."
  simple-screen-capture --import-config "$CAPTURE_CONFIG"
else
  simple-screen-capture --setup
fi

echo ""
echo "Done. Run: simple-screen-capture"
echo ""
echo "Screen Recording permission: the first time you capture, macOS will"
echo "prompt for Screen Recording access — grant it in System Settings."
