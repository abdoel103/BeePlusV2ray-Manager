#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "            RENEW USER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

USERS=()

while IFS=: read -r USER _ USER_ID _ _ HOME SHELL; do
    if [ "$USER_ID" -ge 1000 ] && \
       [ "$USER" != "nobody" ] && \
       [ "$USER" != "beeplus" ]; then
        USERS+=("$USER")
    fi
done < /etc/passwd

if [ ${#USERS[@]} -eq 0 ]; then
    echo "No users found."
    echo
    read -n1 -rsp "Press any key..."
    break
fi

i=1
for USER in "${USERS[@]}"; do
    EXPIRE=$(chage -l "$USER" | awk -F": " '/Account expires/{print $2}')
    [ -z "$EXPIRE" ] && EXPIRE="Never"
    printf "[%02d] %-20s %s\n" "$i" "$USER" "$EXPIRE"
    i=$((i+1))
done

echo
echo "[b] Back"
echo "[0] Exit"
echo

read -rp "Select: " OPTION

case "$OPTION" in
    b|B)
        break
        ;;
    0)
        exit 0
        ;;
esac

if ! [[ "$OPTION" =~ ^[0-9]+$ ]]; then
    continue
fi

INDEX=$((OPTION-1))

if [ "$INDEX" -lt 0 ] || [ "$INDEX" -ge "${#USERS[@]}" ]; then
    continue
fi

USER="${USERS[$INDEX]}"

echo
read -rp "Extend for how many days? : " DAYS

if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Invalid number."
    sleep 2
    continue
fi

NEWDATE=$(date -d "+$DAYS days" +%F)

chage -E "$NEWDATE" "$USER"

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "      USER RENEWED SUCCESSFULLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Username : $USER"
echo "New Expire Date : $NEWDATE"
echo

read -n1 -rsp "Press any key..."

done
