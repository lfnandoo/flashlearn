#!/bin/bash
# Wrapper that launches FlashLearn before running Codex CLI.
# Usage: codex-flashlearn.sh [codex args...]

"$HOME/.flashlearn/scripts/flashlearn-hook.sh" 2>/dev/null &
exec codex "$@"
