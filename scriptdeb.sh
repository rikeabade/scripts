#!/bin/bash

read -p 'Digite a senha do root: ' -s -r PASSWD

sudo apt install -y wget

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/3.1.1/rocketchat_3.1.1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/universe/n/nextcloud-desktop/nextcloud-desktop_2.6.2-1build1_amd64.deb

wget https://download.anydesk.com/linux/anydesk_6.1.1-1_amd64.deb

wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb

sudo dpkg -i *

#sudo dpkg -i google-chrome-stable_current_amd64.deb

#sudo dpkg -i anydesk_6.1.1-1_amd64.deb

#sudo dpkg -i rocketchat_3.1.1_amd64.deb

#sudo dpkg -i teamviewer_amd64.deb

#sudo dpkg -i nextcloud-desktop_2.6.2-1build1_amd64.deb

sudo apt install -f 

sudo apt update -y

sudo apt upgrade -y

sudo apt-get install -y network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp network-manager-vpnc
