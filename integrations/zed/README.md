# FlashLearn × Zed AI

Zed's extension API doesn't expose AI prompt events yet. Use one of these workarounds.

## Option 1: zsh preexec hook (if using Zed's terminal)

```zsh
# Add to ~/.zshrc — triggers FlashLearn when you run any `zed` AI command
autoload -Uz add-zsh-hook

flashlearn_preexec() {
    if [[ "$1" == *zed* ]]; then
        ~/.flashlearn/scripts/flashlearn-hook.sh &
    fi
}
add-zsh-hook preexec flashlearn_preexec
```

## Option 2: Log file watcher

Monitor Zed's log files for AI activity:

```bash
# Watch Zed logs for AI panel activity
fswatch -0 ~/Library/Logs/Zed/ 2>/dev/null | while IFS= read -r -d '' _; do
    ~/.flashlearn/scripts/flashlearn-hook.sh 2>/dev/null
done &
```

Requires `fswatch` (`brew install fswatch`).

## Option 3: Global keyboard shortcut

Use macOS Automator or Hammerspoon to bind a key that launches FlashLearn. Press it before sending your AI prompt.

```lua
-- Hammerspoon: Ctrl+Shift+F launches FlashLearn
hs.hotkey.bind({"ctrl", "shift"}, "f", function()
    os.execute("~/.flashlearn/scripts/flashlearn-hook.sh &")
end)
```

## Future

Zed's extension API is actively evolving. When AI prompt hooks become available, a native integration will be added here.
