MacOS packaging guide (One-click, macOS only)

- This repository now includes a script to package the desktop app for macOS and an optional installer.
- Prerequisites: macOS, Xcode command line tools installed, Rust toolchain, Node/Bun, and tauri CLI available (via bunx tauri build or npm/yarn). 
- Steps:
 1. Ensure dependencies are installed:
     - bash, bun, node, rust (rustup)
 2. Make scripts executable:
     - chmod +x desktop/pack-macos.sh
     - chmod +x desktop/install-macos.sh
 3. Run the pack script (macOS only):
     - From repo root: ./desktop/pack-macos.sh
 4. After packaging, locate the .app bundle path printed by the script and install:
     - You can drag the produced .app to /Applications, or
     - Use the installer script: ./desktop/install-macos.sh /path/to/YourApp.app
 
- Notes:
  - The script prints the app path and install suggestions automatically.
  - If you want to build a DMG, you may configure tauri's bundle.dmg in tauri.conf.json and run the same script again.
- Steps:
-  1. Ensure dependencies are installed:
- Steps:
-  1. Ensure dependencies are installed:
-     - bash, bun, node, rust (rustup)
-  2. Make scripts executable:
-     - chmod +x desktop/pack-macos.sh
-     - chmod +x desktop/install-macos.sh
-  3. Run the pack script (macOS only):
-     - From repo root: ./desktop/pack-macos.sh
-  4. After packaging, locate the .app bundle path printed by the script and install:
-     - You can drag the produced .app to /Applications, or
-     - Use the installer script: ./desktop/install-macos.sh /path/to/YourApp.app
-  5. Optional: Use one-click installer script: ./desktop/install-all-macos.sh
- 
- Notes:
-  - The script prints the app path and install suggestions automatically.
-  - If you want to build a DMG, you may configure tauri's bundle.dmg in tauri.conf.json and run the same script again.
-
- End of macOS packaging guide.
-
