#!/usr/bin/env bash

DIR="/usr/local/beeplus"

while true; do

clear

PORTS=$(python3 "$DIR/tools/config.py" dropbear list | paste -sd "," -)

[ -z "$PORTS" ] && PORTS="110"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           DROPBEAR SSH"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Running Ports : $PORTS"
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "[1] Add Port"
echo "[2] Remove Port"
echo "[3] Back"
echo "[0] Exit"
echo

read -rp "Select : " opt

case "$opt" in

1)

read -rp "New Port : " port

python3 "$DIR/tools/config.py" dropbear add-port "$port"

sleep 3

;;

2)

read -rp "Remove Port : " port

python3 "$DIR/tools/config.py" dropbear remove-port "$port"

sleep 3

;;

3)

break

;;

0)

exit 0

;;

esac

done
