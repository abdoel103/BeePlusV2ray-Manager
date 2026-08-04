#!/usr/bin/env bash

DIR="/usr/local/beeplus"
source "$DIR/modules/colors.sh"

while true; do
    clear

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "            SSH KEY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • GENERATE SSH KEY"
    echo "[02] • ADD CUSTOM KEY"
    echo
    echo "[03] • BACK"
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
