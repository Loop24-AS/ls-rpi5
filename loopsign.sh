#!/bin/bash

# Start Chromium in kiosk mode and navigate to LoopSign URL

# Read the hash from hash.txt on the Desktop
HASH=$(cat /home/loopsign/Desktop/.hash.txt)

# Launch Chromium in kiosk mode with the specified URL
chromium-browser --disable-media-stream --start-maximized --start-fullscreen --disable-desktop-notifications --no-first-run https://play.loopsign.eu/hash/$HASH
