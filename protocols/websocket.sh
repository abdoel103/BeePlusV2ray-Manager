
#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

CONFIG="/etc/beeplusv2ray/websocket.conf"

mkdir -p /etc/beeplusv2ray
touch "$CONFIG"

while true; do
    clear
    banner

    echo "PORTS:"
    echo

    if [ -s "$CONFIG" ]; then
        cat "$CONFIG"
    else
        echo "No ports configured."
    fi

    echo
    echo "[1] Add Port"
    echo "[2] Remove Port"
    echo "[3] Restart WebSocket"
    echo "[4] Enable"
    echo "[5] Disable"
    echo
    echo "[0] Back"
    echo

    read -rp "Select: " opt

    case "$opt" in

        1)
            read -rp "New Port: " PORT
            echo "$PORT" >> "$CONFIG"
            sort -u "$CONFIG" -o "$CONFIG"
            systemctl restart beeplus-websocket 2>/dev/null
            ;;

        2)
            read -rp "Port to remove: " PORT
            sed -i "/^${PORT}$/d" "$CONFIG"
            systemctl restart beeplus-websocket 2>/dev/null
            ;;

        3)
            systemctl restart beeplus-websocket
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
