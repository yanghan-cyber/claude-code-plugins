#!/bin/bash
# Auto-mode hook for Claude Code (no jq dependency)
# Supports two levels (project takes priority):
#   Project: {PWD}/.claude/.auto-mode
#   User:    ~/.claude/.auto-mode

PROJECT_TOGGLE="$PWD/.claude/.auto-mode"
USER_TOGGLE="$HOME/.claude/.auto-mode"
TOGGLE=""
LOG_DIR=""

if [ -f "$PROJECT_TOGGLE" ]; then
    TOGGLE="$PROJECT_TOGGLE"
    LOG_DIR="$PWD/.claude/auto-mode/logs"
elif [ -f "$USER_TOGGLE" ]; then
    TOGGLE="$USER_TOGGLE"
    LOG_DIR="$HOME/.claude/auto-mode/logs"
else
    exit 0
fi

INPUT=$(cat)

# Extract permission_mode — only allow in acceptEdits
PERM=$(echo "$INPUT" | grep -o '"permission_mode"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"permission_mode"[[:space:]]*:[[:space:]]*"//;s/"//')
if [ "$PERM" != "acceptEdits" ]; then
    exit 0
fi

# Extract tool_name
TOOL=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"//;s/"//')

# Extract tool_input for logging
TOOL_INPUT=$(echo "$INPUT" | grep -o '"tool_input"[[:space:]]*:[[:space:]]*{[^}]*}' | head -1 | sed 's/.*"tool_input"[[:space:]]*:[[:space:]]*//')

LOG_FILE="$LOG_DIR/auto-mode.log"
MAX_SIZE=10485760  # 10MB
MAX_FILES=3

if [ "$TOOL" = "Bash" ]; then
    COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//;s/"//')

    # Dangerous commands → normal permission flow
    if echo "$COMMAND" | grep -qiE '\brm\b|find\s+.*-delete|mkfs[\./]|dd\s+.*if=|>\s*/dev/sd|shred\s+/|chmod\s+-R\s+777\s+/|chown\s+-R\s+[^ ]+\s+/[^ ]|DROP\s+TABLE|TRUNCATE\s+TABLE|curl.*\|\s*(ba)?sh|wget.*\|\s*(ba)?sh|base64.*\|\s*(ba)?sh|\bshutdown\b|\breboot\b|init\s+[06]|systemctl\s+(stop|disable|mask)|taskkill|format\s+[A-Za-z]:|del\s+/[sS]\s+/[qQ]|rd\s+/[sS]\s+/[qQ]'; then
        # Log blocked command
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        mkdir -p "$LOG_DIR"
        echo "[$TIMESTAMP] BLOCKED | $PERM | $TOOL | $COMMAND" >> "$LOG_FILE"
        exit 0
    fi
fi

# Log rotation
mkdir -p "$LOG_DIR"
if [ -f "$LOG_FILE" ]; then
    FILE_SIZE=$(stat -c%s "$LOG_FILE" 2>/dev/null || stat -f%z "$LOG_FILE" 2>/dev/null || echo 0)
    if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
        # Rotate: .2 → delete, .1 → .2, .0 → .1, current → .0
        [ -f "$LOG_FILE.2" ] && rm "$LOG_FILE.2"
        [ -f "$LOG_FILE.1" ] && mv "$LOG_FILE.1" "$LOG_FILE.2"
        [ -f "$LOG_FILE.0" ] && mv "$LOG_FILE.0" "$LOG_FILE.1"
        mv "$LOG_FILE" "$LOG_FILE.0"
    fi
fi

# Log allowed command
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
case "$TOOL" in
    Bash)
        echo "[$TIMESTAMP] ALLOWED  | $PERM | $TOOL | $COMMAND" >> "$LOG_FILE"
        ;;
    Edit|Write|Read)
        FILE_PATH=$(echo "$TOOL_INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"//')
        echo "[$TIMESTAMP] ALLOWED  | $PERM | $TOOL | $FILE_PATH" >> "$LOG_FILE"
        ;;
    *)
        echo "[$TIMESTAMP] ALLOWED  | $PERM | $TOOL" >> "$LOG_FILE"
        ;;
esac

# Output allow decision
echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Hook-based auto mode"}}'
exit 0
