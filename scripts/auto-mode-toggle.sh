#!/bin/bash
# Auto-mode toggle script
# Usage: auto-mode-toggle.sh [on|off] [--global]
# No args = show status
# --global = operate on user-level toggle instead of project-level

PROJECT_TOGGLE="$PWD/.claude/.auto-mode"
USER_TOGGLE="$HOME/.claude/.auto-mode"

# Parse arguments
ACTION=""
GLOBAL=false
for arg in "$@"; do
    case "$arg" in
        on|off) ACTION="$arg" ;;
        --global) GLOBAL=true ;;
    esac
done

if [ "$GLOBAL" = true ]; then
    TOGGLE="$USER_TOGGLE"
    LEVEL="user"
else
    TOGGLE="$PROJECT_TOGGLE"
    LEVEL="project"
fi

case "$ACTION" in
    on)
        if [ -f "$TOGGLE" ]; then
            echo "Auto mode is already ON ($LEVEL level). (Requires acceptEdits mode)"
        else
            mkdir -p "$(dirname "$TOGGLE")"
            touch "$TOGGLE"
            echo "Auto mode enabled ($LEVEL level). (Only effective in acceptEdits mode)"
        fi
        ;;
    off)
        if [ ! -f "$TOGGLE" ]; then
            echo "Auto mode is already OFF ($LEVEL level)."
        else
            rm "$TOGGLE"
            echo "Auto mode disabled ($LEVEL level)."
        fi
        ;;
    *)
        PSTATUS="OFF"
        USTATUS="OFF"
        [ -f "$PROJECT_TOGGLE" ] && PSTATUS="ON"
        [ -f "$USER_TOGGLE" ] && USTATUS="ON"
        echo "Auto mode status:"
        echo "  Project ($PWD): $PSTATUS"
        echo "  User    ($HOME): $USTATUS"
        ;;
esac
