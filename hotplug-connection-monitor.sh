#!/bin/bash

STATUS_FILE="/home/loopsign/screen-status.txt"

while true; do
    # Get the output of wlr-randr
    SCREEN_OUTPUT=$(wlr-randr)

    # Check if the output contains "(null)"
    if echo "$SCREEN_OUTPUT" | grep -q "(null)"; then
        # If screen-status.txt does not exist or does not contain "(null)", write "(null)"
        if [[ ! -f "$STATUS_FILE" || "$(cat "$STATUS_FILE")" != "(null)" ]]; then
            echo "(null)" > "$STATUS_FILE"
        fi
    else
        # If screen-status.txt does not exist or does not contain "OK", write "OK"
        if [[ ! -f "$STATUS_FILE" || "$(cat "$STATUS_FILE")" != "OK" ]]; then
            echo "OK" > "$STATUS_FILE"
        fi
        exit 0  # Exit script when screen is detected
    fi

    sleep 5  # Wait 5 seconds before checking again
done