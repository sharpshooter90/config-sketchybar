#!/bin/sh

# Generic Logger Utility
# Usage: 
#   When sourced: log_event LEVEL MESSAGE
#   When executed directly: ./logger.sh LEVEL MESSAGE
# Logs an event with a timestamp and specified level to /tmp/sketchybar_events.log

LOG_FILE="/tmp/sketchybar_events.log"

# Create log file if it doesn't exist
touch "$LOG_FILE"

log_event() {
    local level="$1";
    shift;
    local message="$@";
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S');
    local event="[$timestamp] [${level}] ${message}";
    echo "$event";
    echo "$event" >> "$LOG_FILE";
}

# Handle direct execution of this script
# The "return" command will exit with error if not sourced, which we catch
(return 0 2>/dev/null) && return

# If we get here, the script is being executed directly
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 LEVEL MESSAGE";
    exit 1;
fi

log_event "$@" 