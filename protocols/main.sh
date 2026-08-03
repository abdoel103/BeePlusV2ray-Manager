#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

    clear

    OPENSSH_PORTS=$(python3 "$DIR/tools/config.py" openssh list 2>/dev/null | paste -sd "," -)
    [ -z "$OPENSSH_PORTS" ] && OPENSSH_PORTS="22"

    WS_PORTS=$(python3 "$DIR/tools/config.py" websocket list 2>/dev/null | paste -sd "," -)
    [ -z "$WS_PORTS" ] && WS_PORTS="80"

    SSL_PORTS=$(python3 "$DIR/tools/config.py" ssl list 2>/dev/null | paste -sd "," -)
    [ -z "$SSL_PORTS" ] && SSL_PORTS="443"

    DROPBEAR_PORTS=$(python3 "$DIR/tools/config.py" dropbear list 2>/dev/null | paste -sd "," -)
    [ -z "$DROPBEAR_PORTS" ] && DROPBEAR_PORTS="110"

    echo -e "${GREEN}SERVICE:${RESET} OPENSSH        ${YELLOW}PORTS:${RESET} ${OPENSSH_PORTS}"
    echo -e "${GREEN}SERVICE:${RESET} WEBSOCKET      ${YELLOW}PORTS:${RESET} ${WS_PORTS}"
    echo -e "${GREEN}SERVICE:${RESET} SSL TUNNEL     ${YELLOW}PORTS:${RESET} ${SSL_PORTS}"
    echo -e "${GREEN}SERVICE:${RESET} DROPBEAR       ${YELLOW}PORTS:${RESET} ${DROPBEAR_PORTS}"

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
