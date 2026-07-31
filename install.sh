#!/bin/bash

set -e

REPO="abdoel103/BeePlusV2ray-Manager"
BRANCH="main"
INSTALL_DIR="/usr/local/beeplus"

echo "=========================================="
echo "      BeePlusV2ray Manager Installer"
echo "=========================================="

# Root Check
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run as root."
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "[ERROR] Unsupported operating system."
    exit 1
fi

case "$ID" in
    debian|ubuntu)
        ;;
    *)
        echo "[ERROR] Only Debian and Ubuntu are supported."
        exit 1
        ;;
esac

echo "[INFO] Installing dependencies..."

apt update

apt install -y git curl wget unzip

echo "[INFO] Downloading BeePlusV2ray Manager..."

rm -rf "$INSTALL_DIR"

git clone https://github.com/$REPO.git "$INSTALL_DIR"

chmod -R +x "$INSTALL_DIR"

cd "$INSTALL_DIR"

bash installer/install.sh
