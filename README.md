# ls-rpi5
## Shell scripts and setup for using Raspberry Pi 5 as LoopSign player

The starting point of the setup is a Raspberry Pi 5 running on Raspberry Pi OS Debian 12 (Bookworm) with desktop, using its default Wayfire Wayland compositor. Release date of the Raspberry Pi OS image is July 4 2024.

The image is burnt on a high speed 16 GB MicroSD card. Username: loopsign || Password: loop24

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
git clone git@github.com:Loop24-AS/ls-rpi5.git
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

## Changes set in the GUI
### Raspberry Pi Configuration
Right click ***Raspberry Configuration*** in the Raspberry Pi Menu and click ***Add to Desktop***. Right click ***Screen Configuration*** in the Raspberry Pi Menu and click ***Add to Desktop***.

Double-click ***Raspberry Pi Configuration*** on the desktop. In the ***Display** pane, make sure that ***Scren Blanking*** is disabled. In the ***Localisation*** pane, click ***Set Timezone*** and choose ***Area: Europe*** and ***Location: Oslo***; click ***Set Keyboard*** and choose ***Model: Logitech***, ***Layout: Norwegian*** and ***Variant: Norwegian***; click ***Set WLAN Country*** and choose ***NO Norway***. 

### Chromium settings
Open Chromium and open URL `chrome://settings/cookies`. Enable ***Allow third-party cookies***. Open URL `chrome://settings/content/sound`. Add `https://play.loopsign.eu` and `https://edit.loopsign.eu` under ***Allowed to play sound***. Open `chrome://settings/languages`. Disable ***Use Google Transate***.

### Desktop
Right click the desktop and open ***Desktop preferences***. Set `/home/loopsign/ls-rpi5/Linux background.png` as desktop background picture. Disable ***Wastebasket**. Open the ***Taskbar*** pane and set ***Size: Medium (24x24)***, ***Position: Bottom***, ***Colour: Black*** and ***Text Colour: White***.
