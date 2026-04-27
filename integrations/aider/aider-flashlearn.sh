#!/bin/bash
# Wrapper that launches FlashLearn when you send a message in Aider.
# Usage: ./aider-flashlearn.sh [aider args...]
#
# Watches Aider's chat history file for changes and triggers FlashLearn.

HOOK="$HOME/.flashlearn/scripts/flashlearn-hook.sh"
HISTORY_FILE=".aider.chat.history.md"

cleanup() {
    [ -n "${FSWATCH_PID:-}" ] && kill "$FSWATCH_PID" 2>/dev/null
}
trap cleanup EXIT

# Start watching for chat history changes (indicates user sent a message)
if command -v fswatch &>/dev/null; then
    fswatch -0 "$HISTORY_FILE" 2>/dev/null | while IFS= read -r -d '' _; do
        "$HOOK" 2>/dev/null &
    done &
    FSWATCH_PID=$!
else
    echo "[FlashLearn] Install fswatch for auto-launch: brew install fswatch"
fi

# Run Aider with all passed arguments
aider "$@"
