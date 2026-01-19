#!/bin/bash

# Settings
APP_NAME="asusctl_gui"
PRETTY_NAME="AsusCtl GUI"
INSTALL_DIR="/opt/$APP_NAME"
ICON_PATH="$INSTALL_DIR/data/flutter_assets/assets/icon.png"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ">>> Installation starting..."

# 1. Clean up & Create Directory
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing previous installation..."
    sudo rm -rf "$INSTALL_DIR"
fi
sudo mkdir -p "$INSTALL_DIR"

# 2. Copy Files
BUILD_PATH="build/linux/x64/release/bundle"

if [ -d "$BUILD_PATH" ]; then
    echo "Copying files to $INSTALL_DIR..."
    sudo cp -r $BUILD_PATH/* "$INSTALL_DIR/"
else
    echo -e "${RED}ERROR: Build directory not found at: $BUILD_PATH${NC}"
    echo "Please run 'flutter build linux --release' first."
    exit 1
fi

# 3. Set Permissions
sudo chmod +x "$INSTALL_DIR/$APP_NAME"

# 4. Create Symlink (Allows running 'asusctl_gui' from terminal)
echo "Creating symlink in /usr/bin..."
sudo rm -f "/usr/bin/$APP_NAME"
sudo ln -s "$INSTALL_DIR/$APP_NAME" "/usr/bin/$APP_NAME"

# 5. Create Desktop Entry
DESKTOP_FILE="/usr/share/applications/$APP_NAME.desktop"
echo "Creating desktop entry..."

# Using 'tee' handles sudo permission for file redirection better
cat <<EOF | sudo tee "$DESKTOP_FILE" > /dev/null
[Desktop Entry]
Name=$PRETTY_NAME
Comment=GUI for AsusCtl
Exec=/usr/bin/$APP_NAME
Icon=$ICON_PATH
Type=Application
Categories=Utility;System;
Terminal=false
EOF

# 6. Update Desktop Database
sudo update-desktop-database /usr/share/applications/

echo -e "${GREEN}✔ $PRETTY_NAME installed successfully!${NC}"
echo "You can launch it from your applications menu or by running '$APP_NAME' in the terminal."

exit 0