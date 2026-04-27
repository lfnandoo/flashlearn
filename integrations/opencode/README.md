# FlashLearn × OpenCode

OpenCode has a plugin system with a `chat.message` hook that fires on each message.

## Setup

Create a plugin file at `.opencode/plugin/flashlearn.js` (project-level) or `~/.config/opencode/plugin/flashlearn.js` (global):

```javascript
import { exec } from "child_process";

export default (api) => {
  api.hook("chat.message", async (_msg, next) => {
    exec("~/.flashlearn/scripts/flashlearn-hook.sh");
    return next();
  });
};
```

OpenCode auto-loads plugins from these directories on startup. No other configuration needed.

## How it works

The `chat.message` hook intercepts each chat message. The hook launches FlashLearn asynchronously and passes the message through to OpenCode via `next()`. FlashLearn opens while OpenCode processes your request.

## Alternative hooks

OpenCode also exposes `event`, `tool.execute.before`, and `tool.execute.after` if you want different trigger points.
