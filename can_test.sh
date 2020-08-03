#!/bin/sh
ip link set can0 down
ip link can0 type can bitrate 250000
ip link set can0 up
candump can0
