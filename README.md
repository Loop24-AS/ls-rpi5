# ls-rpi5
## Shell scripts and setup for using Raspberry Pi 5 as LoopSign player

The starting point of the setup is a Raspberry Pi 5 running on Raspberry Pi OS Debian 12 (Bookworm) with desktop, using its default Wayfire Wayland compositor. Release date of the Raspberry Pi OS image is July 4 2024.

The image is burnt on a high speed 16 GB MicroSD card. Username: loopsign || Password: loop24 || Country: Norway || Location: Oslo || Keyboard: NO / Logitech || WLAN Country: Norway

### Set headless resolution
Use Nano and add one space and the following specification to the end of /boot/firmware/cmdline.txt:
```
sudo nano /boot/firmware/cmdline.txt
```
```
video=HDMI-A-1:1920x1080@60D
```

### Install neccessary packages
sudo apt install upower fonts-noto-color-emoji ntp wtype -y

### Uninstall uneccessary packages
sudo apt remove geany firefox -y && sudo apt autoremove -y

