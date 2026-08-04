#!/usr/bin/env bash

set -e

INSTALL_DIR="/usr/local/beeplus"

echo
echo "=========================================="
echo "      BeePlus Installation Setup"
echo "=========================================="

echo
echo "[1/7] Installing required packages..."

apt update

apt install -y \
python3 \
python3-pip \
openssh-server \
dropbear \
stunnel4 \
openssl

echo
echo "[2/7] Creating directories..."

mkdir -p "$INSTALL_DIR/config"
mkdir -p "$INSTALL_DIR/tools"
mkdir -p "$INSTALL_DIR/websocket"

echo
echo "[3/7] Setting permissions..."

chmod +x "$INSTALL_DIR"/tools/*.py 2>/dev/null || true
chmod +x "$INSTALL_DIR"/websocket/*.py 2>/dev/null || true
chmod +x "$INSTALL_DIR"/menu/*.sh
chmod +x "$INSTALL_DIR"/modules/*.sh
chmod +x "$INSTALL_DIR"/protocols/*.sh

echo
echo "[4/7] Creating default configuration..."

if [ ! -f "$INSTALL_DIR/config/websocket.json" ]; then
cat > "$INSTALL_DIR/config/websocket.json" <<CFG
{
    "enabled": true,
    "target_host": "127.0.0.1",
    "target_port": 22,
    "ports": [80]
}
CFG
fi

if [ ! -f "$INSTALL_DIR/config/openssh.json" ]; then
cat > "$INSTALL_DIR/config/openssh.json" <<CFG
{
    "ports": [22]
}
CFG
fi

if [ ! -f "$INSTALL_DIR/config/dropbear.json" ]; then
cat > "$INSTALL_DIR/config/dropbear.json" <<CFG
{
    "ports": [110]
}
CFG
fi

if [ ! -f "$INSTALL_DIR/config/ssl.json" ]; then
cat > "$INSTALL_DIR/config/ssl.json" <<CFG
{
    "ports": [443],
    "target_host": "127.0.0.1",
    "target_port": 22
}
CFG
fi

echo
echo "[5/7] Creating SSL certificate..."

mkdir -p /etc/stunnel

if [ ! -f /etc/stunnel/stunnel.pem ]; then

openssl req \
-new \
-newkey rsa:2048 \
-days 3650 \
-nodes \
-x509 \
-subj "/C=US/ST=BeePlus/L=BeePlus/O=BeePlus/CN=localhost" \
-keyout /etc/stunnel/stunnel.key \
-out /etc/stunnel/stunnel.crt

cat \
/etc/stunnel/stunnel.key \
/etc/stunnel/stunnel.crt \
> /etc/stunnel/stunnel.pem

chmod 600 /etc/stunnel/stunnel.pem

fi

echo
echo "[6/7] Installing services..."

python3 "$INSTALL_DIR/tools/generate_sshd.py"
python3 "$INSTALL_DIR/tools/generate_dropbear.py"
python3 "$INSTALL_DIR/tools/generate_stunnel.py"

cp -f "$INSTALL_DIR/services/beeplus-websocket.service" \
/etc/systemd/system/

cp -f "$INSTALL_DIR/services/beeplus-dropbear.service" \
/etc/systemd/system/

systemctl daemon-reload

systemctl enable ssh
systemctl restart ssh

systemctl enable beeplus-websocket
systemctl restart beeplus-websocket

systemctl enable beeplus-dropbear
systemctl restart beeplus-dropbear

systemctl enable stunnel4
systemctl restart stunnel4

echo
echo "[7/7] Creating command..."

cat > /usr/local/bin/bpm <<EOL
#!/bin/bash
cd $INSTALL_DIR
exec bash menu/main.sh
EOL

chmod +x /usr/local/bin/bpm

echo
echo "=========================================="
echo " Installation Completed Successfully "
echo "=========================================="

echo
echo "Run:"
echo
echo "bpm"
echo
