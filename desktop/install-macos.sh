#!/usr/bin/env bash
set -euo pipefail

# Install a macOS .app bundle into /Applications.
# Usage: ./install-macos.sh /path/to/YourApp.app

APP_PATH="$1"
if [ -z "$APP_PATH" ]; then
  echo "Usage: $0 /path/to/YourApp.app" >&2
  exit 1
fi

if [ ! -d "$APP_PATH" ]; then
  echo "Error: App path not found: $APP_PATH" >&2
  exit 1
fi

echo "Installing $APP_PATH to /Applications/ (requires sudo)." 
sudo cp -R "$APP_PATH" /Applications/
echo "Installed. You can launched it from /Applications/$(basename "$APP_PATH")" 
