#!/bin/bash

num=$(wmctrl -d | wc -l)			# Number of Workspaces
curr=$(xdotool get_desktop)			# Current Workspace
wmctrl -n $((curr < num-1 ? (curr+2) : (curr+1)))				# Delete all Workspaces to the right + 1