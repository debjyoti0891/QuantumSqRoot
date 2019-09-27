#!/bin/sh
NAME=`echo "$1" | cut -d'.' -f1`
revkit << EOF
read_pla $1
embed -b
tbs -s
ps -c
write_real "$NAME.real"
EOF
