# FlashLearn × Windsurf (Codeium)

Windsurf has native Cascade hooks with a `pre_user_prompt` event.

## Setup

Add to your Windsurf settings:

```json
{
  "cascade.hooks": {
    "pre_user_prompt": [
      {
        "type": "shell",
        "command": "~/.flashlearn/scripts/flashlearn-hook.sh"
      }
    ]
  }
}
```

## How it works

`pre_user_prompt` fires before Cascade processes your prompt text. FlashLearn opens while Windsurf works on your request.

## Other available hooks

Windsurf has 12 hook events covering the full lifecycle:

- `pre_user_prompt` / `post_response`
- `pre_read` / `post_read`
- `pre_write` / `post_write`
- `pre_command` / `post_command`
- `pre_mcp` / `post_mcp`

Use `post_response` if you want FlashLearn to appear when Windsurf finishes instead.
