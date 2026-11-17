# Codex hook: require filtered Xcode output

This hook intercepts raw `xcodebuild build` and `xcodebuild test` shell commands and tells Codex to rerun them through `xcsift`. It does not run the build itself. Commands that use `xcsift`, `xcodebuild -list`, unrelated commands, and malformed hook input are allowed through. The hook fails open if `jq` is unavailable or it cannot read the event payload.

The example is adapted from Antoine van der Lee's [“Agent hooks in Claude Code, Cursor, and Codex explained”](https://www.avanderlee.com/ai-development/agent-hooks-claude-code-cursor-codex/).

## Prerequisites on macOS

Install Homebrew if needed, then install `jq` and `xcsift`:

```sh
brew install jq xcsift
```

Keep this repository at a stable path. The examples below use `~/Developer/skills`; change that path if your clone is elsewhere. The hook script is invoked with `bash`, so it does not need its executable bit set.

## Install for this repository only

The repo includes `.codex/hooks.json`, which registers the hook for this project:

1. Open the repository in Codex.
2. Start a **new Codex session** if this one was already open when you added or changed the hook configuration. Codex may not load new hook definitions into an already running session.
3. Review and trust the hook as described under [Approve the hook](#approve-the-hook).

Project hooks load only from trusted project layers. This repository's `.codex/hooks.json` already points to the script using the Git root, so it works when Codex starts in a subdirectory.

## Install for all your Codex projects

Codex's user hook file is `~/.codex/hooks.json`, unless you have set `CODEX_HOME`; in that case, use `$CODEX_HOME/hooks.json`. Keep the script in this clone or copy it to a stable location. Add the following hook entry to the `hooks` object in that file. If the file already contains hooks, merge the `PreToolUse` array entry; do not replace the whole file.

This example assumes the repo is at `~/Developer/skills`. The command uses `$HOME` so the path expands in the shell, unlike a literal `~` inside quotes:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^Bash$",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/Developer/skills/hooks/require-xcsift.sh\"",
            "timeout": 5,
            "statusMessage": "Checking for unfiltered Xcode output"
          }
        ]
      }
    ]
  }
}
```

If your clone is elsewhere, replace `$HOME/Developer/skills` with its full path. If `CODEX_HOME` is set, put `hooks.json` in that directory instead of `~/.codex/`.

## Approve the hook

Codex lists hooks from the loaded hook configuration and requires review and trust before a non-managed hook can run. Trust is associated with the hook definition; changes may require another review.

- **Codex desktop app:** use **Settings → Hooks**, or select **Review hooks** in the composer if Codex presents that option.
- **Codex CLI:** enter `/hooks` in the composer.

Find the `require-xcsift.sh` command, inspect its path, event (`PreToolUse`), matcher (`^Bash$`), and timeout, then choose the review/trust action shown by your version of Codex.

Since hooks were added to your user configuration while the current session was running, start a new session before checking for it. If it still does not appear, quit and reopen Codex so it reloads configuration, then check the hook list again.

## Troubleshooting

1. **Check which user config Codex uses.** In Terminal, run `echo "${CODEX_HOME:-$HOME/.codex}/hooks.json"`. Confirm the hook is in that file, not only in the repository's project config.
2. **Check the JSON syntax.** Run `jq empty "${CODEX_HOME:-$HOME/.codex}/hooks.json"`. No output and exit code `0` means the JSON parsed.
3. **Check the script path and dependencies.** Confirm the path in `command` exists, and run `command -v jq` and `command -v xcsift`.
4. **Start a new session or restart Codex.** Hooks configured after a session started may not appear until Codex reloads its hook configuration.
5. **Check whether hooks are disabled.** A Codex configuration setting such as `[features] hooks = false` disables hook loading. Organization managed policy may also affect which hooks are available.
6. **Check the event and matcher.** This hook's handler runs for Bash tool calls only; it does not run for edits or other tool types.
7. **Review and trust it.** An untrusted hook can be listed but skipped until you approve it.

To check the script logic without running any Xcode command, you can send it a sample event directly:

```sh
printf '%s\n' '{"tool_input":{"command":"xcodebuild -scheme Example build"}}' \
  | bash "$HOME/Developer/skills/hooks/require-xcsift.sh"
```

It should print the filtered rerun suggestion and exit with status `2`. This only passes sample JSON to the script; it does not execute `xcodebuild`.

For current Codex hook locations, lifecycle, and trust behavior, see the [official Codex hooks documentation](https://developers.openai.com/codex/hooks).
