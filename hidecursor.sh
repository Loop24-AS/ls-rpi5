#!/bin/bash
# hide mouse in wayland raspbian

sudo apt install -y interception-tools interception-tools-compat
sudo apt install -y cmake
cd ~
git clone git@github.com:eirikpa/ls-rpi5-hidecursor.git
sudo cp /home/$USER/hideaway/config.yaml /etc/interception/udevmon.d/config.yaml
cd hideaway
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cp /home/$USER/hideaway/build/hideaway /usr/bin
sudo chmod +x /usr/bin/hideaway
sudo systemctl restart udevmon
