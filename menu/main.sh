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
echo
echo " [0] EXIT"
echo

read -p "Select Option : " option

case $option in

1)
    bash /usr/local/beeplus/modules/badvpn.sh
    ;;

2)
    bash /usr/local/beeplus/modules/users.sh
    ;;

3)
    bash /usr/local/beeplus/protocols/main.sh
    ;;

0)
    exit
    ;;

*)
    echo
    echo "Invalid Option"
    sleep 1
    ;;

esac

done
