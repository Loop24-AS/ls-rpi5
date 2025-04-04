#!/bin/bash

# Set resolution to 1920x1080@60Hz
chmod +x /home/loopsign/ls-rpi5/setresolution.sh
/home/loopsign/ls-rpi5/setresolution.sh

# Restart udevmon to hide cursor
sudo systemctl restart udevmon

# Function to check internet connection and time sync
check_internet_and_time_sync() {
    # Flag to track whether the time has been synced
    synced=false
    # Flag to track whether the dialog box has been displayed
    displayed=false

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
}

# Function to update the repository using git reset --hard and git pull with rebase
update_repository() {
    local REPO_DIR="/home/loopsign/ls-rpi5"
    local CONFIG_FILE="/home/loopsign/config"
    local BRANCH="prod"  # Default to "prod" for production
    local GITHUB_REPO_URL="https://github.com/Loop24-AS/ls-rpi5.git"

    # Check if the configuration file exists
    if [ -f "$CONFIG_FILE" ]; then
        # Read the branch name directly from the configuration file
        BRANCH=$(cat "$CONFIG_FILE" | tr -d '[:space:]')

        # If the config file is empty, fall back to the default "prod"
        if [ -z "$BRANCH" ]; then
            echo "Config file is empty. Defaulting to 'prod'."
            BRANCH="prod"
        fi
    else
        echo "Config file does not exist. Creating it with the default branch 'prod'."
        echo "prod" > "$CONFIG_FILE"  # Create the config file with the default branch
    fi

    # Proceed with the repository update
    if [ -d "$REPO_DIR/.git" ]; then
        cd "$REPO_DIR"

        # Rename incorrect remote repository reference to 'origin' if necessary
        if git remote get-url StrictHostKeyChecking=no >/dev/null 2>&1; then
            echo "Renaming remote repository from 'StrictHostKeyChecking=no' to 'origin'..."
            git remote rename StrictHostKeyChecking=no origin
        fi

        # Force remote URL to be HTTPS (read-only)
        git remote set-url origin "$GITHUB_REPO_URL"

        echo "Fetching latest changes..."
        git fetch origin

        echo "Resetting local branch to match remote branch with correct branch..."
        git reset --hard origin/$BRANCH

        echo "Repository successfully updated and mirrored from remote branch $BRANCH."
    else
        echo "Repository directory does not exist or is not a git repository. Exiting."
        exit 1
    fi
}

# Function to schedule the master script update and restart
schedule_master_script_update_and_restart() {
    NEW_SCRIPT_PATH="/home/loopsign/ls-rpi5/autorun.sh"
    CURRENT_SCRIPT_PATH="/home/loopsign/autorun.sh"

    if [ -f "$NEW_SCRIPT_PATH" ]; then
        NEW_HASH=$(sha256sum "$NEW_SCRIPT_PATH" | awk '{print $1}')
        CURRENT_HASH=$(sha256sum "$CURRENT_SCRIPT_PATH" | awk '{print $1}')

        if [ "$NEW_HASH" != "$CURRENT_HASH" ]; then
            echo "New version detected. Scheduling master script update and restart..."
            # Create a temporary script to perform the update and restart
            cat <<EOF > /home/loopsign/update_and_restart.sh
#!/bin/bash
sleep 2  # Ensure the original script has time to finish
mv "$NEW_SCRIPT_PATH" "$CURRENT_SCRIPT_PATH"
chmod +x "$CURRENT_SCRIPT_PATH"
/bin/bash "$CURRENT_SCRIPT_PATH"  # Restart the updated master script
rm -- "\$0"  # Delete this temporary script after execution
EOF
            chmod +x /home/loopsign/update_and_restart.sh
            nohup /home/loopsign/update_and_restart.sh > /dev/null 2>&1 &  # Run the update and restart in the background
            exit 0  # Exit the current script to allow the update to take place
        else
            echo "Master script is already up to date."
        fi
    else
        echo "No new master script found in the repository."
    fi
}

# Function to countdown while waiting for the secondary scripts to run
start_countdown() {
    (
        for i in {10..1}; do
            echo "# Your LoopSign screen will launch in about $i seconds..."
            echo "$(( (10 - i + 1) * 10 ))"  # Progress percentage
            sleep 1
        done
        echo "100"  # Ensure the progress reaches 100%
    ) | zenity --progress \
               --title="Countdown" \
               --text="Please wait..." \
               --percentage=0 \
               --auto-close \
               --no-cancel &
}

# Check to see if system update log file exists, and if it doesn't run the update script
check_update_history() {
    file="/var/log/player_update.log"
    script="/home/loopsign/ls-rpi5/systemupdatedialog.sh"

    if [ ! -f "$file" ]; then
        echo "File $file does not exist. Executing update script."
        chmod +x "$script"
        sudo "$script"
    else
        echo "File $file exists. No action needed."
    fi
}

# Check internet connection and time synchronization and run updates if neccessary
check_internet_and_time_sync

# Pull the latest changes from the repository with rebase
update_repository

# Schedule the master script update and restart if needed
schedule_master_script_update_and_restart

# Kill any running Zenity dialogs
pkill zenity

## Set cron jobs
chmod +x /home/loopsign/ls-rpi5/hotplug-restart-lightdm.sh
chmod +x /home/loopsign/ls-rpi5/define-sudo-crontab.sh
sudo /home/loopsign/ls-rpi5/define-sudo-crontab.sh

## Check screen connection
chmod +x /home/loopsign/ls-rpi5/hotplug-connection-monitor.sh
/home/loopsign/ls-rpi5/hotplug-connection-monitor.sh

# Show countdown while secondary scripts run
start_countdown

# Run the updated scripts
cd /home/loopsign/ls-rpi5
chmod +x setresolution.sh autorefresh.sh hashgenerator.sh loopsign.sh reboot.sh systemupdatedialog.sh hidecursor.sh loopsignsplash.sh pishrink.sh updateandreboot.sh # Adjust filenames as needed
./setresolution.sh
nohup ./autorefresh.sh &
./hashgenerator.sh
./loopsign.sh &
sleep 15
# check_update_history
# sudo ./updateandreboot.sh
sudo ./reboot.sh
