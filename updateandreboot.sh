#!/bin/bash

# Get the current day of the month (1-31)
CURRENT_DAY=$(date +"%d")

# Only proceed if today is the first of the month
if [ "$CURRENT_DAY" == "01" ]; then
    echo "Today is the 1st of the month. Scheduling system updates for 5 AM tomorrow."

    # Calculate seconds until 5 AM on the 2nd
    SECONDS_UNTIL_5AM=$(( (24 - $(date +"%H") + 5) * 3600 - $(date +"%M") * 60 - $(date +"%S") ))

    echo "Sleeping for $SECONDS_UNTIL_5AM seconds until 5 AM on the 2nd..."
    sleep "$SECONDS_UNTIL_5AM"

    echo "Executing system updates..."
    sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get --fix-broken install -y && sudo apt-get autoremove -y && sudo plymouth-set-default-theme -R loopsign && sudo reboot
else
    echo "Today is not the 1st of the month. Exiting."
fi