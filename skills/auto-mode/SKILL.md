---
name: auto-mode
description: Toggle hook-based auto mode on/off (only works in acceptEdits permission mode)
disable-model-invocation: true
allowed-tools: Bash(*)
---

!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/auto-mode-toggle.sh $ARGUMENTS`

Supports two toggle levels (project takes priority over user):

- **Project level** (default): `{project}/.claude/.auto-mode` — only affects the current project
- **User level** (`--global`): `~/.claude/.auto-mode` — affects all projects

Usage examples:
- `/auto-mode on` — enable for current project
- `/auto-mode off` — disable for current project
- `/auto-mode on --global` — enable for all projects
- `/auto-mode off --global` — disable for all projects
- `/auto-mode` — show status of both levels

Important: Hook-based auto mode only takes effect when the current permission mode is **acceptEdits** (press Shift+Tab to switch).
