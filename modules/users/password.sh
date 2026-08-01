#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "         CHANGE PASSWORD"
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
    printf "[%02d] %s\n" "$i" "$USER"
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
read -rsp "New Password: " PASSWORD
echo

echo "${USER}:${PASSWORD}" | chpasswd

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    PASSWORD CHANGED SUCCESSFULLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Username : $USER"
echo "Password : $PASSWORD"
echo

read -n1 -rsp "Press any key..."

done
