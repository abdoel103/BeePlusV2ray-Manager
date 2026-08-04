#!/usr/bin/env bash

DIR="/usr/local/beeplus"
source "$DIR/modules/colors.sh"

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        GENERATE SSH KEY"
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

mkdir -p /root/keys

ssh-keygen \
-t rsa \
-b 4096 \
-m PEM \
-f /root/keys/"$USERNAME" \
-N "" >/dev/null

mkdir -p /home/"$USERNAME"/.ssh

cp /root/keys/"$USERNAME".pub \
/home/"$USERNAME"/.ssh/authorized_keys

chown -R "$USERNAME":"$USERNAME" \
/home/"$USERNAME"/.ssh

chmod 700 /home/"$USERNAME"/.ssh
chmod 600 /home/"$USERNAME"/.ssh/authorized_keys

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "       USER CREATED SUCCESSFULLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

echo "Username : $USERNAME"
echo "Password : $PASSWORD"
echo "Expire   : $EXPIRE_DATE"
echo

echo "Private Key:"
echo "/root/keys/$USERNAME"
echo

echo "Public Key:"
echo "/root/keys/$USERNAME.pub"
echo

read -n1 -r -p "Press any key..."

