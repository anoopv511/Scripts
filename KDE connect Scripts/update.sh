#!/bin/bash

# Script to update/upgrade and clear cache using KDE connect
# Do not use this script frequently [use only when there are upgrades]

shopt -s expand_aliases
source ~/.bash_aliases
ssudo apt update
apt list --upgradeable 1> ~/.avl-upgrades 2>/dev/null
ssudo apt -y upgrade
ssudo apt -y clean
ssudo apt -y autoclean
ssudo apt -y autoremove
notify-send -i ~/.local/share/icons/software-update.png -t 10000 "Finished updating" "$(cat ~/.avl-upgrades | grep -o '^[^/]*' | grep -v '\.\.\.$' | paste -sd ' ' -)" 