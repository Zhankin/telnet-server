#!/bin/sh
if [ "$USERPASS" = "**String**" ]; then
    export USERPASS='production'
fi
echo root:${USERPASS} | chpasswd

bash -c xinetd -dontfork -stayalive
exec /bin/bash -ec "while :; do echo '.'; sleep 5 ; done"
