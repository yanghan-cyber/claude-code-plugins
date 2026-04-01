# auto-mode

Hook-based auto mode plugin for Claude Code. Automatically approves tool calls in `acceptEdits` permission mode, with dangerous command protection and logging.

## Features

- **Auto-approve tool calls** — Skip permission prompts in `acceptEdits` mode
- **Dangerous command protection** — Blocks `rm`, `taskkill`, `shutdown`, `mkfs`, etc.
- **Logging** — All decisions recorded with rotation (3 files, 10MB each)
- **Toggle control** — `/auto-mode on|off` slash command

## Installation

### From marketplace (recommended)

```bash
# 1. 添加 marketplace
/plugin marketplace add yanghan-cyber/auto-mode

# 2. 安装插件（永久，自动加载）
/plugin install auto-mode@auto-mode
```

### Local install (development)

```bash
claude --plugin-dir /path/to/auto-mode
```

## Usage

1. Switch to **acceptEdits** permission mode (press `Shift+Tab`)
2. Toggle auto mode:
   - `/auto-mode on` — Enable auto-approve
   - `/auto-mode off` — Disable auto-approve
   - `/auto-mode` — Show current status

## How It Works

| Component | File | Purpose |
|-----------|------|---------|
| Hook config | `hooks/hooks.json` | Registers PreToolUse hook |
| Hook script | `hooks/auto-mode.sh` | Core logic: check toggle, permission, danger commands |
| Toggle script | `scripts/auto-mode-toggle.sh` | Manages `~/.claude/.auto-mode` toggle file |
| Slash command | `commands/auto-mode.md` | `/auto-mode` user command |

### Flow

```
Tool call → PreToolUse hook
  → Check toggle file exists? No → normal permission flow
  → Check permission_mode == acceptEdits? No → normal permission flow
  → Check dangerous command? Yes → BLOCKED + logged
  → Otherwise → ALLOW + logged
```

## Configuration

- **Toggle file**: `~/.claude/.auto-mode` (created/removed by `/auto-mode`)
- **Log directory**: `~/.claude/auto-mode/logs/` (auto-created)
- **Log rotation**: 3 files max, 10MB each

## Blocked Commands

`rm`, `find -delete`, `mkfs`, `dd`, `shred`, `chmod -R 777`, `chown -R`, `DROP TABLE`, `TRUNCATE TABLE`, `curl|sh`, `wget|sh`, `shutdown`, `reboot`, `taskkill`, `format`, `del /s /q`, `rd /s /q`

## Requirements

- Claude Code 1.0.33+ (plugin support)
- `acceptEdits` permission mode (Shift+Tab to switch)
