#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

    clear

    WS_PORTS=$(python3 "$DIR/tools/config.py" websocket list | paste -sd "," -)
    [ -z "$WS_PORTS" ] && WS_PORTS="80"

    echo -e "${GREEN}SERVICE:${RESET} OPENSSH        ${YELLOW}PORT:${RESET} 22"
    echo -e "${GREEN}SERVICE:${RESET} WEBSOCKET      ${YELLOW}PORTS:${RESET} ${WS_PORTS}"
    echo -e "${GREEN}SERVICE:${RESET} SSL TUNNEL     ${YELLOW}PORT:${RESET} 443"
    echo -e "${GREEN}SERVICE:${RESET} DROPBEAR       ${YELLOW}PORT:${RESET} 110"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    echo -e "[01] • OPENSSH      ${YELLOW}●${RESET}"
    echo -e "[02] • SQUID PROXY  ${RED}○${RESET}"
    echo -e "[03] • DROPBEAR     ${YELLOW}●${RESET}"
    echo -e "[04] • WEBSOCKET    ${YELLOW}●${RESET}"
    echo -e "[05] • SSL TUNNEL   ${YELLOW}●${RESET}"
    echo -e "[06] • SLOWDNS      ${RED}○${RESET}"

    echo
    echo "[07] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select: " option

    case "$option" in
        01|1) bash "$DIR/protocols/openssh.sh" ;;
        02|2) bash "$DIR/protocols/squid.sh" ;;
        03|3) bash "$DIR/protocols/dropbear.sh" ;;
        04|4) bash "$DIR/protocols/websocket.sh" ;;
        05|5) bash "$DIR/protocols/ssl.sh" ;;
        06|6) bash "$DIR/protocols/slowdns.sh" ;;
        07|7) break ;;
        00|0) exit 0 ;;
    esac

done
