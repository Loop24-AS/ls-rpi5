#!/bin/bash

# Function to check internet connection and time sync
check_internet_and_time_sync() {
    # Flag to track whether the time has been synced
    synced=false
    # Flag to track whether the dialog box has been displayed
    displayed=false

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

    # Kill any running Zenity dialogs
    pkill zenity
}

# Function to update the repository using git reset --hard and git pull with rebase
update_repository() {
    local REPO_DIR="/home/loopsign/ls-rpi5"

    if [ -d "$REPO_DIR/.git" ]; then
        echo "Resetting repository to the last commit with git reset --hard..."
        cd "$REPO_DIR"
        git reset --hard

        echo "Pulling the latest changes with git pull --rebase..."
        git pull --rebase
        return 0
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

# Check internet connection and time synchronization
check_internet_and_time_sync

# Pull the latest changes from the repository with rebase
update_repository

# Schedule the master script update and restart if needed
schedule_master_script_update_and_restart

# Show countdown while secondary scripts run
start_countdown

# Run the updated scripts
#cd /home/loopsign/ls-rpi5
#chmod +x script1.sh script2.sh script3.sh script4.sh script5.sh  # Adjust filenames as needed
#./script1.sh
#./script2.sh
#./script3.sh
#./script4.sh
#./script5.sh

# Simulate running scripts sequentially
echo "Simulating running script 1..."
sleep 2  # Simulate time taken to run the script

echo "Simulating running script 2..."
sleep 2

echo "Simulating running script 3..."
sleep 2

echo "Simulating running script 4..."
sleep 2

echo "Simulating running script 5..."
sleep 2
