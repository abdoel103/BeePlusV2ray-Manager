#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           ONLINE USERS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

FOUND=0

printf "%-15s %-18s %-12s\n" "USERNAME" "IP ADDRESS" "LOGIN TIME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

while read -r USER TTY DATE TIME IDLE PID COMMENT HOST; do

    [ "$USER" = "USERNAME" ] && continue

    IP=$(echo "$HOST" | tr -d '()')

    printf "%-15s %-18s %-12s\n" "$USER" "$IP" "$DATE $TIME"

    FOUND=1

done < <(who)

if [ "$FOUND" -eq 0 ]; then
    echo
    echo "No users are currently online."
fi

echo
echo "[r] Refresh"
echo "[b] Back"
echo "[0] Exit"
echo

read -rp "Select: " OPTION

case "$OPTION" in
    r|R)
        continue
        ;;
    b|B)
        break
        ;;
    0)
        exit 0
        ;;
esac

done
