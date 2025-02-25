# ls-rpi5
## Shell scripts and setup for using Raspberry Pi 5 as LoopSign player

The starting point of the setup is a Raspberry Pi 5 running on Raspberry Pi OS Debian 12 (Bookworm) with desktop, using its default Wayfire Wayland compositor. Release date: July 4 2024. Download [here](https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2024-07-04/2024-07-04-raspios-bookworm-arm64.img.xz).

![LoopSign logo](LoopSign-logo.png)

## Concept
The purpose of the setup is to make the Raspberry Pi work as an unattended LoopSign player. Its main job is to launch the user's LoopSign screen, a static URL, in a fullscreen Chromium window. A set of bash scripts are part of this setup to make the Pi behave as intended and stably over time:
- `autorun.sh` will run at boot, as defined in `~/.config/wayfire.ini`. The script performs the following tasks in order:
  - Runs `setresolution.sh` to set the screen resolution to 1920x1080@60Hz if any other resolution is set.
  - Restarts udevmon to force-hide the cursor (utilizing separate repository [hideaway.git](https://github.com/Loop24-AS/hideaway)).
  - Waits for the system to get a working internet connection by checking if the player's date and time have synced with NTP.
  - If after the NTP sync, the script notices that it's been more than 30 days since the last NTP sync, it runs `systemupdatedialog.sh`, which will do a full system update and reoot.
  - Pulls this repository for changes and implements any updates. If there are updates to `autorun.sh`, the script restarts using the new version of itself.
  - Re-checks the screen resolution in case there are updates to `setresolution.sh` after the `git pull`.
  - Starts `autorefresh.sh` which will periodically (originally every three hours) do a cache refresh of Chromium if it's running.
  - Runs `generatehash.sh` to generate a unique seven-character code. The code is based on the Pi's ethernet MAC address, and it will always stay static for every specific Raspberry Pi if the script is re-run.
  - Runs `loopsign.sh` to launch Chromium in fullscreen with the LoopSign URL. The hash code from the previous step is a unique part of the URL, making it easy for the user to pair the player to their corresponding LoopSign screen without needing to connect to the player and control its settings.
- It usually takes less than a minute from the desktop environment is loaded until Chromium is launched.
- Throughout the boot/startup process, the user is kept somewhat informed via different Zenity dialogs.

## Setup instructions

The Raspberry Pi OS image is burnt on a high speed 16 GB MicroSD card. Username: loopsign || Password: loop24

### Clone the hideaway repository
Make SSH key pair.
```
ssh-keygen -t rsa -b 4096 -C "Raspberry Pi 5 LoopSign Player"
```
Add the private key to the SSH Agent.
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa2
```
Deploy the public key to the Github repository.
Copy the key `cat ~/.ssh/id_rsa2.pub` and paste it in the Github repository settings (Settings --> Deploy keys ---> Add deploy key). Set it to read-only access.

Automatically accept the SSH host key for github.com
```
nano ~/.ssh/config
```
```
Host github.com
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
```
Ctrl + O to save and ctrl + X to exit Nano.

Clone the repository.
```
cd ~
git clone git@github.com:Loop24-AS/hideaway.git
```

### Clone the ls-rpi5 repository
Make SSH key pair.
```
ssh-keygen -t rsa -b 4096 -C "Raspberry Pi 5 LoopSign Player"
```
Add the private key to the SSH Agent.
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```
Deploy the public key to the Github repository.
Copy the key `cat ~/.ssh/id_rsa.pub` and paste it in the Github repository settings (Settings --> Deploy keys ---> Add deploy key). Set it to read-only access.

Clone the repository.
```
cd ~
git clone git@github.com:Loop24-AS/ls-rpi5.git
```
Copy `autorun.sh` to `/home/loopsign` and make it executable.
```
cp ~/ls-rpi5/autorun.sh ~/autorun.sh
chmod +x ~/autorun.sh
```

### Set autorun.sh to run at boot
Add autostart instructions to `wayfire.ini`
```
nano ~/.config/wayfire.ini
```
Add the following to the bottom of the document.
```

[autostart]
loopsign = /home/loopsign/autorun.sh
```

### Set headless resolution
Edit /boot/firmware/cmdline.txt and add one space and the headless resolution specification at the end.
```
sudo nano /boot/firmware/cmdline.txt
```
```
 video=HDMI-A-1:1920x1080@60D
```
Ctrl + O to save and Ctrl + X to exit Nano.

### Install neccessary packages
```
sudo apt install upower fonts-noto-color-emoji ntp wtype -y
```

### Uninstall uneccessary packages
```
sudo apt remove geany firefox -y && sudo apt autoremove -y
```
### Configure and set LoopSign Plymouth theme to enable LoopSign splash at boot
```
chmod +x ~/ls-rpi5/loopsignsplash.sh
~/ls-rpi5/loopsignsplash.sh
```

### Install and activate tweak to hide cursor
```
chmod +x ~/ls-rpi5/hidecursor.sh
~/ls-rpi5/hidecursor.sh
```

## Changes set in the GUI
### Raspberry Pi Configuration
Right-click ***Raspberry Configuration*** in the Raspberry Pi Menu and click ***Add to Desktop***. Right-click ***Screen Configuration*** in the Raspberry Pi Menu and click ***Add to Desktop***.

Double-click ***Raspberry Pi Configuration*** on the desktop. In the ***Display*** pane, make sure that ***Screen Blanking*** is disabled. In the ***Localisation*** pane, click ***Set Timezone*** and choose ***Area: Europe*** and ***Location: Oslo***; click ***Set Keyboard*** and choose ***Model: Logitech***, ***Layout: Norwegian*** and ***Variant: Norwegian***; click ***Set WLAN Country*** and choose ***NO Norway***.

Right-click the taskbar and choose ***Notifications***. Disable ***Show notifications***.

### Chromium settings
Open Chromium and open URL `chrome://settings/cookies`. Enable ***Allow third-party cookies***. Open URL `chrome://settings/content/sound`. Add `https://play.loopsign.eu` and `https://edit.loopsign.eu` under ***Allowed to play sound***. Open `chrome://settings/languages`. Disable ***Spell check*** and ***Google Transate***. Open `chrome://settings/defaultBrowser` and click ***Make default***.

### Desktop
Right-click the desktop and open ***Desktop preferences***. Set `/home/loopsign/ls-rpi5/Linux background.png` as desktop background picture. Disable ***Wastebasket***. Open the ***Taskbar*** pane and set ***Size: Medium (24x24)***, ***Position: Bottom***, ***Colour: Black*** and ***Text Colour: White***.

### Clear command history from terminal
```
history -c
> ~/.bash_history
```
Close terminal.

### Export image and shrink it
Insert USB memory stick and export image.
```
sudo dd if=/dev/mmcblk0 of=/media/loopsign/[name-of-memory-stick]/ls_image_2025_2_pi5.img bs=1M status=progress
```
Run pishrink.sh on the exported image to shrink and compress it.
```
sudo /home/loopsign/ls-rpi5/pishrink.sh -z /media/loopsign/[name-of-memory-stick]/ls_image_2025_2_pi5.img
```
Eject the memory stick.

The image is now ready to be burnt onto an MicroSD card or USB memory stick to be used on a different Raspberry Pi 5.
