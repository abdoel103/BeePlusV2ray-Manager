#!/usr/bin/env bash

DIR="/usr/local/beeplus"
source "$DIR/modules/colors.sh"

while true; do
    clear

    WS_PORTS=$(python3 "$DIR/tools/config.py" websocket list | paste -sd "," -)
    [ -z "$WS_PORTS" ] && WS_PORTS="80"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "             WEBSOCKET"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo -e "${GREEN}STATUS:${RESET} ${YELLOW}RUNNING${RESET}"
    echo -e "${GREEN}PORTS:${RESET} ${YELLOW}${WS_PORTS}${RESET}"
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • ADD PORT"
    echo "[02] • REMOVE PORT"
    echo "[03] • RESTART SERVICE"
    echo "[04] • STATUS"
    echo
    echo "[07] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select Option : " option

    case "$option" in
        1|01)
            read -rp "Port: " PORT
            python3 "$DIR/tools/config.py" websocket add-port "$PORT"
            systemctl restart beeplus-websocket
            ;;

        2|02)
            read -rp "Port: " PORT
            python3 "$DIR/tools/config.py" websocket remove-port "$PORT"
            systemctl restart beeplus-websocket
            ;;

        3|03)
            systemctl restart beeplus-websocket
            echo "Restarted."
            read -n1 -rsp "Press any key..."
            ;;

        4|04)
            systemctl --no-pager --full status beeplus-websocket
            read -n1 -rsp "Press any key..."
            ;;

        7|07)
            break
            ;;

        0|00)
            exit 0
            ;;
    esac
done
