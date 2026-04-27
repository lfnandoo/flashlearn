#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="FlashLearn"
INSTALL_DIR="$HOME/Applications"
DATA_DIR="$HOME/.flashlearn"

echo "Building $APP_NAME..."
"$PROJECT_DIR/scripts/build.sh"

echo "Installing..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$DATA_DIR/cards"

# Kill existing instance
pkill -f "$APP_NAME.app/Contents/MacOS/$APP_NAME" 2>/dev/null || true
sleep 1

# Copy app bundle
rm -rf "$INSTALL_DIR/$APP_NAME.app"
cp -R "$PROJECT_DIR/.build/$APP_NAME.app" "$INSTALL_DIR/"

# Copy sample cards if cards directory is empty
if [ -z "$(ls -A "$DATA_DIR/cards" 2>/dev/null)" ]; then
    echo "Copying sample cards..."
    cp "$PROJECT_DIR/sample-cards/"*.md "$DATA_DIR/cards/"
fi

# Make hook script executable and copy to data dir
mkdir -p "$DATA_DIR/scripts"
cp "$PROJECT_DIR/scripts/flashlearn-hook.sh" "$DATA_DIR/scripts/"
chmod +x "$DATA_DIR/scripts/flashlearn-hook.sh"

echo ""
echo "Installed to: $INSTALL_DIR/$APP_NAME.app"
echo "Cards directory: $DATA_DIR/cards/"
echo "Hook script: $DATA_DIR/scripts/flashlearn-hook.sh"
echo ""
echo "To launch: open -a FlashLearn"
echo ""
echo "To install LaunchAgent (auto-start on login):"
echo "  cp $PROJECT_DIR/launchd/com.flashlearn.app.plist ~/Library/LaunchAgents/"
echo "  launchctl load ~/Library/LaunchAgents/com.flashlearn.app.plist"
echo ""
echo "To add Claude Code hook, add to ~/.claude/settings.json:"
echo '  "hooks": { "Stop": [{ "hooks": [{ "type": "command", "command": "~/.flashlearn/scripts/flashlearn-hook.sh" }] }] }'
