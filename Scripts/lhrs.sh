#!/bin/sh
NAME=`echo "$1" | cut -d'.' -f1`
revkit << EOF
read_aiger $1
lhrs -plk 20
ps -c
write_real "$NAME.real"
EOF
