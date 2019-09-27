#!/bin/sh
NAME=`echo "$1" | cut -d'.' -f1`
revkit << EOF
read_aiger $1
xmglut -k 4
dxs
ps -c
write_real "$NAME.real"
EOF
