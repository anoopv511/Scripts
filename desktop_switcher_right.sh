#!/bin/bash

num=$(wmctrl -d | wc -l)			# Number of Workspaces
curr=$(xdotool get_desktop)			# Current Workspace
mx=9								# Maximum Workspaces
if [[ curr+1 -lt num ]]; then
	wmctrl -s $(((curr+1)%mx))					# Switch to Right Desktop if exists
elif [[ num -lt mx ]]; then
	wmctrl -n $((num+1)) && wmctrl -s $num 	# Create new Desktop to right and switch 
else
	wmctrl -s $(((curr+1)%mx))					# Loop around if num >= max
fi