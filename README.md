# Skills and hooks

Reusable agent skills and hooks for maintaining iOS apps.

## Repository layout

- `skills/` contains installable skills.
- `hooks/` contains hook scripts.
- `.codex/hooks.json` registers the project hook for Codex. Codex requires you to review and trust it before it runs.

## Install

This is a public repository: [github.com/bravelocation/skills](https://github.com/bravelocation/skills). You do not need to install Vercel's `skills` CLI globally: `npx` downloads and runs it for each command. You only need Node.js and npm (which includes `npx`). No GitHub sign-in is needed.

Install the main skills for Codex:

```sh
npx skills add https://github.com/bravelocation/skills --skill adversarial-bug-hunt --skill app-store-creative-assets --agent codex
```

To install the code review skill as well:

```sh
npx skills add https://github.com/bravelocation/skills --skill code-review --agent codex
```

To install one skill, use its directory name:

```sh
npx skills add https://github.com/bravelocation/skills --skill app-store-creative-assets --agent codex
```

Or install `code-review` by itself:

```sh
npx skills add https://github.com/bravelocation/skills --skill code-review --agent codex
```

Add `--global` to make the skills available across projects. Without it, the CLI installs them for the current project. Omit `--agent codex` to choose an agent interactively or specify another supported agent, such as `claude-code` or `cursor`.

To see the skills available in this repository without installing them:

```sh
npx skills add https://github.com/bravelocation/skills --list
```

Each skill lives in its own directory under `skills/` with a `SKILL.md`. No npm package or installer script is required. Keep each skill's directory name aligned with its `name` in `SKILL.md`; `agents/openai.yaml` can provide display metadata for compatible clients.

## Codex hook: filtered Xcode output

The project hook blocks raw `xcodebuild build` and `xcodebuild test` shell commands and tells Codex to rerun them through `xcsift`. Install `xcsift` separately. The hook fails open if it cannot parse the event input, uses a five-second timeout, and leaves unrelated commands alone.

**Attribution:** This hook adapts the Xcode output filtering example by Antoine van der Lee in [“Agent hooks in Claude Code, Cursor, and Codex explained”](https://www.avanderlee.com/ai-development/agent-hooks-claude-code-cursor-codex/). The script and Codex registration here are adapted for this repository.

### Install for this project

From the repository root, install the two command-line dependencies:

```sh
brew install jq xcsift
```

Open this repository in Codex. Codex reads `.codex/hooks.json` from a trusted project. In Codex, open `/hooks`, inspect the `require-xcsift.sh` hook, and trust it. It will then apply in this repository. `xcodebuild -list` and commands already using `xcsift` are left alone.

### Install for all your Codex projects

The repo's `.codex/hooks.json` is project-scoped. For a user-wide hook, keep the script in this clone (or copy it to a stable location), then add this entry to `~/.codex/hooks.json`. If that file already exists, merge the `PreToolUse` entry into its existing `hooks` object rather than replacing the file. Replace `/absolute/path/to/skills` with this repository's actual path.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^Bash$",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"/absolute/path/to/skills/hooks/require-xcsift.sh\"",
            "timeout": 5,
            "statusMessage": "Checking for unfiltered Xcode output"
          }
        ]
      }
    ]
  }
}
```

Restart or reload Codex if needed, then open `/hooks` to review and trust the user-level hook. Codex records trust for the specific hook definition and asks for review again if it changes. See [Codex hooks documentation](https://developers.openai.com/codex/hooks) for hook locations, trust, and configuration details.
