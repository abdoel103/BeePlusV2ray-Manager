#!/bin/bash

BASE="/usr/local/beeplus"

CONFIG="$BASE/config/websocket.json"
TOOL="$BASE/tools/config.py"

while true
do

clear

echo "================================="
echo "       WEBSOCKET MANAGER"
echo "================================="

echo
echo "Active Ports:"
echo

python3 "$TOOL" websocket list

echo
echo "-----------------------------"
echo "[1] Add Port"
echo "[2] Remove Port"
echo "[3] Restart Service"
echo "[0] Back"
echo

read -p "Select: " option


case $option in

1)

read -p "Enter new port: " PORT

python3 "$TOOL" websocket add-port "$PORT"

systemctl restart beeplus-websocket

echo "Port added."
sleep 2

;;


2)

read -p "Enter port to remove: " PORT

python3 "$TOOL" websocket remove-port "$PORT"

systemctl restart beeplus-websocket

sleep 2

;;


3)

systemctl restart beeplus-websocket

echo "Restarted."
sleep 2

;;


0)

exit

;;

*)

echo "Invalid option"
sleep 2

;;

esac

done
