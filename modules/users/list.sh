#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do
    clear

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "             USER LIST"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    FOUND=0

    while IFS=: read -r USER _ USER_ID _ _ HOME SHELL; do

        if [ "$USER_ID" -ge 1000 ] && \
           [ "$USER" != "nobody" ] && \
           [ "$USER" != "beeplus" ]; then

            FOUND=1

            EXPIRE=$(chage -l "$USER" 2>/dev/null | awk -F": " '/Account expires/{print $2}')

            [ -z "$EXPIRE" ] && EXPIRE="Never"
            [ "$EXPIRE" = "never" ] && EXPIRE="Never"

            STATUS=$(passwd -S "$USER" 2>/dev/null | awk '{print $2}')

            case "$STATUS" in
                P) STATUS="PASSWORD" ;;
                L) STATUS="LOCKED" ;;
                NP) STATUS="NO PASSWORD" ;;
                *) STATUS="UNKNOWN" ;;
            esac

            if [ -f "/home/$USER/.ssh/authorized_keys" ]; then
                AUTH="PUBLIC KEY"
            else
                AUTH="$STATUS"
            fi

            echo "Username : $USER"
            echo "Auth     : $AUTH"
            echo "Expire   : $EXPIRE"
            echo "Home     : $HOME"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

        fi

    done < /etc/passwd

    if [ "$FOUND" -eq 0 ]; then
        echo "No users found."
        echo
    fi

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

done
