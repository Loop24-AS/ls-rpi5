#!/bin/bash

# Remove Singleton lock and session files to avoid issues with crash flags or that change of the Pi's username

rm -f ~/.config/chromium/Singleton* ~/.config/chromium/Crashpad/completed

# Start Chromium in kiosk mode and navigate to LoopSign URL

# Read the hash from hash.txt on the Desktop
HASH=$(cat /home/loopsign/Desktop/.hash.txt)

# Launch Chromium in kiosk mode with the specified URL
chromium-browser --disable-media-stream --start-maximized --start-fullscreen --disable-desktop-notifications --no-first-run --restore-last-session https://play.loopsign.eu/hash/$HASH
