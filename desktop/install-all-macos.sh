#!/usr/bin/env bash
set -euo pipefail

##############################################################
# One-click macOS install: package + install to /Applications
##############################################################
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[macOS] Starting one-click package+install for $(basename "$ROOT_DIR")"

echo "1) Ensure scripts are executable" 
chmod +x "$ROOT_DIR/desktop/pack-macos.sh" "$ROOT_DIR/desktop/install-macos.sh" || true

echo "2) Package the app for macOS" 
(cd "$ROOT_DIR" && "$ROOT_DIR/desktop/pack-macos.sh")

echo "3) Locate the generated .app bundle" 
APP_BUNDLE="$(bash -lc 'ls -d "$ROOT_DIR/desktop/src-tauri/target/release/bundle/macos/*.app" 2>/dev/null | head -n1')"
if [ -z "$APP_BUNDLE" ]; then
  echo "Error: Could not locate macOS .app bundle. Please check the pack script output." >&2
  exit 1
fi
echo "   Found: $APP_BUNDLE"

echo "4) Install to /Applications" 
"$ROOT_DIR/desktop/install-macos.sh" "$APP_BUNDLE"

echo "5) Launch installed app from /Applications" 
open "/Applications/$(basename "$APP_BUNDLE")"

echo "Done."
