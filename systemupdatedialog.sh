#!/bin/bash

# Define log file (will be overwritten on each run)
LOGFILE="/var/log/player_update.log"

# Show an initial Zenity information dialog before updates start
zenity --info \
       --title="System Update in Progress" \
       --text="This is a fresh install of the LoopSign Player. Therefore, it has now started to download and install system updates in the background. Please don't reboot the player or disconnect it from power; the udpate process will only take a few minutes.\n\nWhen the updates are completed, the player will automatically reboot.\n\nThe below code will stay the same after reboot, so you can safely use it to pair with your LoopSign account right away." &

INFO_PID=$!  # Store the process ID of the Zenity dialog

# Run updates in the background and log output
(
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get --fix-broken install -y
  sudo apt-get autoremove -y
  sudo plymouth-set-default-theme -R loopsign
) 2>&1 | sudo tee "$LOGFILE"

# Close the initial Zenity dialog before showing the countdown
kill "$INFO_PID" 2>/dev/null

# Function to show a countdown using Zenity
show_countdown() {
    (
        for i in {10..1}; do
            echo "# The player will reboot in about $i seconds..."
            echo "$(( (10 - i + 1) * 10 ))"  # Progress percentage
            sleep 1
        done
        echo "100"  # Ensure the progress reaches 100%
    ) | zenity --progress \
               --title="Reboot Required" \
               --text="System updates successfully installed." \
               --percentage=0 \
               --auto-close \
               --no-cancel
}

# Show the countdown before rebooting
show_countdown

# Reboot the system
sudo reboot
