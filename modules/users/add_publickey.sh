#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "          PUBLIC KEY SSH"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "[01] • GENERATE NEW KEY"
echo "[02] • IMPORT PRIVATE KEY"
echo "[03] • PASTE PUBLIC KEY"
echo
echo "[04] • BACK"
echo "[00] • EXIT"
echo

read -rp "Select: " option

case "$option" in

1|01)
    bash "$DIR/modules/users/publickey/generate.sh"
    ;;

2|02)
    bash "$DIR/modules/users/publickey/import_private.sh"
    ;;

3|03)
    bash "$DIR/modules/users/publickey/paste_public.sh"
    ;;

4|04)
    break
    ;;

0|00)
    exit 0
    ;;

*)
    echo
    echo "Invalid Option"
    sleep 1
    ;;

esac

done
