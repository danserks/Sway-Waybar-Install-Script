#!/bin/bash

clear
echo "Starting Desktop Configuration..."
sleep 2

clear
echo "Getting fastest mirrors..."
echo
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sudo systemctl start reflector.service
cat /etc/pacman.d/mirrorlist
sleep 2

clear
echo "Refreshing keyrings..."
echo
sudo pacman -Sy
sudo pacman -S archlinux-keyring
sleep 2

clear
echo "Installing YAY..."
echo
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~/Downloads/Sway-Waybar-Install-Script
sleep 2

clear
echo "Installing sway and related applications..."
echo
yay -S network-manager-applet blueman pavucontrol sway swaybg swayidle swaylock swayimg waybar wofi mako \
       arc-gtk-theme papirus-icon-theme noto-fonts-emoji noto-fonts terminus-font nautilus file-roller \
       gnome-disk-utility python-i3ipc python-requests pamixer polkit-gnome imagemagick jq gedit python-pip \
       foot brightnessctl gammastep geoclue autotiling python-nautilus gvfs-smb brave-bin nwg-bar nwg-wrapper \
       ttf-nerd-fonts-symbols-1000-em nautilus-open-any-terminal grim slurp wl-clipboard simple-scan \
      hunspell hunspell-en_ca hyphen hyphen-en libmythes \
       mythes-en aurutils sddm sddm-sugar-candy-git plymouth

sleep 2
clear
echo "Which drivers would you like to install?"
echo "1. AMD"
echo "2. Nvidia"

read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Installing all AMD drivers..."
        yay -S amdgpu-pro-libgl lib32-amdgpu-pro-libgl amdgpu xf86-video-amdgpu mesa
        echo "Finished installing AMD drivers."
        ;;
    2)
        echo "Installing all Nvidia drivers..."
        yay -S nvidia nvidia-utils lib32-nvidia-utils
        echo "Finished installing Nvidia drivers."
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        ;;
esac

clear
echo "Applying configuration..."
echo
echo "Copying configuration files..."
cp -R .config/* $HOME/.config/
cp .bashrc $HOME/
sudo cp 09-timezone /etc/NetworkManager/dispatcher.d/
sudo cp 90-monitor.conf /etc/X11/xorg.conf.d/
sudo mkdir /etc/sddm.conf.d
sudo cp sddm.conf /etc/sddm.conf.d/
sudo cp theme.conf /usr/share/sddm/themes/sugar-candy/
sudo sed -i 's/HOOKS=(base systemd/HOOKS=(base systemd sd-plymouth/' /etc/mkinitcpio.conf
sudo sed -i 's/rw quiet/rw quiet splash vt.global_cursor_default=0/' /boot/loader/entries/arch.conf
sudo plymouth-set-default-theme -R spinfinity
sleep 2

echo
echo "Applying gsettings..."
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal foot
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
sleep 2

echo
echo "Enabling SDDM..."
sudo systemctl enable sddm.service
sleep 5

clear
echo "Installation complete, rebooting..."
sleep 2
reboot
