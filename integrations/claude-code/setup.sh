#!/bin/bash
set -euo pipefail

# FlashLearn × Claude Code integration setup
# Adds a UserPromptSubmit hook so FlashLearn opens when you send a message

SETTINGS_FILE="$HOME/.claude/settings.json"
HOOK_SCRIPT="$HOME/.flashlearn/scripts/flashlearn-hook.sh"
SKILLS_SOURCE="$(cd "$(dirname "$0")/skills" && pwd)"
SKILLS_DEST="$HOME/.claude/skills"

if [ ! -f "$HOOK_SCRIPT" ]; then
    echo "Error: FlashLearn not installed. Run scripts/install.sh first."
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "Error: jq is required. Install with: brew install jq"
    exit 1
fi

echo "Setting up Claude Code integration..."

# Add UserPromptSubmit hook
if [ -f "$SETTINGS_FILE" ]; then
    # Check if hook already exists
    if jq -e '.hooks.UserPromptSubmit' "$SETTINGS_FILE" &>/dev/null; then
        ALREADY=$(jq -r '.hooks.UserPromptSubmit[].hooks[].command // empty' "$SETTINGS_FILE" | grep -c flashlearn || true)
        if [ "$ALREADY" -gt 0 ]; then
            echo "Hook already configured — skipping."
        else
            # Append to existing UserPromptSubmit hooks
            jq '.hooks.UserPromptSubmit[0].hooks += [{"type":"command","command":"~/.flashlearn/scripts/flashlearn-hook.sh","async":true}]' \
                "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "Added FlashLearn hook to existing UserPromptSubmit hooks."
        fi
    else
        # Create UserPromptSubmit hook
        jq '.hooks.UserPromptSubmit = [{"hooks":[{"type":"command","command":"~/.flashlearn/scripts/flashlearn-hook.sh","async":true}]}]' \
            "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "Added UserPromptSubmit hook."
    fi
else
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    cat > "$SETTINGS_FILE" <<'SETTINGS'
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.flashlearn/scripts/flashlearn-hook.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
SETTINGS
    echo "Created settings.json with FlashLearn hook."
fi

# Install skills
mkdir -p "$SKILLS_DEST"
if [ -d "$SKILLS_SOURCE" ]; then
    cp "$SKILLS_SOURCE"/*.md "$SKILLS_DEST/" 2>/dev/null || true
    echo "Installed skills to $SKILLS_DEST/"
fi

echo ""
echo "Done! FlashLearn will open when you send a message in Claude Code."
echo "Use /create-flashcards in Claude Code to generate new decks."
