#!/bin/bash

# Step 1: Read MAC address and remove colons
mac=$(cat /sys/class/net/eth0/address | tr -d ':')

# Step 2: Hash MAC address using SHA-256
hashed_mac=$(echo -n "$mac" | sha256sum | cut -d ' ' -f1)

# Step 3: Encode hashed MAC address using Base64
encoded_mac=$(echo -n "$hashed_mac" | base64)

# Step 4: Hash encoded MAC address using SHA-256 again and remove characters 1, I, O, and 0
hashed_encoded_mac=$(echo -n "$encoded_mac" | sha256sum | tr -d '1IO0 ')

# Step 5: Select the first 7 characters of the hashed result and convert lowercase letters to uppercase
code=$(echo -n "${hashed_encoded_mac:0:7}" | tr '[:lower:]' '[:upper:]')

# Step 6: Create a hidden text file on the desktop with the resulting 7-character code
echo "$code" > /home/loopsign/Desktop/.hash.txt
