#!/bin/bash

udevadm monitor --udev --property | while read -r line; do
    # Detect when event starts
    if [[ "$line" == "UDEV" ]]; then
        event=""
        device=""
    fi

    # Capture the action (add/remove/change)
    if [[ "$line" == ACTION=* ]]; then
        event="${line#ACTION=}"
    fi

    # Capture device subsystem (like usb, sound, etc.)
    if [[ "$line" == SUBSYSTEM=* ]]; then
        device="${line#SUBSYSTEM=}"
    fi

    # When a full event ends (empty line)
    if [[ -z "$line" ]]; then
        if [[ "$event" == "remove" ]]; then
            echo "Device removed from subsystem: $device"
            # Put your hyprctl command here, e.g.:
	    hyprctl notify 2 1000 0 "device unplugged"
        fi
    fi
done
