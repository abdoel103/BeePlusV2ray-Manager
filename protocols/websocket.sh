#!/bin/bash

DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

CONFIG="/etc/beeplusv2ray/websocket.conf"

mkdir -p /etc/beeplusv2ray

# default port
if [ ! -s "$CONFIG" ]; then
    echo "80" > "$CONFIG"
fi


while true; do

clear
banner

echo
echo -e "${GREEN}WEBSOCKET PORTS${RESET}"
echo

nl -s " - " "$CONFIG"

echo
echo "=========================="
echo "[1] Add Port"
echo "[2] Remove Port"
echo "[3] Restart WebSocket"
echo "[4] Enable Service"
echo "[5] Disable Service"
echo "[0] Back"
echo

read -p "Select: " opt


case $opt in


1)

read -p "New Port: " PORT

if grep -qx "$PORT" "$CONFIG"; then
    echo "Port already exists."
else
    echo "$PORT" >> "$CONFIG"
    echo "Port added."
fi

systemctl restart beeplus-websocket 2>/dev/null

;;

2)

read -p "Port to remove: " PORT

if [ "$PORT" = "80" ]; then
    echo "Default port 80 cannot be removed."
else
    sed -i "/^$PORT$/d" "$CONFIG"
    echo "Port removed."
fi

systemctl restart beeplus-websocket 2>/dev/null

;;


3)

systemctl restart beeplus-websocket

echo "Restarted."

;;


4)

systemctl enable --now beeplus-websocket

;;


5)

systemctl disable --now beeplus-websocket

;;


0)

exit

;;


esac

done
