# FlashLearn × Cline

Cline has native hooks with a `UserPromptSubmit` event (v3.36+).

## Setup

Create the hook script at `~/.cline/hooks/flashlearn.sh` (global) or `.clinerules/hooks/flashlearn.sh` (project):

```bash
#!/bin/bash
~/.flashlearn/scripts/flashlearn-hook.sh
```

Make it executable:

```bash
chmod +x ~/.cline/hooks/flashlearn.sh
```

Configure in Cline's hook settings to run on `UserPromptSubmit`.

## Quick setup

```bash
mkdir -p ~/.cline/hooks
cp ~/.flashlearn/integrations/cline/flashlearn-hook.sh ~/.cline/hooks/
chmod +x ~/.cline/hooks/flashlearn-hook.sh
```

## How it works

`UserPromptSubmit` fires when you send a message. The hook receives prompt text and attachments as JSON on stdin. FlashLearn opens while Cline processes your request.

## Other available hooks

- `TaskStart` — when a new task begins
- `PreToolUse` — before Cline uses a tool
- `PostToolUse` — after tool execution

## Requirements

- Cline v3.36 or later
- macOS or Linux (hooks not available on Windows)
