#!/bin/bash

source /usr/local/beeplus/modules/colors.sh
source /usr/local/beeplus/modules/banner.sh

while true; do

clear

banner

echo
echo " [1] BADVPN"
echo " [2] ADD / REMOVE USER"
echo " [3] PROTOCOLS"
echo " [4] WEBSOCKET MANAGER"
echo
echo " [0] EXIT"
echo

read -rp "Select Option : " option

case "$option" in

01|1)
    bash /usr/local/beeplus/modules/badvpn.sh
    ;;

02|2)
    bash /usr/local/beeplus/modules/users.sh
    ;;

03|3)
    bash /usr/local/beeplus/protocols/main.sh
    ;;

04|4)
    bash /usr/local/beeplus/protocols/websocket.sh
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
