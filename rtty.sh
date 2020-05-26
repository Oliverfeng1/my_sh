#!/bin/bash
run_rtty()
{
    local token="1511538315d93ef875a2045ff5e26186"
    local uuid="$(uuidgen | sed 's/-//g')"
    local platform="$(cat /etc/os-release | grep "^NAME=" | cut -d = -f 2 | sed "s/\"//g")"
    local device_id="$uuid"
    local serverIp="39.97.162.144"
    sudo rtty -I "$device_id" -h $serverIp -p 5912 \
        -a -v -d "$platform" \
        -t $token
}
