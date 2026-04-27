#!/bin/bash
SNOOZE_FILE="$HOME/.flashlearn/snooze"

if [ -f "$SNOOZE_FILE" ]; then
    SNOOZE_UNTIL=$(cat "$SNOOZE_FILE")
    NOW=$(date +%s)
    if [ "$NOW" -lt "$SNOOZE_UNTIL" ]; then
        exit 0
    fi
fi

open -a FlashLearn 2>/dev/null || open "$HOME/Applications/FlashLearn.app" 2>/dev/null
