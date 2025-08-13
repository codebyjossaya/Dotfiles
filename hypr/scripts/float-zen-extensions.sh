#!/bin/bash

hyprctl --batch "subscribeevent createwindow" | while read -r _; do
    clients=$(hyprctl clients -j)
    echo "$clients" | jq -c '.[]' | while read -r win; do
        class=$(echo "$win" | jq -r '.class')
        title=$(echo "$win" | jq -r '.title')
        addr=$(echo "$win" | jq -r '.address')
        floating=$(echo "$win" | jq -r '.floating')

        if [[ "$class" == "zen" && "$title" == *"Extension:"* && "$floating" == "false" ]]; then
            hyprctl dispatch togglefloating "$addr"
        fi
    done
done

