#!/bin/bash

if [ $# -eq 0 ]
then
	echo "No input file"
	exit 1
fi

out="$(echo $1 | cut -d . -f 1)"
cython3 --embed -o "$out.c" $1
gcc -Os -I /usr/include/python3.5m -I /usr/local/lib/python3.5/dist-packages/numpy/core/include/ -o $out "$out.c" -lpython3.5m ${*:2}