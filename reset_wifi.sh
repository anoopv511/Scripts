#!/bin/bash

sel=2
if [ $# -gt 0 ] && [ $1 -eq 1 ]; then
	sel=1
fi

shopt -s expand_aliases
source ~/.bash_aliases
ssudo modprobe -rv rtl8723be
ssudo modprobe -v rtl8723be ant_sel=$sel