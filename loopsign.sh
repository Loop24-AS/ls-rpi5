#!/bin/bash

# Start Chromium in kiosk mode and navigate to LoopSign URL

# Read the hash from hash.txt on the Desktop
HASH=$(cat /home/loopsign/Desktop/.hash.txt)

# Launch Chromium in kiosk mode with the specified URL
DISPLAY=:0 /usr/bin/chromium-browser --start-maximized --start-fullscreen --incognito --disable-desktop-notifications --no-first-run https://edit.loopsign.eu/hash/$HASH
