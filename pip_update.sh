#!/bin/bash

if [ $# -eq 0 ] 
then
	echo "Updating python2.7 libraries"
	pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H -E pip2 install -U
	echo "----------------------------"
	echo "Updating python3.5 libraries"
	pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H -E pip3 install -U
	exit 1
fi

if [ $1 -eq 2 ] 
then
	echo "Updating python2.7 libraries"
	pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H -E pip2 install -U
else
	echo "Updating python3.5 libraries"
	pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 sudo -H -E pip3 install -U
fi