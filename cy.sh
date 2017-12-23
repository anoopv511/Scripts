#!/bin/bash

if [ $# -eq 0 ]
then
	echo "No input file"
	exit 1
fi

out="$(echo $1 | cut -d . -f 1)"
cython --embed -o "$out.c" $1
gcc -Os -I /usr/include/python2.7 /usr/local/lib/python2.7/dist-packages/numpy/core/include/ -o $out "$out.c" -lpython2.7 ${*:2}