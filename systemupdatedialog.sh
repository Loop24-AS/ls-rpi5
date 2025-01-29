#!/bin/bash

# Define log file (will be overwritten on each run)
LOGFILE="/var/log/player_update.log"

# Show a Zenity info dialog while running updates in the background
zenity --info \
  --title="System Update in Progress" \
  --text="The player hasn't been online for a while\nand needs to run a few updates.\nAfter updating, the player will reboot before launching your screen.\n\nThe whole process will probably take less than 5 minutes.\n\nThank you for your patience!" &

# Run updates in the background and log output while displaying it
(
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get --fix-broken install -y
  sudo apt-get autoremove -y
  sudo plymouth-set-default-theme -R loopsign
  sudo reboot
) 2>&1 | sudo tee "$LOGFILE" &
