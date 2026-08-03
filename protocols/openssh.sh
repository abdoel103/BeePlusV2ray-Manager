#!/usr/bin/env bash

DIR="/usr/local/beeplus"

source "$DIR/modules/colors.sh"

while true; do

    clear

    SSH_PORTS=$(python3 "$DIR/tools/config.py" openssh list | paste -sd "," -)
    [ -z "$SSH_PORTS" ] && SSH_PORTS="22"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "              OPENSSH"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo -e "${GREEN}Current Ports:${RESET} ${YELLOW}${SSH_PORTS}${RESET}"
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "[01] • ADD PORT"
    echo "[02] • REMOVE PORT"
    echo "[03] • RESTART SSH"
    echo "[04] • STATUS"
    echo
    echo "[07] • BACK"
    echo "[00] • EXIT"
    echo

    read -rp "Select Option : " option

    case "$option" in

        1|01)

            read -rp "New Port : " PORT

            python3 "$DIR/tools/config.py" openssh add-port "$PORT"
            python3 "$DIR/tools/generate_sshd.py"
            systemctl restart ssh

            echo
            echo "Port added."

            read -n1 -rsp "Press any key..."
            ;;

        2|02)

            read -rp "Remove Port : " PORT

            python3 "$DIR/tools/config.py" openssh remove-port "$PORT"
            python3 "$DIR/tools/generate_sshd.py"
            systemctl restart ssh

            echo
            echo "Port removed."

            read -n1 -rsp "Press any key..."
            ;;

        3|03)

            python3 "$DIR/tools/generate_sshd.py"
            systemctl restart ssh

            echo
            echo "SSH restarted."

            read -n1 -rsp "Press any key..."
            ;;

        4|04)

            systemctl --no-pager status ssh

            echo
            read -n1 -rsp "Press any key..."
            ;;

        7|07)

            break
            ;;

        0|00)

            exit 0
            ;;

    esac

done
