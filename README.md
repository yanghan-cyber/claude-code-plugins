# auto-mode

Hook-based auto mode plugin for Claude Code. Automatically approves tool calls in `acceptEdits` permission mode, with dangerous command protection and logging.

## Features

- **Auto-approve tool calls** — Skip permission prompts in `acceptEdits` mode
- **Two-level toggle** — Project-level (per-project) and user-level (global) control
- **Dangerous command protection** — Blocks `rm`, `taskkill`, `shutdown`, `mkfs`, etc.
- **Logging** — All decisions recorded with rotation (3 files, 10MB each)
- **Toggle control** — `/auto-mode on|off` slash command with `--global` flag

## Installation

### Claude Code (via Plugin Marketplace)

In Claude Code, register the marketplace first:

```
/plugin marketplace add yanghan-cyber/auto-mode
```

Then install the plugin from this marketplace:

```
/plugin install auto-mode@auto-mode
```

### Local install (development)

```bash
claude --plugin-dir /path/to/auto-mode
```

## Usage

1. Switch to **acceptEdits** permission mode (press `Shift+Tab`)
2. Toggle auto mode:
   - `/auto-mode on` — Enable for current project
   - `/auto-mode off` — Disable for current project
   - `/auto-mode on --global` — Enable for all projects (user-level)
   - `/auto-mode off --global` — Disable for all projects
   - `/auto-mode` — Show current status

### Toggle Levels

| Level | Toggle File | Scope | Priority |
|-------|-------------|-------|----------|
| Project | `{project}/.claude/.auto-mode` | Current project only | High |
| User | `~/.claude/.auto-mode` | All projects | Low |

Project-level toggle takes priority over user-level. If both exist, the project level is used.

## How It Works

| Component | File | Purpose |
|-----------|------|---------|
| Hook config | `hooks/hooks.json` | Registers PreToolUse hook |
| Hook script | `hooks/auto-mode.sh` | Core logic: check toggle, permission, danger commands |
| Toggle script | `scripts/auto-mode-toggle.sh` | Manages toggle files |
| Slash command | `commands/auto-mode.md` | `/auto-mode` user command |

### Flow

```
Tool call → PreToolUse hook
  → Check project toggle exists? Yes → use project level
  → Check user toggle exists? No → normal permission flow
  → Check permission_mode == acceptEdits? No → normal permission flow
  → Check dangerous command? Yes → BLOCKED + logged
  → Otherwise → ALLOW + logged
```

## Configuration

- **Project toggle**: `{project}/.claude/.auto-mode`
- **User toggle**: `~/.claude/.auto-mode`
- **Project logs**: `{project}/.claude/auto-mode/logs/`
- **User logs**: `~/.claude/auto-mode/logs/`
- **Log rotation**: 3 files max, 10MB each

## Blocked Commands

`rm`, `find -delete`, `mkfs`, `dd`, `shred`, `chmod -R 777`, `chown -R`, `DROP TABLE`, `TRUNCATE TABLE`, `curl|sh`, `wget|sh`, `shutdown`, `reboot`, `taskkill`, `format`, `del /s /q`, `rd /s /q`

## Requirements

- Claude Code 1.0.33+ (plugin support)
- `acceptEdits` permission mode (Shift+Tab to switch)
