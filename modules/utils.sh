#!/usr/bin/env bash

# BeePlusV2ray Manager Utils

function pause() {
    read -p "Press Enter to continue..."
}

function check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "Please run as root"
        exit 1
    fi
}

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function install_package() {
    apt update -y
    apt install -y "$1"
}

function banner_line() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
