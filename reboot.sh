#!/bin/bash

# Desired reboot time (24-hour format)
REBOOT_TIME="06:00"

# Get the current time in HH:MM format
CURRENT_TIME=$(date +"%H:%M")

# Wait until the desired time to reboot
while [ "$CURRENT_TIME" != "$REBOOT_TIME" ]; do
    sleep 55
    CURRENT_TIME=$(date +"%H:%M")
done

# Reboot the system
sudo reboot
