#!/bin/bash

pkill zenity

# Display a Zenity message informing the user of the process
(
  echo "0"  # Start the progress at 0%
  echo "# The player hasn't been online for a while and needs to run a few updates and then reboot before launching your screen. The whole process will take less than 5 minutes."
  sleep 1

  # Run the update commands
  echo "20"  # Progress 20%
  echo "# Updating package lists..."
  sudo apt update

  echo "40"  # Progress 40%
  echo "# Upgrading installed packages..."
  sudo apt upgrade -y

  echo "60"  # Progress 60%
  echo "# Fixing broken dependencies..."
  sudo apt --fix-broken install -y

  echo "80"  # Progress 80%
  echo "# Removing unnecessary packages..."
  sudo apt autoremove -y

  echo "90"  # Progress 90%
  echo "# Setting the Plymouth theme..."
  sudo plymouth-set-default-theme -R loopsign

  echo "100"  # Complete the progress at 100%
  echo "# Rebooting the system..."
  sleep 2
) | zenity --progress \
           --title="System Update in Progress" \
           --text="The player hasn't been online for a while and needs to run a few updates and then reboot before launching your screen. The whole process will take less than 5 minutes.\n\nThank you for your patience!" \
           --percentage=0 \
           --auto-close \
           --no-cancel

# Reboot the system after the process is complete
sudo reboot
