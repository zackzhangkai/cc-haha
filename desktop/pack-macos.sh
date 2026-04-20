#!/usr/bin/env bash
set -euo pipefail

# MacOS one-click pack script for the desktop app (Tauri + React)
# - Builds frontend assets
# - Packages macOS app via tauri
# - Locates the built .app bundle and prints its path
# - Suggestions for installation to /Applications

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================="
echo "MacOS Packaging Script (TAURI)"
echo "Root: $ROOT_DIR"
echo "=========================================="

echo "1) Install dependencies (root and desktop)"
if command -v bun >/dev/null 2>&1; then
  (cd "$ROOT_DIR" && bun install)
  (cd "$ROOT_DIR/desktop" && bun install)
elif command -v npm >/dev/null 2>&1; then
  (cd "$ROOT_DIR" && npm ci --silent 2>/dev/null || npm i --silent)
  (cd "$ROOT_DIR/desktop" && npm ci --silent 2>/dev/null || npm i --silent)
else
  echo "Error: Neither Bun nor NPM found. Install Bun or Node/NPM to proceed." >&2
  exit 1
fi

echo "2) Build frontend assets (best-effort)" 
if [ -f "$ROOT_DIR/package.json" ]; then
  if grep -q '\"build\"' "$ROOT_DIR/package.json" 2>/dev/null; then
    (cd "$ROOT_DIR" && (npm run build || (command -v bun >/dev/null 2>&1 && bunx npm run build) || true))
  else
    echo "   -> No root build script found. Skipping root build step." 
  fi
else
  echo "   -> Root package.json not found. Skipping root build step." 
fi

if [ -d "$ROOT_DIR/desktop" ]; then
  echo "3) Build frontend (desktop) assets (best-effort)" 
  if [ -f "$ROOT_DIR/desktop/package.json" ]; then
    if grep -q '\"build\"' "$ROOT_DIR/desktop/package.json" 2>/dev/null; then
      (cd "$ROOT_DIR/desktop" && (npm run build || (command -v bun >/dev/null 2>&1 && bunx npm run build) || true))
    else
      echo "   -> desktop/package.json has no build script. Skipping." 
    fi
  fi
fi

echo "4) Build macOS package with tauri"
RELEASE_CMD=""
if command -v bunx >/dev/null 2>&1; then
  RELEASE_CMD="bunx tauri build"
elif command -v npx >/dev/null 2>&1; then
  RELEASE_CMD="npx tauri build"
elif command -v npm >/dev/null 2>&1; then
  RELEASE_CMD="npx tauri build"
else
  echo "Error: No package runner (bunx or npm) found to run tauri build." >&2
  exit 1
fi

(cd "$ROOT_DIR/desktop" && eval "$RELEASE_CMD")

echo "5) Locate built macOS app bundle"
APP_BUNDLE="$(bash -lc 'ls -d "$ROOT_DIR/desktop/src-tauri/target/release/bundle/macos/*.app" 2>/dev/null | head -n 1')"
if [ -z "$APP_BUNDLE" ]; then
  echo "Warning: Could not locate app bundle in the standard path. Trying fallback search..."
  APP_BUNDLE="$(bash -lc 'find "$ROOT_DIR/desktop/src-tauri/target/release/bundle/macos" -name "*.app" -type d 2>/dev/null | head -n 1')"
fi

if [ -d "$APP_BUNDLE" ]; then
  echo "   App bundle found: $APP_BUNDLE"
else
  echo "   Could not automatically locate the .app bundle. Please check the tauri output for the app path."
fi

echo "6) Installation guidance"
if [ -d "$APP_BUNDLE" ]; then
  echo "   - To install locally: open Finder and drag the $(basename "$APP_BUNDLE") into /Applications/" 
  echo "   - Or run: cp -R '${APP_BUNDLE}' /Applications/ && open /Applications/$(basename "$APP_BUNDLE")/" 
fi

echo "Done."
