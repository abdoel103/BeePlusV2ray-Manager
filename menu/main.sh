#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/utils.sh"
source "$DIR/modules/banner.sh"

while true; do
    banner

    echo -e "${GREEN}[1]${RESET} Add / Remove User"
    echo -e "${GREEN}[2]${RESET} Protocols"
    echo -e "${GREEN}[3]${RESET} BadVPN"
    echo -e "${RED}[0]${RESET} Exit"
    echo
    read -rp "Select: " opt

    case "$opt" in
        1)
            bash "$DIR/modules/users.sh"
            ;;
        2)
            bash "$DIR/modules/protocols.sh"
            ;;
        3)
            bash "$DIR/modules/badvpn.sh"
            ;;
        0)
            clear
            exit
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done
