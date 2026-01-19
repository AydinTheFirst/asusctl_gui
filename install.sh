#!/bin/bash

# --- CONFIGURATION ---
REPO_OWNER="AydinTheFirst" 
REPO_NAME="asusctl_gui"

APP_NAME="asusctl_gui"
PRETTY_NAME="AsusCtl GUI"
INSTALL_DIR="/opt/$APP_NAME"
ICON_PATH="$INSTALL_DIR/data/flutter_assets/assets/icon.png"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}>>> AsusCtl GUI Installer ${NC}"

# 1. Check for Dependencies (curl & tar)
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: 'curl' is required but not installed.${NC}"
    exit 1
fi

# 2. Get Latest Release URL from GitHub API
echo "Fetching latest release info from GitHub..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" \
| grep "browser_download_url" \
| grep ".tar.gz" \
| cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}Error: Could not find a release file on GitHub.${NC}"
    echo "Check if the repository '$REPO_OWNER/$REPO_NAME' exists and has a .tar.gz release."
    exit 1
fi

echo -e "Found latest version: ${GREEN}$DOWNLOAD_URL${NC}"

# 3. Create Temp Directory & Download
TEMP_DIR=$(mktemp -d)
echo "Downloading to temporary folder..."
curl -L -o "$TEMP_DIR/app.tar.gz" "$DOWNLOAD_URL" --progress-bar

if [ ! -f "$TEMP_DIR/app.tar.gz" ]; then
    echo -e "${RED}Download failed!${NC}"
    exit 1
fi

# 4. Clean up Old Installation
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing previous installation..."
    sudo rm -rf "$INSTALL_DIR"
fi
sudo mkdir -p "$INSTALL_DIR"

# 5. Extract Files to /opt
echo "Installing to $INSTALL_DIR..."
sudo tar -xzf "$TEMP_DIR/app.tar.gz" -C "$INSTALL_DIR"

# 6. Set Executable Permissions
sudo chmod +x "$INSTALL_DIR/$APP_NAME"

# 7. Create Symlink
echo "Creating symlink..."
sudo rm -f "/usr/bin/$APP_NAME"
sudo ln -s "$INSTALL_DIR/$APP_NAME" "/usr/bin/$APP_NAME"

# 8. Create Desktop Entry
echo "Creating menu shortcut..."
DESKTOP_FILE="/usr/share/applications/$APP_NAME.desktop"

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

# 9. Finalize
sudo update-desktop-database /usr/share/applications/
rm -rf "$TEMP_DIR" # Clean temp files

echo -e "${GREEN}✔ Installation Complete!${NC}"
echo "You can run '$APP_NAME' from your terminal or application menu."