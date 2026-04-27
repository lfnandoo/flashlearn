# FlashLearn × Cursor

Cursor has native hooks via `.cursor/hooks/`.

## Setup

Create `.cursor/hooks/flashlearn.sh` in your project (or globally):

```bash
#!/bin/bash
~/.flashlearn/scripts/flashlearn-hook.sh
```

Then configure the hook in Cursor settings. Add to `.cursor/hooks/config.json`:

```json
{
  "hooks": {
    "beforeSubmitPrompt": [
      {
        "type": "command",
        "command": ".cursor/hooks/flashlearn.sh"
      }
    ]
  }
}
```

## How it works

`beforeSubmitPrompt` fires after you press send but before the request goes to the backend. FlashLearn opens while Cursor processes your prompt.

## Other available hooks

- `sessionStart` / `sessionEnd`
- `preToolUse` / `postToolUse`
- `beforeShellExecution`
- `afterAgentResponse`
- `stop`

You could also use `afterAgentResponse` to close or switch focus back.

## Quick one-liner setup

```bash
mkdir -p .cursor/hooks
cp ~/.flashlearn/integrations/cursor/flashlearn-hook.sh .cursor/hooks/
```
