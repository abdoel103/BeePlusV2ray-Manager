#!/usr/bin/env bash

# System Functions

function detect_os() {

    if [ -f /etc/debian_version ]; then
        OS="debian"
    else
        OS="unknown"
    fi

}


function check_dependencies() {

    for cmd in curl wget python3 systemctl; do

        if ! command -v $cmd >/dev/null 2>&1; then
            warning "$cmd not installed"
        fi

    done

}
