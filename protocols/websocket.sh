#!/bin/bash

BASE="/usr/local/beeplus"
TOOL="$BASE/tools/config.py"

while true; do

clear

echo "================================="
echo "      WEBSOCKET MANAGER"
echo "================================="
echo

echo "Active Ports:"
echo "-----------------------------"
python3 "$TOOL" websocket list
echo "-----------------------------"
echo
echo "[01] Add Port"
echo "[02] Remove Port"
echo "[03] Restart Service"
echo "[00] Back"
echo

read -rp "Select: " option

case "$option" in

01|1)

    read -rp "Enter new port: " PORT

    if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
        echo
        echo "Invalid port."
        sleep 2
        continue
    fi

    python3 "$TOOL" websocket add-port "$PORT"
    systemctl restart beeplus-websocket

    echo
    echo "Port added successfully."
    sleep 2
    ;;

02|2)

    read -rp "Enter port to remove: " PORT

    if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
        echo
        echo "Invalid port."
        sleep 2
        continue
    fi

    python3 "$TOOL" websocket remove-port "$PORT"
    systemctl restart beeplus-websocket

    echo
    echo "Port removed."
    sleep 2
    ;;

03|3)

    systemctl restart beeplus-websocket

    echo
    echo "Service restarted."
    sleep 2
    ;;

00|0)

    break
    ;;

*)

    echo
    echo "Invalid Option."
    sleep 2
    ;;

esac

done

exit 0
