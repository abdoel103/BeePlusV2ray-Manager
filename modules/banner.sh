#!/usr/bin/env bash

banner() {

    echo -e "${CYAN}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "              BeePlusV2ray Manager"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${GREEN}Version : ${RESET}$(cat /etc/beeplus/VERSION 2>/dev/null || echo DEV)"
    echo -e "${GREEN}OS      : ${RESET}$(. /etc/os-release && echo "$PRETTY_NAME")"
    echo -e "${GREEN}Kernel  : ${RESET}$(uname -r)"
    echo -e "${GREEN}Uptime  : ${RESET}$(uptime -p)"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${RESET}"
}
