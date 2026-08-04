#!/bin/bash

set -e

clear

REPO="abdoel103/BeePlusV2ray-Manager"
BRANCH="devlop"
INSTALL_DIR="/usr/local/beeplus"

echo "=========================================="
echo "       BeePlusV2ray Manager Installer"
echo "=========================================="

echo
echo "[1/8] Updating packages..."

apt update

echo
echo "[2/8] Installing requirements..."

apt install -y \
python3 \
python3-pip \
git \
curl \
wget \
openssh-server \
dropbear \
stunnel4

echo
echo "[3/8] Preparing directories..."

mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/config"
mkdir -p "$INSTALL_DIR/websocket"
mkdir -p "$INSTALL_DIR/tools"

echo
echo "[4/8] Downloading BeePlusV2ray Manager..."

TMP_DIR="/tmp/BeePlusV2ray-Manager"

rm -rf "$TMP_DIR"

git clone \
-b "$BRANCH" \
"https://github.com/$REPO.git" \
"$TMP_DIR"

echo
echo "[5/8] Installing files..."

cp -rf "$TMP_DIR/websocket" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/config" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/tools" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/protocols" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/menu" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/modules" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/services" "$INSTALL_DIR/"
cp -rf "$TMP_DIR/installer" "$INSTALL_DIR/"

cp "$TMP_DIR/services/beeplus-websocket.service" /etc/systemd/system/

if [ -f "$TMP_DIR/services/beeplus-dropbear.service" ]; then
    cp "$TMP_DIR/services/beeplus-dropbear.service" /etc/systemd/system/
fi

echo
echo "[6/8] Creating default config..."

if [ ! -f "$INSTALL_DIR/config/websocket.json" ]; then
cat > "$INSTALL_DIR/config/websocket.json" <<EOL
{
    "enabled": true,
    "target_host": "127.0.0.1",
    "target_port": 22,
    "ports": [80]
}
EOL
fi

echo
echo "[7/8] Setting permissions..."

chmod -R +x "$INSTALL_DIR"

systemctl daemon-reload

systemctl enable beeplus-websocket
systemctl restart beeplus-websocket

if [ -f /etc/systemd/system/beeplus-dropbear.service ]; then
    systemctl enable beeplus-dropbear
    systemctl restart beeplus-dropbear || true
fi

echo
echo "[8/8] Creating command..."

cat > /usr/local/bin/menu <<EOL
#!/bin/bash
cd $INSTALL_DIR
exec bash menu/main.sh
EOL

chmod +x /usr/local/bin/menu
