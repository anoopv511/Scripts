#!/bin/bash

num=$(wmctrl -d | wc -l)			# Number of Workspaces
curr=$(xdotool get_desktop)			# Current Workspace
mx=9								# Maximum Workspaces
win=$(xdotool getwindowfocus)		# Window ID
if [[ curr+1 -lt num ]]; then
	# Move window and switch to Right Desktop if exists
	wmctrl -i -r $win -t $(((curr+1)%mx)) && wmctrl -i -a $win
elif [[ num -lt mx ]]; then
	# Create new Desktop to right, move window and switch 
	wmctrl -n $((num+1)) && wmctrl -i -r $win -t $num && wmctrl -i -a $win
else
	# Move window while looping around if num >= max
	wmctrl -i -r $win -t $(((curr+1)%mx)) && wmctrl -i -a $win
fi