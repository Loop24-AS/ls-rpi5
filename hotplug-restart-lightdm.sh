#!/bin/bash

STATUS_FILE="/home/loopsign/screen-status.txt"

# Check if the file exists and contains "(null)"
if [[ -f "$STATUS_FILE" && "$(cat "$STATUS_FILE")" == "(null)" ]]; then
    systemctl restart lightdm
fi