#!/bin/bash

clear

echo "=========================================="
echo "      BeePlusV2ray Manager"
echo "=========================================="

echo
echo "[1/7] Updating packages..."
apt update

echo
echo "[2/7] Installing required packages..."

apt install -y \
python3 \
python3-pip \
curl \
wget \
git \
net-tools \
lsof \
unzip \
zip \
screen \
cron \
dropbear \
stunnel4 \
openssh-server

echo
echo "[3/7] Creating directories..."

mkdir -p /etc/beeplusv2ray
mkdir -p /var/log/beeplus
mkdir -p /usr/local/beeplus

echo
echo "[4/7] Copying project files..."

cp -r modules /usr/local/beeplus/
cp -r websocket /usr/local/beeplus/
cp -r config /etc/beeplusv2ray/

echo
echo "[5/7] Setting permissions..."

chmod -R +x /usr/local/beeplus

echo
echo "[6/7] Creating shortcut..."

cat >/usr/local/bin/bpm <<'EOF'
#!/bin/bash
cd /usr/local/beeplus
bash menu.sh
EOF

chmod +x /usr/local/bin/bpm

echo
echo "[7/7] Installation completed."

echo
echo "=========================================="
echo "Installation Successful!"
echo
echo "Run:"
echo
echo "bpm"
echo
echo "=========================================="
