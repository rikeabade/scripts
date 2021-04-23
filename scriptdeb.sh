#!/bin/bash

read -p 'Digite a senha do root: ' -s -r PASSWD

SCRIPT=
'
apt install -y wget vim passwd git

wget https://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_52.0.2743.116-1_amd64.deb

wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/3.1.1/rocketchat_3.1.1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/universe/n/nextcloud-desktop/nextcloud-desktop_2.6.2-1build1_amd64.deb

wget https://download.anydesk.com/linux/anydesk_6.1.1-1_amd64.deb?_ga=2.264358988.2107257849.1619211185-1279308967.1612272360

wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb

dpkg -i google-chrome-stable_current_amd64.deb

dpkg -i anydesk_6.1.0-1_amd64.deb

dpkg -i rocketchat_3.1.1_amd64.deb

dpkg -i teamviewer_15.14.5_amd64.deb

dpkg -i nextcloud-desktop_2.6.2-1build1_amd64.deb

apt install -f 

apt update

apt upgrade

sudo apt-get install network-manager-openvpn network-manager-openvpn-gnome network-manager-pptp network-manager-vpnc'
