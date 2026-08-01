#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

clear

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "            REMOVE USER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

USERS=$(awk -F: '$3>=1000 && $1!="nobody"{print $1}' /etc/passwd)

if [ -z "$USERS" ]; then
    echo "No users found."
    echo
    read -n1 -r -p "Press any key..."
    break
fi

echo "Existing Users:"
echo
echo "$USERS"
echo
echo "Type username to remove."
echo "Type b to go back."
echo "Type 0 to exit."
echo

read -rp "Username: " USERNAME

case "$USERNAME" in
    0)
        exit 0
        ;;
    b|B)
        break
        ;;
esac

if ! id "$USERNAME" >/dev/null 2>&1; then
    echo
    echo "User not found."
    sleep 2
    continue
fi

echo
read -rp "Remove '$USERNAME'? [y/N]: " CONFIRM

case "$CONFIRM" in
    y|Y)
        userdel -r "$USERNAME" 2>/dev/null
        rm -rf "$DIR/keys/$USERNAME"

        clear

        echo
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "      USER REMOVED SUCCESSFULLY"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo
        echo "Username : $USERNAME"
        echo
        read -n1 -r -p "Press any key..."
        ;;
    *)
        echo
        echo "Cancelled."
        sleep 2
        ;;
esac

done
