#!/usr/bin/env bash

DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$DIR/modules/colors.sh"
source "$DIR/modules/banner.sh"

while true; do

    clear
    banner

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "           USER MANAGEMENT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • ADD USER (PASSWORD)"
    echo "[02] • ADD USER (PUBLIC KEY)"
    echo "[03] • REMOVE USER"
    echo "[04] • RENEW USER"
    echo "[05] • CHANGE PASSWORD"
    echo "[06] • LIST USERS"
    echo "[07] • ONLINE USERS"
    echo
    echo "[08] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select: " option

    case "$option" in

        01|1)
            bash "$DIR/modules/users/add_password.sh"
            ;;

        02|2)
            bash "$DIR/modules/users/add_publickey.sh"
            ;;

        03|3)
            bash "$DIR/modules/users/remove.sh"
            ;;

        04|4)
            bash "$DIR/modules/users/renew.sh"
            ;;

        05|5)
            bash "$DIR/modules/users/passwd.sh"
            ;;

        06|6)
            bash "$DIR/modules/users/list.sh"
            ;;

        07|7)
            bash "$DIR/modules/users/online.sh"
            ;;

        08|8)
            break
            ;;

        00|0)
            exit 0
            ;;

        *)
            echo
            echo "Invalid Option"
            sleep 1
            ;;

    esac

done
