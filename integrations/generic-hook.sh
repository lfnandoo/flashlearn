#!/bin/bash
# Generic FlashLearn hook — launch FlashLearn if not snoozed.
# Coding agents can call this script when the user submits a prompt.
#
# Usage: add this as a callback/hook in your coding agent's config.
# The script respects snooze — it won't steal focus while snoozed.

SNOOZE_FILE="$HOME/.flashlearn/snooze"

if [ -f "$SNOOZE_FILE" ]; then
    SNOOZE_UNTIL=$(cat "$SNOOZE_FILE")
    NOW=$(date +%s)
    if [ "$NOW" -lt "$SNOOZE_UNTIL" ]; then
        exit 0
    fi
fi

open -a FlashLearn 2>/dev/null || open "$HOME/Applications/FlashLearn.app" 2>/dev/null
