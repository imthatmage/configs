#!/bin/bash

TIMER_FILE="/var/tmp/waybar_timer"

case "$1" in
    up)
        if [ -f "$TIMER_FILE" ] && [ "$(cat "$TIMER_FILE")" != "READY" ]; then
           
            CURRENT_TIMER=$(cat "$TIMER_FILE")
        else

            CURRENT_TIMER=$(date +%s)
        fi

        if [ "$CURRENT_TIMER" != "READY" ]; then
            NEW_TIMER=$((CURRENT_TIMER + 5 * 60))
     
            echo $NEW_TIMER > "$TIMER_FILE"
        fi

        echo $(date -d @$CURRENT_TIMER +%M:%S)
        ;;

    down)

        if [ -f "$TIMER_FILE" ] && [ "$(cat "$TIMER_FILE")" != "READY" ]; then

            CURRENT_TIMER=$(cat "$TIMER_FILE")
        else

            CURRENT_TIMER=$(date +%s)
        fi

        NEW_TIMER=$((CURRENT_TIMER - 5 * 60))

        if [ "$NEW_TIMER" -lt "$CURRENT_TIMER" ]; then

            echo "$NEW_TIMER" > "$TIMER_FILE"
           
            echo $(date -d @"$NEW_TIMER" +%M:%S)
        else
            
            echo "READY" > "$TIMER_FILE"
        fi
        ;;

    *)
        echo "The wrong option was chosen. Choose up or down."
        ;;
esac
