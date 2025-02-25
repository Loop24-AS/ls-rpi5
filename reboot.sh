#!/bin/bash

# Calculate seconds until 6 AM tomorrow
CURRENT_HOUR=$(date +"%H")
CURRENT_MINUTE=$(date +"%M")
CURRENT_SECOND=$(date +"%S")

HOURS_UNTIL_6AM=$(( (24 - CURRENT_HOUR + 6) % 24 ))
SECONDS_UNTIL_6AM=$(( HOURS_UNTIL_6AM * 3600 - CURRENT_MINUTE * 60 - CURRENT_SECOND ))

echo "Scheduling reboot for 6 AM tomorrow..."
echo "Sleeping for $SECONDS_UNTIL_6AM seconds..."
sleep "$SECONDS_UNTIL_6AM"

echo "Rebooting system now..."
sudo reboot