# Skills

A collection of useful AI skills I've developed to help maintain my iOS apps.

## Install

This is a public repository: [github.com/bravelocation/skills](https://github.com/bravelocation/skills). You do not need to install Vercel's `skills` CLI globally: `npx` downloads and runs it for each command. You only need Node.js and npm (which includes `npx`). No GitHub sign-in is needed.

Install both skills for Codex:

```sh
npx skills add https://github.com/bravelocation/skills --skill adversarial-bug-hunt --skill app-store-creative-assets --agent codex
```

To install one skill, use its directory name:

```sh
npx skills add https://github.com/bravelocation/skills --skill app-store-creative-assets --agent codex
```

Add `--global` to make the skills available across projects. Without it, the CLI installs them for the current project. Omit `--agent codex` to choose an agent interactively or specify another supported agent, such as `claude-code` or `cursor`.

To see the skills available in this repository without installing them:

```sh
npx skills add https://github.com/bravelocation/skills --list
```

The repository already uses the supported layout: each skill lives in its own directory with a `SKILL.md`. No npm package or installer script is required. Keep each skill's directory name aligned with its `name` in `SKILL.md`; `agents/openai.yaml` can provide display metadata for compatible clients.
