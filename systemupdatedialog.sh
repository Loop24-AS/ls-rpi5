#!/bin/bash

# Display a Zenity progress dialog with a consistent message
(
  echo "0"  # Start the progress at 0%
  sleep 1

  # Run the update commands
  echo "20"  # Progress 20%
  sudo apt update

  echo "40"  # Progress 40%
  sudo apt upgrade -y

  echo "60"  # Progress 60%
  sudo apt --fix-broken install -y

  echo "80"  # Progress 80%
  sudo apt autoremove -y

  echo "90"  # Progress 90%
  sudo plymouth-set-default-theme -R loopsign

  echo "100"  # Complete the progress at 100%
  sleep 1
) | zenity --progress \
           --title="System Update in Progress" \
           --text="The player hasn't been online for a while\nand needs to run a few updates\nand then reboot before launching your screen.\n\nThe whole process will take less than 5 minutes.\n\nThank you for your patience!" \
           --percentage=0 \
           --auto-close \
           --no-cancel

# Reboot the system after the process is complete
sudo reboot
