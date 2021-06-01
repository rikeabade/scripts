#!/bin/bash

read -p 'Digite a senha do root: ' -s -r PASSWD


sudo dpkg --purge nextcloud-desktop

wget http://archive.ubuntu.com/ubuntu/pool/universe/n/nextcloud-desktop/nextcloud-desktop_2.6.2-1build1_amd64.deb

sudo dpkg -i nextcloud-desktop_2.6.2-1build1_amd64.deb

sudo apt install -f 



