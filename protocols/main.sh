#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

while true; do
    clear
    banner

    echo -e "${GREEN}SERVICE:${RESET} OPENSSH        ${YELLOW}PORT:${RESET} 22"
    echo -e "${GREEN}SERVICE:${RESET} WEBSOCKET      ${YELLOW}PORTS:${RESET} JSON CONFIG"
    echo -e "${GREEN}SERVICE:${RESET} SSL TUNNEL     ${YELLOW}PORT:${RESET} 443"
    echo -e "${GREEN}SERVICE:${RESET} DROPBEAR       ${YELLOW}PORT:${RESET} 110"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • OPENSSH      ◉"
    echo "[02] • SQUID PROXY  ○"
    echo "[03] • DROPBEAR     ◉"
    echo "[04] • WEBSOCKET    ◉"
    echo "[05] • SSL TUNNEL   ◉"
    echo "[06] • SLOWDNS      ○"
    echo
    echo "[07] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select: " opt

    case "$opt" in
        01|1)
            bash "$DIR/protocols/openssh.sh"
            ;;
        02|2)
            bash "$DIR/protocols/squid.sh"
            ;;
        03|3)
            bash "$DIR/protocols/dropbear.sh"
            ;;
        04|4)
            bash "$DIR/protocols/websocket.sh"
            ;;
        05|5)
            bash "$DIR/protocols/ssl.sh"
            ;;
        06|6)
            bash "$DIR/protocols/slowdns.sh"
            ;;
        07|7)
            bash "$DIR/menu/main.sh"
            exit
            ;;
        00|0)
            exit
            ;;
        *)
            echo
            echo "Invalid Option"
            sleep 1
            ;;
    esac
done
