---
name: auto-mode
description: Toggle hook-based auto mode on/off (only works in acceptEdits permission mode)
disable-model-invocation: true
argument-hint: [on|off]
---

!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/auto-mode-toggle.sh" $ARGUMENTS`

Important: Hook-based auto mode only takes effect when the current permission mode is **acceptEdits** (press Shift+Tab to switch). Other modes (default, plan, auto) will not be affected by this toggle.
