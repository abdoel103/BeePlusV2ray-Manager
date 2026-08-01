#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        PASTE PUBLIC KEY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

read -rp "Username      : " USERNAME

if id "$USERNAME" >/dev/null 2>&1; then
    echo
    echo "User already exists."
    read -n1 -r -p "Press any key..."
    exit 0
fi

read -rsp "Password      : " PASSWORD
echo

read -rp "Expire (days) : " DAYS

echo
echo "Creating user..."

useradd -m -s /bin/bash "$USERNAME"

echo "${USERNAME}:${PASSWORD}" | chpasswd

EXPIRE_DATE=$(date -d "+$DAYS days" +%F)

chage -E "$EXPIRE_DATE" "$USERNAME"

mkdir -p "/home/$USERNAME/.ssh"

echo
echo "Paste your PUBLIC KEY."
echo "Nano will open."
echo "Save with CTRL+O then ENTER, exit with CTRL+X."
echo
read -n1 -r -p "Press any key..."

nano /tmp/public_key

cp /tmp/public_key "/home/$USERNAME/.ssh/authorized_keys"

chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"

chmod 700 "/home/$USERNAME/.ssh"

chmod 600 "/home/$USERNAME/.ssh/authorized_keys"

rm -f /tmp/public_key

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
echo "Authentication : Public Key"
echo
read -n1 -r -p "Press any key..."
