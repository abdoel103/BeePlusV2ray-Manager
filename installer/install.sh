#!/bin/bash

set -e

clear

echo "=========================================="
echo "       BeePlusV2ray Manager Installer"
echo "=========================================="

REPO="abdoel103/BeePlusV2ray-Manager"
BRANCH="backup-2026-08-01"

INSTALL_DIR="/usr/local/beeplus"


if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


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


cp -r "$TMP_DIR/websocket" \
"$INSTALL_DIR/"

cp -r "$TMP_DIR/config" \
"$INSTALL_DIR/"

cp -r "$TMP_DIR/tools" \
"$INSTALL_DIR/"

cp -r "$TMP_DIR/protocols" \
"$INSTALL_DIR/"

cp -r "$TMP_DIR/menu" \
"$INSTALL_DIR/"

cp -r "$TMP_DIR/modules" \
"$INSTALL_DIR/"



cp "$TMP_DIR/services/beeplus-websocket.service" \
/etc/systemd/system/



echo
echo "[6/8] Creating default config..."


if [ ! -f "$INSTALL_DIR/config/websocket.json" ]; then

cat > "$INSTALL_DIR/config/websocket.json" <<EOF
{
    "enabled": true,
    "target_host": "127.0.0.1",
    "target_port": 22,
    "ports": [
        80
    ]
}
EOF

fi



echo
echo "[7/8] Setting permissions and starting services..."


chmod +x "$INSTALL_DIR/websocket/ws.py"

chmod +x "$INSTALL_DIR/tools/config.py"

chmod +x "$INSTALL_DIR"/protocols/*.sh

chmod +x "$INSTALL_DIR"/menu/*.sh

chmod +x "$INSTALL_DIR"/modules/*.sh



systemctl daemon-reload

systemctl enable beeplus-websocket

systemctl restart beeplus-websocket



echo
echo "[8/8] Creating command..."


cat > /usr/local/bin/bpm <<EOF
#!/bin/bash
cd $INSTALL_DIR
bash menu/main.sh
EOF


cat > /usr/local/bin/menu <<EOF
#!/bin/bash
cd $INSTALL_DIR
bash menu/main.sh
EOF


chmod +x /usr/local/bin/bpm
chmod +x /usr/local/bin/menu



echo
echo "=========================================="
echo " Installation Completed Successfully "
echo "=========================================="

echo
echo "Run:"
echo
echo "menu"
echo
echo "or"
echo
echo "bpm"
echo
