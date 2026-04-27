# FlashLearn × Aider

Aider doesn't have a native hook/event system, but you can wrap it to launch FlashLearn on each prompt.

## Setup

Use the wrapper script that monitors Aider's input and launches FlashLearn when you send a message:

```bash
# Instead of running `aider` directly, use:
./aider-flashlearn.sh
```

Or add an alias to your shell profile:

```bash
alias aider='~/.flashlearn/integrations/aider/aider-flashlearn.sh'
```

## How it works

The wrapper uses a named pipe (FIFO) to intercept when you press Enter in Aider's prompt, triggering the FlashLearn hook before passing input through to Aider. This is a lightweight approach that doesn't modify Aider itself.

## Alternative: filesystem watcher

If you prefer not to use the wrapper, you can watch Aider's chat history file:

```bash
# Aider appends to .aider.chat.history.md on each message
fswatch -0 .aider.chat.history.md | xargs -0 -I {} ~/.flashlearn/scripts/flashlearn-hook.sh &
```

This requires `fswatch` (`brew install fswatch`).
