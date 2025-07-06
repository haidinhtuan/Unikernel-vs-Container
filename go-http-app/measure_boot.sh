#!/bin/bash
# Precisely measures application boot time ("time to first instruction").

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <command_to_run...>"
    echo "Example: $0 ops run go-http-app"
    exit 1
fi

# Record host start time in nanoseconds.
HOST_START_NS=$(date +%s%N)

# Execute the command, capture its PID, and pipe its stdout to the 'read' command.
# 'read' will block until the first line is printed by the application.
APP_START_NS=$( { "$@" & PID=$!; } 2>/dev/null | read; echo $REPLY )

# Cleanly terminate the background process now that we have what we need.
kill $PID &>/dev/null
wait $PID &>/dev/null

# Validate that we received a numeric timestamp.
if ! [[ "$APP_START_NS" =~ ^[0-9]+$ ]]; then
    echo "Error: Did not receive a valid timestamp from the application." >&2
    exit 1
fi

# Calculate the delta in nanoseconds.
DELTA_NS=$((APP_START_NS - HOST_START_NS))

# Convert to milliseconds for human readability (requires 'bc').
DELTA_MS=$(echo "scale=3; $DELTA_NS / 1000000" | bc)

echo "Application boot time: ${DELTA_MS} ms"
