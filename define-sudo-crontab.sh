#!/bin/bash

# Define the source file
SOURCE_FILE="/home/loopsign/ls-rpi5/sudo-crontab.txt"

# Check if the source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Error: Source file $SOURCE_FILE not found!"
    exit 1
fi

# Backup the existing sudo crontab
BACKUP_FILE="/tmp/sudo-crontab-backup-$(date +%F_%T).txt"
sudo crontab -l > "$BACKUP_FILE" 2>/dev/null

echo "Backup of existing sudo crontab saved to: $BACKUP_FILE"

# Overwrite the current sudo crontab with the new one
sudo crontab < "$SOURCE_FILE"

echo "Successfully replaced sudo crontab with $SOURCE_FILE."