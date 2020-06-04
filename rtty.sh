#!/bin/bash
token="1511538315d93ef875a2045ff5e26186"
serverIp="39.97.162.144"
uuid="$(uuidgen | sed 's/-//g')"
platform="$(cat /etc/os-release | grep "^NAME=" | cut -d = -f 2 | sed "s/\"//g")"
device_id="$uuid"
sudo rtty -I "$device_id" -h $serverIp -p 5912 \
    -a -v -d "$platform" \
    -t $token
