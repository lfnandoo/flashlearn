# FlashLearn × OpenAI Codex CLI

Codex CLI has native hooks support (requires the `codex_hooks` feature flag).

## Option 1: Native hook (recommended)

Add to your Codex `hooks.json` or `config.toml`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "~/.flashlearn/scripts/flashlearn-hook.sh"
      }
    ]
  }
}
```

This fires when you send a message — FlashLearn opens while Codex works.

## Option 2: Wrapper script

If hooks aren't available in your Codex version:

```bash
# Use the wrapper instead of `codex` directly:
./codex-flashlearn.sh "your prompt here"

# Or add an alias to ~/.zshrc:
alias codex='~/.flashlearn/integrations/codex/codex-flashlearn.sh'
```

## Option 3: zsh preexec hook

Automatically trigger on any `codex` invocation:

```zsh
# Add to ~/.zshrc
autoload -Uz add-zsh-hook

flashlearn_preexec() {
    if [[ "$1" == codex* ]]; then
        ~/.flashlearn/scripts/flashlearn-hook.sh &
    fi
}
add-zsh-hook preexec flashlearn_preexec
```
