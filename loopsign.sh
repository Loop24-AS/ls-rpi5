#!/bin/bash
# Flag to track whether the time has been synced
synced=false
# Flag to track whether the dialog box has been displayed
displayed=false

#testing adding a change

# Capture the system time before synchronization
before_sync_time=$(date +%s)
echo "Before sync time: $before_sync_time"

# Wait until the time has been synced
while true; do
  # Check if the system time has been synchronized
  if ntpq -p | grep "*"; then
    synced=true
    echo "System time has been synchronized."
    break
  fi
  # Display a message to the user if the time has not yet been synced and the dialog has not yet been displayed
  if ! $synced && ! $displayed; then
    echo "Displaying initial zenity message about time sync."
    zenity --info --text="Your LoopSign screen will start once a working internet connection is established and the player's time and date have been synced. Please note that this might take a couple of minutes. If your LoopSign screen won't start, please check your network and/or NTP settings." &
    displayed=true
  fi
  sleep 1
done
# Capture the system time after synchronization
after_sync_time=$(date +%s)
echo "After sync time: $after_sync_time"

# Calculate the difference in days between the before and after sync times
time_difference=$(( (after_sync_time - before_sync_time) / 86400 ))
echo "Time difference in days: $time_difference"

# If the time difference is greater than 30 days, run the update and upgrade commands and reboot
if [ $time_difference -gt 30 ]; then
  echo "Time difference is greater than 30 days, displaying update message."
  pkill zenity  # Close any existing zenity dialogs

  # Start the update and upgrade process with a progress bar and elapsed time
  #!/bin/bash

# Function to update package list
update_package_list() {
    zenity --info --title="System Update" --text="This is the first time booting the player or it hasn't been online for a while. Therefore it needs to install a few updates before proceeding. The update process will take less than 5 minutes, and the player will reboot automatically when installation is complete. Thank you for your patience!\n\nUpdating package list..." &
    sudo apt update
pkill zenity
}

# Function to upgrade all packages with progress bar
upgrade_packages() {
    (
        {
            for i in $(seq 0 999); do
                echo "$((i * 100 / 999))"
                sleep 0.3 # Approximate 5 minutes (300 seconds) for the full-upgrade
            done
        } | zenity --progress \
                  --title="System Update" \
                  --text="This is the first time booting the player or it hasn't been online for a while. Therefore it needs to install a few updates before proceeding.\nThe update process will take less than 5 minutes, and the player will reboot automatically when installation is complete. Thank you for your patience!\n\nUpgrading packages..." \
                  --percentage=0 \
                  --auto-close \
                  --no-cancel
    ) &
    sudo apt upgrade -y
}

# Function to fix broken dependencies
fix_broken_dependencies() {
    zenity --info --title="System Update" --text="This is the first time booting the player or it hasn't been online for a while. Therefore it needs to install a few updates before proceeding. The update process will take less than 5 minutes, and the player will reboot automatically when installation is complete. Thank you for your patience!\n\nFixing broken dependencies..." &
    sudo apt --fix-broken install -y
}

# Function to remove unnecessary packages
remove_unnecessary_packages() {
    zenity --info --title="System Update" --text="This is the first time booting the player or it hasn't been online for a while. Therefore it needs to install a few updates before proceeding. The update process will take less than 5 minutes, and the player will reboot automatically when installation is complete. Thank you for your patience!\n\nRemoving unnecessary packages..." &
    sudo apt autoremove -y
    pkill zenity
}

# Execute functions
update_package_list
upgrade_packages
fix_broken_dependencies
remove_unnecessary_packages
#reboot_system

  pkill zenity
  echo "Rebooting system."
  for i in 5 4 3 2 1; do
  zenity --info --text="Updates successfully completed. Rebooting the system in $i seconds..." &
  sleep 1
done
pkill zenity
  sudo reboot
  exit 0
fi

# Close the dialog box
echo "Closing any open zenity dialogs."
pkill zenity

# Display a countdown before starting Chromium
echo "Displaying countdown before starting Chromium."
pkill zenity  # Close any existing zenity dialogs before final countdown
for i in 5 4 3 2 1; do
  pkill zenity
  zenity --info --text="Internet connection established and time date synced. Starting your LoopSign screen in $i seconds..." &
  sleep 1
done
pkill zenity

# Start Chromium in kiosk mode and navigate to LoopSign URL

# Read the hash from hash.txt on the Desktop
HASH=$(cat /home/loopsign/Desktop/.hash.txt)

# Launch Chromium in kiosk mode with the specified URL
chromium-browser --start-maximized --start-fullscreen --incognito --disable-desktop-notifications --no-first-run https://edit.loopsign.eu/hash/$HASH
