#!/bin/bash

# Desired resolution and refresh rate
DESIRED_RESOLUTION="1920x1080"
DESIRED_REFRESH_RATE="60.000000"

echo "Starting resolution check script..."

# Get the list of connected outputs
CONNECTED_OUTPUTS=$(wlr-randr | grep -E "^[A-Z]+-[A-Z]+-[0-9]+" | awk '{print $1}')
echo "Connected outputs detected: $CONNECTED_OUTPUTS"

# Loop through each connected output and set the resolution if needed
for OUTPUT in $CONNECTED_OUTPUTS; do
    echo "Checking output: $OUTPUT"
   
    # Get the current resolution and refresh rate for each output
    CURRENT_MODE_LINE=$(wlr-randr | grep -E '(preferred, current|current)' | sed 's/^[[:space:]]*//' | awk '{print $1, $3}')
   
    CURRENT_MODE=$(echo $CURRENT_MODE_LINE | awk '{print $1}')
    CURRENT_RATE=$(echo $CURRENT_MODE_LINE | awk '{print $2}')
   
    echo "Current mode for $OUTPUT: $CURRENT_MODE"
    echo "Current refresh rate for $OUTPUT: $CURRENT_RATE"

    # Check if the current resolution and refresh rate match the desired ones
    if [[ "$CURRENT_MODE" != "$DESIRED_RESOLUTION" || "$CURRENT_RATE" != "$DESIRED_REFRESH_RATE" ]]; then
        echo "Setting $OUTPUT to $DESIRED_RESOLUTION@$DESIRED_REFRESH_RATE"
        # Set the desired resolution and refresh rate for each output
        wlr-randr --output "$OUTPUT" --mode "$DESIRED_RESOLUTION"@"$DESIRED_REFRESH_RATE"
    else
        echo "$OUTPUT is already set to the desired resolution and refresh rate."
    fi
done

echo "Resolution check script done."
