#!/bin/bash
# Auto-mode toggle script
# Usage: auto-mode-toggle.sh [on|off]
# No args = show status

TOGGLE="$HOME/.claude/.auto-mode"

case "$1" in
    on)
        if [ -f "$TOGGLE" ]; then
            echo "Auto mode is already ON. (Requires acceptEdits mode)"
        else
            touch "$TOGGLE"
            echo "Auto mode enabled. (Only effective in acceptEdits mode)"
        fi
        ;;
    off)
        if [ ! -f "$TOGGLE" ]; then
            echo "Auto mode is already OFF."
        else
            rm "$TOGGLE"
            echo "Auto mode disabled."
        fi
        ;;
    *)
        if [ -f "$TOGGLE" ]; then
            echo "Auto mode: ON"
        else
            echo "Auto mode: OFF"
        fi
        ;;
esac
