#!/bin/bash

# Desired reboot time (24-hour format)
REBOOT_TIME="05:00"

# Get the current time in HH:MM format
CURRENT_TIME=$(date +"%H:%M")

# Get the current day of the month (1-31)
CURRENT_DAY=$(date +"%d")

# Only proceed if today is the first of the month
if [ "$CURRENT_DAY" == "01" ]; then
    # Wait until the desired time to reboot
    while [ "$CURRENT_TIME" != "$REBOOT_TIME" ]; do
        sleep 55
        CURRENT_TIME=$(date +"%H:%M")
    done

    # Reboot the system after running update commands
    sudo apt update && sudo apt upgrade -y && sudo apt --fix-broken install -y && sudo apt autoremove -y && sudo plymouth-set-default-theme -R loopsign && sudo reboot
fi
