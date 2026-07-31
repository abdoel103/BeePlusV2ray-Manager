
#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

while true; do
    banner

    echo -e "${GREEN}SERVICE:${RESET} OPENSSH        ${YELLOW}PORT:${RESET} 22"
    echo -e "${GREEN}SERVICE:${RESET} PROXY SOCKS    ${YELLOW}PORT:${RESET} 8880"
    echo -e "${GREEN}SERVICE:${RESET} SSL TUNNEL     ${YELLOW}PORT:${RESET} 443"
    echo -e "${GREEN}SERVICE:${RESET} DROPBEAR       ${YELLOW}PORT:${RESET} 110"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • OPENSSH      ◉"
    echo "[02] • SQUID PROXY  ○"
    echo "[03] • DROPBEAR     ◉"
    echo "[04] • PROXY SOCKS  ◉"
    echo "[05] • SSL TUNNEL   ◉"
    echo "[06] • SLOWDNS      ○"
    echo
    echo "[07] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select: " opt

    case "$opt" in
        1) bash "$DIR/protocols/openssh.sh" ;;
        2) bash "$DIR/protocols/squid.sh" ;;
        3) bash "$DIR/protocols/dropbear.sh" ;;
        4) bash "$DIR/protocols/websocket.sh" ;;
        5) bash "$DIR/protocols/ssl.sh" ;;
        6) bash "$DIR/protocols/slowdns.sh" ;;
        7) bash "$DIR/menu/main.sh"; exit ;;
        0) exit ;;
    esac
done
