# FlashLearn × VS Code (Continue.dev & other extensions)

For AI extensions that don't have native hooks (like Continue.dev), use VS Code tasks + keyboard shortcuts.

## Setup

### 1. Add a VS Code task

Add to `.vscode/tasks.json` in your project:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "FlashLearn",
            "type": "shell",
            "command": "~/.flashlearn/scripts/flashlearn-hook.sh",
            "presentation": { "reveal": "silent" },
            "problemMatcher": []
        }
    ]
}
```

### 2. Bind a keyboard shortcut

Add to `keybindings.json` (Cmd+Shift+P → "Open Keyboard Shortcuts JSON"):

```json
{
    "key": "ctrl+shift+f",
    "command": "workbench.action.tasks.runTask",
    "args": "FlashLearn"
}
```

Press `Ctrl+Shift+F` before sending your AI prompt.

## Alternative: File watcher for Continue.dev

Continue.dev writes conversation logs to `~/.continue/sessions/`. Watch for changes:

```bash
fswatch -0 ~/.continue/sessions/ | while IFS= read -r -d '' _; do
    ~/.flashlearn/scripts/flashlearn-hook.sh 2>/dev/null
done &
```

Requires `fswatch` (`brew install fswatch`).

## For extension authors

If you're building a VS Code AI extension, call the hook when the user sends a message:

```typescript
import { exec } from "child_process";

function onUserSentMessage() {
    exec("~/.flashlearn/scripts/flashlearn-hook.sh");
}
```
