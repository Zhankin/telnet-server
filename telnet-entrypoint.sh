#!/bin/sh
if [ "$USERPASS" = "**String**" ]; then
    export USERPASS='production'
fi
echo root:${USERPASS} | chpasswd
