#!/bin/bash

# Script to get laptop battery status using KDE connect

upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E --color=never "time\ to|percentage" | tac | sed 's/  */ /g' | sed 's/^[ \t]*//' | sed 's/.*/\u&/' | paste -sd '|' - | sed 's/|/ | /g' | while read BAT; do notify-send -i ~/.local/share/icons/battery.png "Battery Status" "$BAT"; done