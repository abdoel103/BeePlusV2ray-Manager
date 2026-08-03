#!/usr/bin/env bash

source /usr/local/beeplus/modules/colors.sh

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "          ADD USER (PASSWORD)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -rp "Username : " USERNAME

if id "$USERNAME" >/dev/null 2>&1; then
    echo
    echo "User already exists."
    read -n1 -r -p "Press any key..."
    exit 0
fi

read -rsp "Password : " PASSWORD
echo

read -rp "Expire (days): " DAYS

useradd -m -s /bin/bash "$USERNAME"

echo "${USERNAME}:${PASSWORD}" | chpasswd

EXPIRE_DATE=$(date -d "+$DAYS days" +%F)

chage -E "$EXPIRE_DATE" "$USERNAME"

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "      USER CREATED SUCCESSFULLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "Username : $USERNAME"
echo "Password : $PASSWORD"
echo "Expire   : $EXPIRE_DATE"
echo

read -n1 -r -p "Press any key..."
