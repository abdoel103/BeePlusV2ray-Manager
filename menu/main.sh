#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

while true; do

    clear

    RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
    RAM_USED=$(free | awk '/Mem:/ {printf "%.2f%%", $3/$2*100}')
    CPU=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f%%", $2+$4}')
    CORES=$(nproc)
    OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2 | sed 's/GNU\/Linux//')
    TIME=$(date +"%H:%M:%S")

    ONLINE_USERS=$(ps -ef | grep "sshd: " | grep -v grep | grep -v "\[priv\]" | wc -l)

    echo -e "${CYAN}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "               ⇱ BEE PLUS MANAGER ⇲"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${GREEN}SYSTEM             RAM MEMORY       PROCESSOR${RESET}"
    echo -e "${GREEN}OS:${RESET} ${YELLOW}${OS}${RESET}    ${GREEN}Total:${RESET} ${YELLOW}${RAM_TOTAL}${RESET}    ${GREEN}Cores:${RESET} ${YELLOW}${CORES}${RESET}"
    echo -e "${GREEN}Time:${RESET} ${YELLOW}${TIME}${RESET}       ${GREEN}In use:${RESET} ${YELLOW}${RAM_USED}${RESET}   ${GREEN}In use:${RESET} ${YELLOW}${CPU}${RESET}"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${GREEN}Online:${RESET} ${YELLOW}${ONLINE_USERS}${RESET}        ${GREEN}Expired:${RESET} ${YELLOW}0${RESET}       ${GREEN}Total:${RESET} ${YELLOW}0${RESET}"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${GREEN}[01] • ADD/REMOVE USER${RESET}           ${GREEN}[03] • BAD VPN ○${RESET}"
    echo -e "${GREEN}[02] • PROTOCOLS${RESET}                 ${GREEN}[00] • EXIT <<<${RESET}"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo

    read -rp "Select Option : " option

    case "$option" in

        01|1)
            bash "$DIR/modules/users/main.sh"
            ;;

        02|2)
            bash "$DIR/protocols/main.sh"
            ;;

        03|3)
            bash "$DIR/modules/badvpn.sh"
            ;;

        00|0)
            exit 0
            ;;

        *)
            echo "Invalid Option"
            sleep 1
            ;;

    esac

done
