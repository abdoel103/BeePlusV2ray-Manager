#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do
    clear

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "            DELETE USER"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo

    USERS=()

    while IFS=: read -r USER _ UID _ _ HOME SHELL; do
        if [ "$UID" -ge 1000 ] && \
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
    echo "Selected user : $USER"
    echo

    read -rp "Delete home directory too? [Y/n]: " REMOVEHOME

    if [[ "$REMOVEHOME" =~ ^[Nn]$ ]]; then
        userdel "$USER"
    else
        userdel -r "$USER"
    fi

    if [ $? -eq 0 ]; then
        echo
        success "User '$USER' deleted successfully."
    else
        echo
        error "Failed to delete user."
    fi

    echo
    read -n1 -rsp "Press any key to continue..."

done
