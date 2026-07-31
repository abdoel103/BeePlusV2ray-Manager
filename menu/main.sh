#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$BASE_DIR/modules/colors.sh"
source "$BASE_DIR/modules/utils.sh"
source "$BASE_DIR/modules/system.sh"


clear


function banner() {

echo -e "${CYAN}"
echo "╔══════════════════════════════════╗"
echo "       BeePlusV2ray Manager"
echo "      Debian & Ubuntu Edition"
echo "╚══════════════════════════════════╝"
echo -e "${RESET}"

}


function main_menu() {

while true
do

clear
banner

echo
echo -e "${GREEN}[1]${WHITE} Add / Remove User"
echo
echo -e "${GREEN}[2]${WHITE} Protocols"
echo
echo -e "${RED}[3]${WHITE} Exit"
echo

read -p "Select option: " option


case $option in

1)
    echo "User Manager"
    pause
;;

2)
    bash "$BASE_DIR/menu/protocols.sh"
;;

3)
    exit 0
;;

*)
    error "Invalid option"
    sleep 1
;;

esac

done

}


detect_os
check_dependencies
main_menu
