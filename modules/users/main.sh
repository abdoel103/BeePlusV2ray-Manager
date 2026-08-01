#!/usr/bin/env bash

DIR="/usr/local/beeplus"

while true; do

    clear

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "          USER MANAGEMENT"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    echo "[01] • ADD USER (PASSWORD)"
    echo "[02] • ADD USER (PUBLIC KEY)"
    echo "[03] • LIST USERS"
    echo "[04] • DELETE USER"
    echo "[05] • RENEW USER"
    echo "[06] • CHANGE PASSWORD"
    echo "[07] • LOCK / UNLOCK USER"
    echo "[08] • ONLINE USERS"
    echo
    echo "[09] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select: " OPTION

    case "$OPTION" in
        01|1) bash "$DIR/modules/users/add_password.sh" ;;
        02|2) bash "$DIR/modules/users/add_publickey.sh" ;;
        03|3) bash "$DIR/modules/users/list.sh" ;;
        04|4) bash "$DIR/modules/users/delete.sh" ;;
        05|5) bash "$DIR/modules/users/renew.sh" ;;
        06|6) bash "$DIR/modules/users/password.sh" ;;
        07|7) bash "$DIR/modules/users/lock.sh" ;;
        08|8) bash "$DIR/modules/users/online.sh" ;;
        09|9) break ;;
        00|0) exit 0 ;;
    esac

done
