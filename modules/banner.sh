#!/usr/bin/env

banner() {
clear
echo -e "${CYAN}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           BeePlusV2ray Manager"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}Version : $(cat /etc/beeplus/VERSION 2>/dev/null || echo DEV)"
echo -e "OS      : $(. /etc/os-release && echo $PRETTY_NAME)"
echo -e "Kernel  : $(uname -r)"
echo -e "Uptime  : $(uptime -p)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${RESET}"
}
